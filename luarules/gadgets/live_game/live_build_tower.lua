function gadget:GetInfo()
	return {
		name	= "Live Game build tower",
		desc	= "Live Game build tower for joined players",
		author	= "eqd",
		date	= "August,2024",
		license = "-",
		layer	= 0,
		enabled = true,
	}
end

local LiveGame = nil;
local Start = false;
local UserData = {}
local UserMap = {}

local Vec2 = _G.Vec2;

local spCreateUnit = Spring.CreateUnit
local spGetGroundHeight = Spring.GetGroundHeight
local spDestroyUnit = Spring.DestroyUnit
local spAppendUnitCategory = Spring.AppendUnitCategory
local spSetUnitDirection = Spring.SetUnitDirection
local spSetUnitMaxHealth = Spring.SetUnitMaxHealth;
local spSetUnitHealth = Spring.SetUnitHealth;

local TowerHp = 88889999;

function gadget:Initialize()
    LiveGame = _G.LiveGame;
    LiveGame.UserData = UserData;
    LiveGame.UserMap = UserMap;
    Spring.SetLogSectionFilterLevel(gadget:GetInfo().name, LOG.INFO)
    Spring.Echo("build tower init")
end


function gadget:GameStart()
    Start = true;
    Spring.Echo("build tower start")
end

function gadget:OnRecvLocalMsg(msg)
    if Start and msg.cmd ~= nil then
        if msg.cmd == "join" then
            local data = self:AddTower(msg.args);
            if data ~= nil then
                self:ShowPlayerName(data)
            end
        end
    end
end

local function GetNextPosFuncDef(originPos,forward,index,group,op)
    return nil
end

local function GetUnitByType(type,group)
    if type == nil then
        return "armamb"
    end
end



function gadget:AddTower(args)

    if UserData[args.Group + 1] == nil then
        UserData[args.Group + 1] = { }
    end

    local getNextPosFunc = LiveGame.MapConfig.GetNextPosFunc or GetNextPosFuncDef;
    local index = #(UserData[args.Group + 1])
    local startUnit = LiveGame.StartUnitList[args.Group + 1];
    local pos = getNextPosFunc(Vec2.Create(startUnit.x,startUnit.z),startUnit.bornDir,index,args.Group);
    if pos == nil then
        Spring.Log(gadget:GetInfo().name,LOG.ERROR,string.format("AddTower failed pos is null index = %d,group = %d",index,args.Group))
        return;
    end

    local name = args.Name;
    if name == nil then
        name = string.format("哈哈哈_%d_%d",startUnit.teamID,index);
    end

    local y = spGetGroundHeight(pos.x, pos.y)
    local getTowerFunc = LiveGame.MapConfig.GetTowerUnitByType or GetUnitByType;
    local unitID = spCreateUnit(getTowerFunc(args.Type,args.Group), pos.x, y, pos.y, 0, startUnit.teamID)

    spSetUnitDirection(unitID,startUnit.bornDir.x,0,startUnit.bornDir.y);
    spAppendUnitCategory(unitID,"LVNOCHASE");
    spSetUnitMaxHealth(unitID,TowerHp);
    spSetUnitHealth(unitID,TowerHp);

    local user = {
        Pos = pos,
        Name = name,
        Id = args.Id,
        UnitId = unitID,
        Group = args.Group,
        Index = index
    };

    UserData[args.Group + 1][index + 1] = user;

    UserMap[args.Id] = user;

    return user;
end

function gadget:ShowPlayerName(data)
    local msg = {
        id = data.Id,
        name = data.Name,
        unitId = data.UnitId,
    }
    local textMsg = "ShowLivePlayerName"..Json.encode(msg);
    Spring.SendLuaUIMsg(textMsg)
end

function gadget:RemoveAllTower()
    for _,g in ipairs(UserData) do
        for i,u in ipairs(g) do
            spDestroyUnit(u.UnitId,false,true,nil,true);
        end
    end
    UserData = {}
    UserMap = {}
    LiveGame.UserData = UserData;
    LiveGame.UserMap = UserMap;
end

function gadget:RecvLuaMsg(msg,playerId)
    if msg == "live_test_build_tower" then
        self:RemoveAllTower();
        LiveGame.MapConfig = include("luarules/configs/LiveGame/MapConfig.lua")[Game.mapName];
        for i=1,60 do
            local data = self:AddTower({ Group = i % 2 , Id = i})
            if data ~= nil then
                self:ShowPlayerName(data)
            end
        end
    end
end