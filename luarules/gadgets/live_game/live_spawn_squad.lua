function gadget:GetInfo()
	return {
		name	= "Live Game spawn squad",
		desc	= "Live Game spawn squad for joined players",
		author	= "eqd",
		date	= "August,2024",
		license = "-",
		layer	= 0,
		enabled = true,
	}
end
local Vec2 = _G.Vec2;
local Mat2 = _G.Mat2;
local LiveGame = nil;
local spCreateUnit = Spring.CreateUnit;
local spSetUnitTarget = Spring.SetUnitTarget;
local spGetGroundHeight = Spring.GetGroundHeight;
local spSetUnitDirection = Spring.SetUnitDirection;
local spSetTeamResource = Spring.SetTeamResource;
local spAppendUnitNoChaseCategory = Spring.AppendUnitNoChaseCategory;
local MaxEnergy = 9000000;
local spDestroyFeature = Spring.DestroyFeature;

local WaitRecoveryWreckage = {}
local WreckageExistTime = 60;

function gadget:GameStart()
    Spring.SetLogSectionFilterLevel(self:GetInfo().name, LOG.INFO)
    LiveGame = _G.LiveGame;
    Spring.Echo("spawn squad start")

    for _, value in ipairs(LiveGame.StartUnitList) do
        spSetTeamResource(value.teamID,"es",MaxEnergy);
    end
end

function gadget:GetNextTarget(selfGroup,current)
    local groupCount = #(LiveGame.UserData);
    local next = current + 1;
    if next == groupCount then
        return self:GetNextTarget(selfGroup,-1);
    end
    if next == selfGroup then
        return self:GetNextTarget(selfGroup,next);
    end
    return next;
end

function gadget:GetTargetFormId(id)
    local user = LiveGame.UserMap[id];
    if user == nil then return nil; end
    if user.AutoTarget == nil then
        user.AutoTarget = self:GetNextTarget(user.Group,user.Group);
    else
        user.AutoTarget = self:GetNextTarget(user.Group,user.Group);
    end
    return user.AutoTarget;
end

function gadget:GetBornPos(id,op)
    local user = LiveGame.UserMap[id];
    return user.Pos;
end

function gadget:GetTargetPos(target,op)
    local startUnit = LiveGame.StartUnitList[target + 1];
    if startUnit == nil then
        Spring.Log(self:GetInfo().name,LOG.ERROR,"GetTargetPos startUnit is nil")
        return nil
    end
    return { startUnit.x, startUnit.y, startUnit.z }
end

local function GetNextPosFuncDef(originPos,forward,index,r,cxt)

    if index == 0 then return originPos end
    
    local lastOffX = cxt.lastOffX or r * 2;
    local indexOfRow = cxt.indexOfRow or 0;

    if cxt.countOfRow == nil then
        cxt.angle = (math.asin(r / lastOffX) * 2) * 57.29577951;
        cxt.countOfRow = 360 / cxt.angle;
    end

    local mat = Mat2.FromRotate( cxt.angle *  indexOfRow);

    local dir = mat * forward;
    local pos = originPos + (dir * lastOffX);

    if indexOfRow + 1 >= cxt.countOfRow then
        cxt.lastOffX = lastOffX + r * 2;
        cxt.indexOfRow = 0;
        cxt.countOfRow = nil;
    else
        cxt.indexOfRow = indexOfRow + 1;
    end

    return pos;
end

function gadget:SpawnSquadReal(res,b,radius,bornDir,bornPos,unit,count,teamID,op,calcPosCxt)
    
    for i = 1,count do
        local pos = GetNextPosFuncDef(bornPos,bornDir,b + (i - 1),radius,calcPosCxt);
        local y = spGetGroundHeight(pos.x,pos.y);
        local unitId = spCreateUnit(unit,pos.x,y,pos.y,0,teamID);
        spSetUnitDirection(unitId,bornDir.x,0,bornDir.y);
        spAppendUnitNoChaseCategory(unitId,"LVNOCHASE");
        res[#res + 1] = unitId;
    end
end

function gadget:OrderSquad(units,target,op)
    local count = Spring.GiveOrderToUnitArray(units,CMD.FIGHT,target,0);
	if count ~= #units then
		Spring.Log(self:GetInfo().name,LOG.ERROR,'order return error count = ' .. tostring(count))
	end
end

function gadget:SpawnSquad(id,target,args)
    if target == nil then
        target = self:GetTargetFormId(id);
    end
    if target == nil then 
        Spring.Log(self:GetInfo().name,LOG.ERROR,"target is nil")
        return
    end
    local bornPos = self:GetBornPos(id,args.BornPosOp);
    local targetPos = self:GetTargetPos(target,args.TargetPosOp);
    local user = LiveGame.UserMap[id];
    local squadTable = {}
    local startUnit = LiveGame.StartUnitList[user.Group + 1];
    local radius = 0;
    local calcPosCxt = {};
    --bornPos:add(30,30);
    local i = 0;
    for _, value in ipairs(args.SquadGroup) do
        local def = UnitDefNames[value.Squad];
        radius = math.max(radius,def.radius);
        if def ~= nil then
            self:SpawnSquadReal(squadTable,i,radius,startUnit.bornDir,bornPos,value.Squad,value.Count,
                startUnit.teamID,value.BornOp,calcPosCxt)
        end
        i = i + value.Count;
    end

    self:OrderSquad(squadTable,targetPos,args.OrderOp);

end

function gadget:OnRecvLocalMsg(msg)
    if LiveGame ~= nil and msg.cmd ~= nil then
        if msg.cmd == "spawn" and msg.args ~= nil and msg.args.Id ~= nil then
            self:SpawnSquad(msg.args.Id,msg.args.Target,msg.args);
        end
    end
end

function gadget:CheckTeamEnergy()
    for _, value in ipairs(LiveGame.StartUnitList) do
        spSetTeamResource(value.teamID,"e",MaxEnergy);
    end
end

function gadget:RecvLuaMsg(msg,playerId)
    if msg == "live_test_spawn_squad" then
        local test = include("luarules/configs/LiveGame/TestSpawn.lua");
        test:func(self);
    end
end

function gadget:FeatureCreated(featureID, allyTeam)
    local featureDefID = Spring.GetFeatureDefID(featureID)
    local def = FeatureDefs[featureDefID];
    if def ~= nil and (string.find(def.name,"dead") ~= nil or string.find(def.name,"heap") ~= nil) then
        WaitRecoveryWreckage[featureID] = WreckageExistTime;
    end
end

function gadget:GameFrame(n)
    if n % 10 == 0 then
        self:CheckTeamEnergy();
    end
    for key, value in pairs(WaitRecoveryWreckage) do
        local v = value - 1;
        if v <= 0 then
            WaitRecoveryWreckage[key] = nil;
            spDestroyFeature(key);
        else
            WaitRecoveryWreckage[key] = v;
        end
    end
end