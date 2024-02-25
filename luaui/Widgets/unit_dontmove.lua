--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function widget:GetInfo()
  return {
    name      = "DontMove",
    desc      = "Sets pre-defined units on hold position.",
    author    = "quantum",
    date      = "Jan 8, 2007",
    license   = "GNU GPL, v2 or later",
    layer     = 0,
    enabled   = true  --  loaded by default?
  }
end


local unitNames = {

  --comms added below separately

  --aa units
  "armada_crossbow",
  "armada_archangel",
  "corcrash",
  "coraak",

  "armsam",
  "armyork",
  "cormist",
  "corsent",

  "armada_sweeper",
  "corah",
  "armada_voyager",
  "cormls",
  "armada_dragonslayer",
  "corarch",

  --arty
  "armart",
  "armada_mace",
  "corwolv",

  "armada_mauser",
  "armmerl",
  "cormart",
  "corvroc",
  "cortrem",
  "armada_sharpshooter",
  "corhrk",

  "armada_possum",
  "cormh",
  "armada_corsair",
  "corroy",
  "armada_serpent",
  "corssub",

  "armada_longbow",
  "cormship",
  "armada_dreadnought",
  "corbats",

  "armada_epoch",
  "corblackhy",

  "corcat",
  "armada_vanguard",

  --skirmishers/fire support
  "armjanus",
  "armada_rocketeer",
  "corstorm",

  "corban",
  "armmanni",
  "cormort",

  --scouts
  "armada_tick",
  "armfav",
  "corfav",
  "armada_ghost",
  "armgremlin",

  "armada_skater",
  "corpt",

  --shields/jammers/radars
  "armada_radarjammerbot",
  "armjam",
  "corspec",

  "armseer",
  "armada_compass",
  "corvrad",
  "corvoyr",

  --antinukes
  "armada_umbrella",
  "cormabm",
  "armada_haven",
  "corcarry",
  "armada_t2supportship",
  "corantiship",

  --misc
}
-- add commanders too
for unitDefID, unitDef in pairs(UnitDefs) do
	if unitDef.customParams.iscommander then
		unitNames[#unitNames+1] = unitDef.name
	end
end

local unitArray = {}
for _, name in pairs(unitNames) do
	if UnitDefNames[name] then
		unitArray[UnitDefNames[name].id] = true
	end
end
unitNames = nil

local myTeamID = Spring.GetMyTeamID()


function widget:PlayerChanged(playerID)
	if Spring.GetSpectatingState() then
		widgetHandler:RemoveWidget()
	end
	myTeamID = Spring.GetMyTeamID()
end

function widget:Initialize()
	if Spring.IsReplay() or Spring.GetGameFrame() > 0 then
		widget:PlayerChanged()
	end
end

function widget:UnitCreated(unitID, unitDefID, unitTeam)
	if unitTeam == myTeamID then
		if unitArray[unitDefID] then
			Spring.GiveOrderToUnit(unitID, CMD.MOVE_STATE, { 0 }, 0)
		end
	end
end
