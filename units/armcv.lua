return {
	armcv = {
		acceleration = 0.121,
		brakerate = 1.2408,
		buildcostenergy = 1900,
		buildcostmetal = 135,
		builddistance = 130,
		builder = true,
		shownanospray = false,
		buildpic = "ARMCV.DDS",
		buildtime = 4066,
		canmove = true,
		category = "ALL TANK MOBILE NOTSUB NOWEAPON NOTSHIP NOTAIR NOTHOVER SURFACE",
		collisionvolumeoffsets = "0 0 -1",
		collisionvolumescales = "35 22 50",
		collisionvolumetype = "Box",
		corpse = "DEAD",
		description = "Tech Level 1",
		energymake = 10,
		energystorage = 50,
		energyuse = 10,
		explodeas = "mediumexplosiongeneric",
		footprintx = 3,
		footprintz = 3,
		idleautoheal = 5,
		idletime = 1800,
		leavetracks = true,
		maxdamage = 1240,
		maxslope = 16,
		maxvelocity = 1.925,
		maxwaterdepth = 18,
		metalmake = 0.1,
		metalstorage = 50,
		movementclass = "TANK3",
		name = "Construction Vehicle",
		objectname = "ARMCV",
		radardistance = 50,
		seismicsignature = 0,
		selfdestructas = "mediumexplosiongeneric",
		sightdistance = 253,
		terraformspeed = 450,
		trackoffset = 12,
		trackstrength = 6,
		tracktype = "StdTank",
		trackwidth = 35,
		turninplace = 1,
		turninplaceanglelimit = 60,
		turninplacespeedlimit = 1.2705,
		turnrate = 435,
		workertime = 150,
		buildoptions = {
			[1] = "armsolar",
			[2] = "armadvsol",
			[3] = "armwin",
			[4] = "armgeo",
			[5] = "armmstor",
			[6] = "armestor",
			[7] = "armmex",
			[8] = "armamex",
			[9] = "armmakr",
			[10] = "armavp",
			[11] = "armlab",
			[12] = "armvp",
			[13] = "armap",
			[14] = "armhp",
			[15] = "armnanotc",
			[16] = "armeyes",
			[17] = "armrad",
			[18] = "armdrag",
			[19] = "armclaw",
			[20] = "armllt",
			[21] = "tawf001",
			[22] = "armhlt",
			[23] = "armguard",
			[24] = "armrl",
			[25] = "packo",
			[26] = "armcir",
			[27] = "armdl",
			[28] = "armjamt",
			[29] = "ajuno",
			[30] = "armsy",
		},
		customparams = {
			death_sounds = "generic",
		},
		featuredefs = {
			dead = {
				blocking = true,
				category = "corpses",
				collisionvolumeoffsets = "2.14814758301 -0.0528551147461 0.625",
				collisionvolumescales = "39.296295166 32.5338897705 48.75",
				collisionvolumetype = "Box",
				damage = 744,
				description = "Construction Vehicle Wreckage",
				energy = 0,
				featuredead = "HEAP",
				featurereclamate = "SMUDGE01",
				footprintx = 3,
				footprintz = 3,
				height = 20,
				hitdensity = 100,
				metal = 83,
				object = "ARMCV_DEAD",
				reclaimable = true,
				seqnamereclamate = "TREE1RECLAMATE",
				world = "All Worlds",
			},
			heap = {
				blocking = false,
				category = "heaps",
				damage = 372,
				description = "Construction Vehicle Heap",
				energy = 0,
				featurereclamate = "SMUDGE01",
				footprintx = 3,
				footprintz = 3,
				height = 4,
				hitdensity = 100,
				metal = 33,
				object = "3X3C",
                collisionvolumescales = "55.0 4.0 6.0",
                collisionvolumetype = "cylY",
				reclaimable = true,
				resurrectable = 0,
				seqnamereclamate = "TREE1RECLAMATE",
				world = "All Worlds",
			},
		},
		sfxtypes = { 
 			pieceExplosionGenerators = { 
				"deathceg3",
				"deathceg4",
			},
		},
		sounds = {
			build = "nanlath1",
			canceldestruct = "cancel2",
			repair = "repair1",
			underattack = "warning1",
			working = "reclaim1",
			cant = {
				[1] = "cantdo4",
			},
			count = {
				[1] = "count6",
				[2] = "count5",
				[3] = "count4",
				[4] = "count3",
				[5] = "count2",
				[6] = "count1",
			},
			ok = {
				[1] = "varmmove",
			},
			select = {
				[1] = "varmsel",
			},
		},
	},
}
