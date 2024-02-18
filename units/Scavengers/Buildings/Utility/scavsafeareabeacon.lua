return {
	scavsafeareabeacon = {
		maxacc = 0,
		activatewhenbuilt = true,
		maxdec = 0,
		buildangle = 8192,
		energycost = 100000,
		metalcost = 10000,
		buildpic = "scavengers/scavsafeareabeacon.DDS",
		buildtime = 100000,
		blocking = false,
		canrepeat = false,
		category = "ALL NOTLAND NOTSUB NOWEAPON NOTSHIP NOTAIR NOTHOVER SURFACE EMPABLE",
		cloakcost = 10,
		explodeas = "scavcomexplosion",
		footprintx = 5,
		footprintz = 5,
		idleautoheal = 5,
		idletime = 300,
		initcloaked = true,
		levelground = false,
		health = 2800,
		maxslope = 24,
		maxwaterdepth = 0,
		mincloakdistance = 250,
		objectname = "scavs/scavsafeareabeacon.s3o",
		script = "Units/ARMEYES.cob",
		seismicsignature = 0,
		sightdistance = 1560,
		stealth = true,
		waterline = 5,
		yardmap = "",
		reclaimable = false,
		customparams = {
			model_author = "Beherith",
			normaltex = "unittextures/Arm_normal.dds",
			removestop = true,
			removewait = true,
			subfolder = "armada_buildings/landutil",
		},
		sfxtypes = {
			pieceexplosiongenerators = {
				[1] = "deathceg2",
			},
		},
		sounds = {
			canceldestruct = "cancel2",
			underattack = "warning1",
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
				[1] = "servsml6",
			},
			select = {
				[1] = "minesel1",
			},
		},
	},
}
