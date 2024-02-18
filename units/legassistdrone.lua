return {
	legassistdrone = {
		maxacc = 0.07,
		blocking = false,
		maxdec = 0.4275,
		energycost = 1,
		metalcost = 1,
		builddistance = 100,
		builder = true,
		buildpic = "CORASSISTDRONE.DDS",
		buildtime = 500,
		cancapture = true,
		canfly = true,
		canmove = true,
		category = "ALL MOBILE NOTLAND NOTSUB VTOL NOWEAPON NOTSHIP NOTHOVER",
		collide = true,
		cruisealtitude = 100,
		explodeas = "smallexplosiongeneric-builder",
		footprintx = 1,
		footprintz = 1,
		hoverattack = false,
		idleautoheal = 5,
		idletime = 1800,
		mass = 5000,
		health = 335,
		maxslope = 10,
		speed = 210.0,
		maxwaterdepth = 0,
		objectname = "Units/scavboss/CORASSISTDRONE.s3o",
		script = "Units/CORCA.cob",
		seismicsignature = 0,
		selfdestructas = "smallExplosionGenericSelfd",
		sightdistance = 200,
		terraformspeed = 225,
		turninplaceanglelimit = 360,
		turnrate = 740,
		workertime = 100*Spring.GetModOptions().assistdronesbuildpowermultiplier,
		buildoptions = {
			"corsolar",
			"coradvsol",
			"corwin",
			"corgeo",
			"cormstor",
			"corestor",
			"legmex",
			"legmext15",
			"cormakr",
			"leglab",
			"legvp",
			"legap",
			"coreyes",
			"corrad",
			"cordrag",
			"corllt",
			"corrl",
			"cordl",
			"cortide",
			"coruwms",
			"coruwes",
			-- "coruwmex",
			"corfmkr",
			"corsy",
			"corfdrag",
			"cortl",
			"corfrt",
			"corfrad",
			-- Experimental:
			"corhp",
			"corfhp",
		},
		customparams = {
			unitgroup = 'builder',
			area_mex_def = "legmex",
			model_author = "Mr Bob, Flaka",
			normaltex = "unittextures/cor_normal.dds",
			subfolder = "cortex_aircraft",
		},
		sfxtypes = {
			crashexplosiongenerators = {
				[1] = "crashing-small",
				[2] = "crashing-small",
				[3] = "crashing-small2",
				[4] = "crashing-small3",
				[5] = "crashing-small3",
			},
			pieceexplosiongenerators = {
				[1] = "airdeathceg2-builder",
				[2] = "airdeathceg3-builder",
			},
		},
		sounds = {
			build = "nanlath2",
			canceldestruct = "cancel2",
			repair = "repair2",
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
				[1] = "vtolcrmv",
			},
			select = {
				[1] = "vtolcrac",
			},
		},
	},
}
