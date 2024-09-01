local Vec2 = VFS.Include("common/math/vec2.lua")
_G.Vec2 = Vec2;
_G.Mat2 = VFS.Include("common/math/mat2.lua")

local spGetPlayerInfo = Spring.GetPlayerInfo
local spGetTeamInfo = Spring.GetTeamInfo
local spGetTeamRulesParam = Spring.GetTeamRulesParam
local spSetTeamRulesParam = Spring.SetTeamRulesParam
local spGetAllyTeamStartBox = Spring.GetAllyTeamStartBox
local spCreateUnit = Spring.CreateUnit
local spGetGroundHeight = Spring.GetGroundHeight
local spTickLMCommCentral = Spring.TickLMCommCentral
------------------------------------------------------------
-- Config
----------------------------------------------------------------
local startUnitParamName = 'startUnit'
----------------------------------------------------------------
-- Vars
----------------------------------------------------------------
local validStartUnits = {}
local armcomDefID = UnitDefNames.armcom_lv and UnitDefNames.armcom_lv.id
if armcomDefID then
	validStartUnits[armcomDefID] = true
end
local corcomDefID = UnitDefNames.corcom_lv and UnitDefNames.corcom_lv.id
if corcomDefID then
	validStartUnits[corcomDefID] = true
end
local legcomDefID = UnitDefNames.legcom and UnitDefNames.legcom.id
if legcomDefID then
	validStartUnits[legcomDefID] = true
end

local cordoomDefID = UnitDefNames.cordoom_lv and UnitDefNames.cordoom_lv.id
if cordoomDefID then
	validStartUnits[cordoomDefID] = true
end
local teams = {} -- teams[teamID] = allyID
local teamsCount
-- each player gets to choose a faction
local playerStartingUnits = {} -- playerStartingUnits[unitID] = unitDefID
GG.playerStartingUnits = playerStartingUnits
-- each team gets one startpos. if coop mode is on, extra startpoints are placed in GG.coopStartPoints by coop
local teamStartPoints = {} -- teamStartPoints[teamID] = {x,y,z}
GG.teamStartPoints = teamStartPoints
local startPointTable = {}
local startUnitList = {}
local waitNotifyUnitDestroy = {}

local LiveGame = {
    MapConfig = nil,
    StartUnitList = nil
}

function gadget:Initialize()
    _G.LiveGame = LiveGame;
    Spring.SetLogSectionFilterLevel(gadget:GetInfo().name, LOG.INFO)
    Spring.InitLMCommCentral("BarGameMem",1024 * 1024 * 10);
    Spring.Log(gadget:GetInfo().name, LOG.INFO,"live game mode initialize")
    gadget:addLiveGameGadgets()
    local gaiaTeamID = Spring.GetGaiaTeamID()
	local teamList = Spring.GetTeamList()
	for i = 1, #teamList do
		local teamID = teamList[i]
		if teamID ~= gaiaTeamID then
			-- set & broadcast (current) start unit
			local _, _, _, _, teamSide, teamAllyID = spGetTeamInfo(teamID, false)
			local comDefID = armcomDefID
			-- we try to give you your faction, if we can't, we find the first available faction, loops around if the list isn't long enough to include current team
			
			if teamSide == 'cortex' then
				comDefID = corcomDefID
			elseif teamSide == 'legion' then
				comDefID = legcomDefID
			end

            if validStartUnits[cordoomDefID] then
                comDefID = cordoomDefID;
            end
            spSetTeamRulesParam(teamID, startUnitParamName, comDefID, { allied = true, public = false })
			teams[teamID] = teamAllyID
		end
	end


    teamsCount = 0
	for k, v in pairs(teams) do
		teamsCount = teamsCount + 1
	end

	-- mark all players as 'not yet placed' and 'not yet readied'
	local initState = -1

	local playerList = Spring.GetPlayerList()
	for _, playerID in pairs(playerList) do
		Spring.SetGameRulesParam("player_" .. playerID .. "_readyState", initState)
	end
end

local function setStartUnitDirection(index,posList)
    local next = index + 1
    if next > #startUnitList then
        next = 1;
    end
    local nextPos = Vec2.Create(posList[next - 1].x,posList[next - 1].z);
    local currPos = Vec2.Create(posList[index - 1].x,posList[index - 1].z);

    nextPos:sub(currPos.x,currPos.y);
    nextPos:normalize();

    startUnitList[index].bornDir = nextPos;
    Spring.SetUnitDirection(startUnitList[index].unitID,nextPos.x,0,nextPos.y);
end

local function ReSetupGame()
    local mapConfig = include("luarules/configs/LiveGame/MapConfig.lua")[Game.mapName];
    if mapConfig == nil then return end;

    for i, u in pairs(startUnitList) do
        local pos = mapConfig.pos[i - 1];
        if pos ~= nil then
            Spring.MoveCtrl.Enable(u.unitID)
            Spring.SetUnitPosition(u.unitID, pos.x, pos.z);
            setStartUnitDirection(i,mapConfig.pos)
            u.x = pos.x;
            u.z = pos.z;
            Spring.MoveCtrl.Disable(u.unitID)
        end
    end

    Spring.SetCameraState(mapConfig.camera_state)
end

function gadget:RecvLuaMsg(msg, playerID)

    if msg == "live_resetup_game" then
        ReSetupGame();
        return;
    end
    if msg == "live_test_reload" then
        Spring.ReleaseLMCommCentral();
        Spring.Reload();
        return
    end
    -- if msg == "live_print_camera_state" then 
    --     PrintCameraState()
    --     return;
    -- end
    -- keep track of ready status gameside.
    -- sending ready status in GameSetup early prevents players from repositioning
    -- thus, the plan is to keep track of readystats gameside, and only send through GameSetup
    -- when everyone is ready
    local _, _, playerIsSpec, playerTeam, allyTeamID = spGetPlayerInfo(playerID, false)

    if msg == "ready_to_start_game" then
        Spring.SetGameRulesParam("player_" .. playerID .. "_readyState", 1)
    end

    -- keep track of who has joined
    -- so when last person joins, start the auto-ready countdown
    if msg == "joined_game" then
        Spring.SetGameRulesParam("player_" .. playerID .. "_joined", 1)
        local playerList = Spring.GetPlayerList()
        local all_players_joined = true
        for _, PID in pairs(playerList) do
            local _, _, spectator_flag = spGetPlayerInfo(PID)
            if spectator_flag == false then
                if Spring.GetGameRulesParam("player_" .. PID .. "_joined") == nil then
                    all_players_joined = false
                end
            end
        end
        if all_players_joined == true then
            Spring.SetGameRulesParam("all_players_joined", 1)
        end
    end

    -- keep track of lock state
    if msg == "locking_in_place" then
        Spring.SetGameRulesParam("player_" .. playerID .. "_lockState", 1)
    end
    if msg == "unlocking_in_place" then
        Spring.SetGameRulesParam("player_" .. playerID .. "_lockState", 0)
    end

    if not playerIsSpec and (draftMode ~= nil and draftMode ~= "disabled") then
        DraftRecvLuaMsg(msg, playerID, playerIsSpec, playerTeam, allyTeamID)
    end
end

function gadget:AllowStartPosition(playerID, teamID, readyState, x, y, z)
    return true;
end

local function spawnStartUnit(teamID, x, z)
    local startUnit = spGetTeamRulesParam(teamID, startUnitParamName)
    local y = spGetGroundHeight(x, z)
    local unitID = spCreateUnit(startUnit, x, y, z, 0, teamID)
    if unitID then
        startUnitList[#startUnitList + 1] = { unitID = unitID, teamID = teamID, x = x, y = y, z = z }
        
        --Spring.MoveCtrl.Enable(unitID)
    end

    -- share info
    teamStartPoints[teamID] = { x, y, z }
    --spSetTeamRulesParam(teamID, startUnitParamName, startUnit, { public = true }) -- visible to all (and picked up by advpllist)
    spSetTeamRulesParam(teamID, startUnitParamName, startUnit, { allied = true, public = false })

    -- team storage is set up by game_team_resources
end

local function SetupGame()
    local mapConfig =  include("luarules/configs/LiveGame/MapConfig.lua")[Game.mapName];
    if mapConfig == nil then return end;
    LiveGame.MapConfig = mapConfig;
    local i = 0;
    for teamID, _ in pairs(teams) do
        local pos = mapConfig.pos[i];
        if pos ~= nil then
            spawnStartUnit(teamID, pos.x,pos.z)
        end
        i = i + 1;
    end

    for idx, _ in pairs(startUnitList) do
        setStartUnitDirection(idx,mapConfig.pos)
    end

    Spring.SetCameraState(mapConfig.camera_state)
end

function gadget:GameStart()
    SetupGame()
    LiveGame.StartUnitList = startUnitList;
    Spring.SendLocalMemMsg( { cmd = "preStart" , args = {teamCount = #startUnitList, mapName = Game.mapName } } );
    Spring.SendLocalMemMsg( { cmd = "start" } );
    Spring.Echo("Send Start......")
end


local function printTable(tab)
    for key, val in pairs(tab) do
        if type(val) == "table" then
            Spring.Log(gadget:GetInfo().name, LOG.INFO,"recv msg table key = "..key)
            printTable(val)
        else
            Spring.Log(gadget:GetInfo().name, LOG.INFO,"recv msg = "..key..' = '.. tostring(val))
        end
    end
end

function gadget:CheckGameOverForce()
    local minHp = 0;
    local minHpGroup = 0;
    for i, v in ipairs(startUnitList) do
        local health, maxHealth = Spring.GetUnitHealth( v.unitID );
        if minHp <= 0 or health < minHp then
            minHp = health;
            minHpGroup = i;
        end
    end
    if minHpGroup > 0 then
        Spring.SendLocalMemMsg( { cmd = "finish",args = { winner = minHpGroup - 1 }} )
        return true
    end
    return false
end

function gadget:OnRecvLocalMsg(msg)
    if msg.cmd ~= nil then
        if msg.cmd == "restart" then
            Spring.SendLocalMemMsg( { cmd = "end"} )
            Spring.ReleaseLMCommCentral(false);
            Spring.Reload();
        elseif msg.cmd == "forceFinish" then
            self:CheckGameOverForce();
        end
    end
end

function gadget:Shutdown()
    Spring.ReleaseLMCommCentral(true);
    Spring.Log(gadget:GetInfo().name,LOG.INFO,"Release local mem Comm Central!!!");
end

function gadget:addLiveGameGadgets()
    local VFSMODE = VFS.ZIP_ONLY -- FIXME: ZIP_FIRST ?
    if Spring.IsDevLuaEnabled() then
        VFSMODE = VFS.RAW_ONLY
    end
    local gadgetFiles = VFS.DirList("luarules/gadgets/live_game", "*.lua", VFSMODE)

    local unsortedGadgets = {}
    for _, gf in ipairs(gadgetFiles) do
        -- filter self
        if string.find(gf,"game_initial_spawn") == nil then
            local gadget = gadgetHandler:LoadGadget(gf, VFSMODE)
            if gadget then
                table.insert(unsortedGadgets, gadget)
            end
        end
	end

    table.sort(unsortedGadgets, function(g1, g2)
		local l1 = g1.ghInfo.layer
		local l2 = g2.ghInfo.layer
		if l1 ~= l2 then
			return (l1 < l2)
		end
		local n1 = g1.ghInfo.name
		local n2 = g2.ghInfo.name
		return (n1 < n2)
	end)

    for _, g in ipairs(unsortedGadgets) do
		gadgetHandler:InsertGadget(g)
	end
end

function gadget:CheckGameOver()
    local liveCount = 0;
    local liveIndex = 0;
    for i, v in ipairs(startUnitList) do
        if not (v.failed or false) then
            liveCount = liveCount + 1;
            liveIndex = i
        end
    end
    if liveCount == 1 and liveIndex > 0 then
        Spring.SendLocalMemMsg( { cmd = "finish",args = { winner = liveIndex - 1 }} )
        --Spring.SendCommands({"pause 1"})
        return true
    end
    return false
end

function gadget:UnitDestroyed(unitID,unitDefID,teamID)
    local group = 0
    for i, v in ipairs(startUnitList) do
        if v.unitID == unitID then
            v.failed = true;
            self:CheckGameOver();
            return
        end
        if teamID == v.teamID then
            group = i;
        end
    end
    if group > 0 then
        if waitNotifyUnitDestroy[group] == nil then
            waitNotifyUnitDestroy[group] = 0
        end
        waitNotifyUnitDestroy[group] = waitNotifyUnitDestroy[group] + 1;
    end
end

function gadget:NotifyUnitDestroyed(n)
    if n % 30 == 0 then
        for i, v in ipairs(waitNotifyUnitDestroy) do
            if v > 0 then
                Spring.SendLocalMemMsg( { cmd = "unitDestroyed",args = { group = i - 1, count = v }} )
                waitNotifyUnitDestroy[i] = 0;
            end
        end
    end
end

function gadget:GameFrame(n)
    self:NotifyUnitDestroyed(n);
    spTickLMCommCentral();
end