

local spGetPlayerInfo = Spring.GetPlayerInfo
local spGetTeamInfo = Spring.GetTeamInfo
local spGetTeamRulesParam = Spring.GetTeamRulesParam
local spSetTeamRulesParam = Spring.SetTeamRulesParam
local spGetAllyTeamStartBox = Spring.GetAllyTeamStartBox
local spCreateUnit = Spring.CreateUnit
local spGetGroundHeight = Spring.GetGroundHeight
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

function gadget:Initialize()
    Spring.SetLogSectionFilterLevel(gadget:GetInfo().name, LOG.INFO)

    Spring.InitLMCommCentral("TEST",4096);
    Spring.Log(gadget:GetInfo().name, LOG.INFO,"live game mode initialize")

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



local function ReSetupGame()
    local mapConfig = include("luarules/configs/LiveGame/MapConfig.lua")[Game.mapName];
    if mapConfig == nil then return end;

    for i, u in pairs(startUnitList) do
        local pos = mapConfig.pos[i - 1];
        if pos ~= nil then
            Spring.MoveCtrl.Enable(u.unitID)
            Spring.SetUnitPosition(u.unitID, pos.x, pos.z);
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

    local i = 0;
    for teamID, _ in pairs(teams) do
        local pos = mapConfig.pos[i];
        if pos ~= nil then
            spawnStartUnit(teamID, pos.x,pos.z)
        end
        i = i + 1;
    end

    Spring.SetCameraState(mapConfig.camera_state)
end




function gadget:GameStart()
    SetupGame()
    Spring.SendLocalMemMsg( { abc = 123, uuu = "hjsajh", arr = { IsArray = true, [0] = "哈喽",[1] = "小",[2] = "笨蛋" } } );
end


function gadget:GameFrame(n)
    -- if n > 30 then
    --     gadgetHandler:RemoveGadget(self)
    -- end
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

function gadget:OnRecvLocalMsg(msg)
    printTable(msg);
end

function gadget:Shutdown()
    Spring.ReleaseLMCommCentral();
    Spring.Log(gadget:GetInfo().name,LOG.INFO,"Release local mem Comm Central!!!");
end
