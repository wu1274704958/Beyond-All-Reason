local function getUnitIDList(unitNameList)
	local unitDefIDList = {}
	for _, unitName in ipairs(unitNameList) do
		local unitDefID = UnitDefNames[unitName].id
		unitDefIDList[unitDefID] = true
	end

	return unitDefIDList
end

local noSelfDestruct = {
	"cormaw_scav",
	"armclaw_scav",
	"corfmd_scav",
	"armamd_scav",
	"lootboxgold_scav",
	"lootboxplatinum_scav",
	"lootboxsilver_scav",
	"lootboxbronze_scav",
	"chickend1",
	"roost",
	"corscavdtl_scav",
	"corscavdtf_scav",
	"corscavdtm_scav",
}

local walls = {
	"armdrag_scav",
	"armfdrag_scav",
	"cordrag_scav",
	"corfdrag_scav",
	"armfort_scav",
	"corfort_scav",
	"corscavdrag_scav",
	"corscavfort_scav",
}

local stockpilers = {
	"corsilo_scav",
	"armsilo_scav",
	"cortron_scav",
	"armemp_scav",
	"armamd_scav",
	"corfmd_scav",
	"corscreamer_scav",
	"armmercury_scav",
	"corjuno_scav",
	"armjuno_scav",
	"armthor_scav",
	"armscab_scav",
	"cormabm_scav",
	"armcarry_scav",
	"corcarry_scav",
	"armbotrail_scav"
}

local nukes = {
	"corsilo_scav",
	"armsilo_scav",
	"cortron_scav",
	"armemp_scav",
	"corjuno_scav",
	"armjuno_scav",
}

local beaconCaptureExclusions = {
	"armdrag",
	"armfdrag",
	"cordrag",
	"corfdrag",
	"armfort",
	"corfort",
}

local beaconDefences = {
	T0 = {
		"corllt",
		"armllt",
		"corllt",
		"armllt",
		"corllt",
		"armllt",
		"corrl",
		"armrl",
	},

	T1 = {
		"corllt",
		"armllt",
		"corllt",
		"armllt",
		"corllt",
		"armllt",
		"corrl",
		"armrl",
		"corhllt",
		"corhllt",
		"armbeamer",
	},

	T2 = {
		"corhllt",
		"corhllt",
		"armbeamer",
		"cormaw",
		"armclaw",
		"armferret",
		"armbeamer",
		"armhlt",
		"armhlt",
		"corhlt",
		"corhlt",
		"armflak",
		"corflak",
	},

	T3 = {
		"armflak",
		"corflak",
		"corvipe",
		"corvipe",
		"corvipe",
		"corvipe",
		"armpb",
		"armpb",
		"armpb",
		"armpb",
		"armanni",
		"cordoom",
		"corminibuzz",
		"armminivulc",
	},
}

local startboxDefences = {
	T0 = {
		"corllt",
		"armllt",
		"corllt",
		"armllt",
		"corllt",
		"armllt",
		"corrl",
		"armrl",
	},

	T1 = {
		"cormaw",
		"corhllt",
		"armclaw",
		"armbeamer",
		"armferret",
		"cormadsam",
		"corerad",
		"corhllt",
		"corhlt",
		"armhlt",
		"armmine3",
	},

	T2 = {
		"corhllt",
		"corhlt",
		"armhlt",
		"corvipe",
		"armpb",
		"armflak",
		"corflak",
		"armguard",
		"corpun",
		"armamd",
		"corfmd",
		"corvipe",
		"armpb",
		"armpb",
		"armflak",
		"corflak",
		"armamd",
		"corfmd",
		"armemp",
		"corflak",
		"armflak",
		"corflak",
		"armmine3",
		"armamd",
		"corfmd",
		"armemp",
	},

	T3 = {
		"corvipe",
		"armpb",
		"cortoast",
		"armamb",
		"armpb",
		"armflak",
		"corflak",
		"armanni",
		"cordoom",
		"armamd",
		"corfmd",
		"armemp",
		"cortron",
		"corflak",
		"armanni",
		"cordoom",
		"armanni",
		"cordoom",
		"armflak",
		"corflak",
		"armanni",
		"cordoom",
		"armmine3",
		"armamd",
		"corfmd",
		"armemp",
		"cortron",
		"corminibuzz",
		"armminivulc",
	},

	T4 = {
		"corflak",
		"armanni",
		"cordoom",
		"armanni",
		"cordoom",
		"armflak",
		"corflak",
		"armanni",
		"cordoom",
		"armmine3",
		"armamd",
		"corfmd",
		"armemp",
		"cortron",
		"corminibuzz",
		"armminivulc",
	},
}

local startboxDefencesSea = {
	T0 = {
		"cortl",
		"armtl",
		"cortl",
		"armtl",
		"armfrt",
		"corfrt",
		"corfdrag",
		"cortl",
		"armtl",
		"armfrt",
		"corfrt",
		"cortl",
		"armtl",
		"armfrt",
		"corfrt",
		"corfhlt",
		"armfhlt",
		"corfhlt",
		"armfhlt",
	},

	T1 = {
		"cortl",
		"armtl",
		"armfrt",
		"corfrt",
		"cortl",
		"armtl",
		"armfrt",
		"corfrt",
		"corfhlt",
		"armfhlt",
		"corfhlt",
		"armfhlt",
	},

	T2 = {
		"cortl",
		"armtl",
		"armfrt",
		"corfrt",
		"coratl",
		"armatl",
		"corfhlt",
		"armfhlt",
		"coratl",
		"armatl",
		"corfhlt",
		"armfhlt",
		"coratl",
		"armatl",
		"corfdoom",
		"armkraken",
	},
  
	T3 = {
		"coratl",
		"armatl",
		"corfhlt",
		"armfhlt",
		"coratl",
		"armatl",
		"corfdoom",
		"armkraken",
		--"corfflak",
		"armfflak",
	},

	T4 = {
		"coratl",
		"armatl",
		"corfdoom",
		"armkraken",
		--"corfflak",
		"armfflak",
	},
}

local noSelfDestructID = getUnitIDList(noSelfDestruct)
local wallsID = getUnitIDList(walls)
local stockpilersID = getUnitIDList(stockpilers)
local nukesID = getUnitIDList(nukes)
local beaconCaptureExclusionsID = getUnitIDList(beaconCaptureExclusions)

return {
	NoSelfDestruct = noSelfDestruct,
	NoSelfDestructID = noSelfDestructID,
	Walls = walls,
	WallsID = wallsID,
	Stockpilers = stockpilers,
	StockpilersID = stockpilersID,
	Nukes = nukes,
	NukesID = nukesID,
	BeaconCaptureExclusions = beaconCaptureExclusions,
	BeaconCaptureExclusionsID = beaconCaptureExclusionsID,
	BeaconDefences = beaconDefences,
	StartboxDefences = startboxDefences,
	StartboxDefencesSea = startboxDefencesSea,
}