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

function gadget:SpawnSquadReal(res,pos,unit,count,user,op)
    local y = spGetGroundHeight(pos.x,pos.y);
    local startUnit = LiveGame.StartUnitList[user.Group + 1];
    for i = 1,count do
        local unitId = spCreateUnit(unit,pos.x,y,pos.y,0,startUnit.teamID);
        spSetUnitDirection(unitId,startUnit.bornDir.x,0,startUnit.bornDir.y);
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

    --bornPos:add(30,30);

    for _, value in ipairs(args.SquadGroup) do
        self:SpawnSquadReal(squadTable,bornPos,value.Squad,value.Count,user,value.BornOp)
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