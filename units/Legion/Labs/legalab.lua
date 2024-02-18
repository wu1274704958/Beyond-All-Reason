return {
	legalab = {
		maxacc = 0,
		maxdec = 0,
		buildangle = 1024,
		energycost = 16000,
		metalcost = 2900,
		builder = true,
		buildpic = "LEGALAB.DDS",
		buildtime = 16800,
		canmove = true,
		category = "ALL NOTLAND NOWEAPON NOTSUB NOTSHIP NOTAIR NOTHOVER SURFACE EMPABLE",
		collisionvolumeoffsets = "0 13 8",
		collisionvolumescales = "101 51 90",
		collisionvolumetype = "Box",
		corpse = "DEAD",
		energystorage = 200,
		explodeas = "largeBuildingexplosiongeneric",
		footprintx = 7,
		footprintz = 6,
		idleautoheal = 5,
		idletime = 1800,
		health = 4500,
		maxslope = 15,
		maxwaterdepth = 0,
		metalstorage = 200,
		objectname = "Units/CORALAB.s3o",
		radardistance = 50,
		script = "Units/CORALAB.lua",
		seismicsignature = 0,
		selfdestructas = "largeBuildingexplosiongenericSelfd",
		sightdistance = 288.60001,
		terraformspeed = 1000,
		workertime = 300,
		yardmap = "ooooooo ooooooo ooooooo occccco occccco occccco",
		buildoptions = {
			[1] = "legack",
			[2] = "corfast",
			[3] = "legstr",
			[4] = "coramph",
			[5] = "legshot",
			[6] = "leginc",
			[7] = "legsrail",
			[8] = "legbart",
			[9] = "leginfestor",
			[10] = "corhrk",
			[11] = "coraak",
			[12] = "corroach",
			[13] = "corsktl",
			[14] = "corvoyr",
			[15] = "corspy",
			[16] = "corspec",
			[17] = "cormando",
		},
		customparams = {
			usebuildinggrounddecal = true,
			buildinggrounddecaltype = "decals/coralab_aoplane.dds",
			buildinggrounddecalsizey = 9,
			buildinggrounddecalsizex = 10,
			buildinggrounddecaldecayspeed = 30,
			unitgroup = 'buildert2',
			model_author = "Mr Bob",
			normaltex = "unittextures/cor_normal.dds",
			subfolder = "cortex_buildings/landfactories",
			techlevel = 2,
		},
		featuredefs = {
			dead = {
				blocking = true,
				category = "corpses",
				collisionvolumeoffsets = "0 -16 0",
				collisionvolumescales = "100 34 90",
				collisionvolumetype = "Box",
				damage = 2443,
				energy = 0,
				featuredead = "HEAP",
				featurereclamate = "SMUDGE01",
				footprintx = 5,
				footprintz = 6,
				height = 20,
				hitdensity = 100,
				metal = 1743,
				object = "Units/coralab_dead.s3o",
				reclaimable = true,
				seqnamereclamate = "TREE1RECLAMATE",
				world = "All Worlds",
			},
			heap = {
				blocking = false,
				category = "heaps",
				damage = 1222,
				energy = 0,
				featurereclamate = "SMUDGE01",
				footprintx = 5,
				footprintz = 5,
				height = 4,
				hitdensity = 100,
				metal = 872,
				object = "Units/cor5X5A.s3o",
				reclaimable = true,
				resurrectable = 0,
				seqnamereclamate = "TREE1RECLAMATE",
				world = "All Worlds",
			},
		},
		sfxtypes = {
			explosiongenerators = {
				[1] = "custom:WhiteLight",
			},
			pieceexplosiongenerators = {
				[1] = "deathceg3",
				[2] = "deathceg4",
			},
		},
		sounds = {
			canceldestruct = "cancel2",
			underattack = "warning1",
			unitcomplete = "untdone",
			count = {
				[1] = "count6",
				[2] = "count5",
				[3] = "count4",
				[4] = "count3",
				[5] = "count2",
				[6] = "count1",
			},
			select = {
				[1] = "plabactv",
			},
		},
	},
}
