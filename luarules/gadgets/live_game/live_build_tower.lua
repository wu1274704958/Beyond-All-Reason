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

function gadget:Initialize()
    LiveGame = _G.LiveGame;
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
            self:AddTower(msg.args);
        end
    end
end

local function GetNextPosFuncDef(index)
    
end

function gadget:AddTower(args)
    local getNextPosFunc = LiveGame.MapConfig.GetNextPosFunc or GetNextPosFuncDef;
    local index = #(UserData[args.Group])
    local pos = getNextPosFunc(index);
    if pos == nil then
        Spring.Log(gadget:GetInfo().name,LOG.ERROR,string.format("AddTower failed pos is null index = %d,group = %d",index,args.Group))
        return;
    end
end

