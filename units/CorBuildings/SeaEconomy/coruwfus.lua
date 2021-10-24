local unitName = Spring.I18N('units.names.coruwfus')

return {
	coruwfus = {
		acceleration = 0,
		activatewhenbuilt = true,
		brakerate = 0,
		buildangle = 8192,
		buildcostenergy = 34000,
		buildcostmetal = 5400,
		buildinggrounddecaldecayspeed = 30,
		buildinggrounddecalsizex = 8,
		buildinggrounddecalsizey = 8,
		buildinggrounddecaltype = "decals/coruwfus_aoplane.dds",
		buildpic = "CORUWFUS.DDS",
		buildtime = 105004,
		canrepeat = false,
		category = "ALL NOTLAND NOTSUB NOWEAPON NOTSHIP NOTAIR NOTHOVER SURFACE UNDERWATER EMPABLE",
		corpse = "DEAD",
		description = Spring.I18N('units.descriptions.coruwfus'),
		energymake = 1220,
		energystorage = 2500,
		explodeas = "fusionExplosion-uw",
		footprintx = 5,
		footprintz = 5,
		hidedamage = true,
		icontype = "building",
		idleautoheal = 5,
		idletime = 1800,
		maxdamage = 5350,
		maxslope = 16,
		minwaterdepth = 25,
		name = unitName,
		objectname = "Units/CORUWFUS.s3o",
		script = "Units/CORUWFUS.cob",
		seismicsignature = 0,
		selfdestructas = "fusionExplosionSelfd-uw",
		sightdistance = 143,
		usebuildinggrounddecal = true,
		yardmap = "ooooooooooooooooooooooooo",
		customparams = {
			unitgroup = 'energy',
			model_author = "Mr Bob",
			normaltex = "unittextures/cor_normal.dds",
			removestop = true,
			removewait = true,
			subfolder = "corbuildings/seaeconomy",
		},
		featuredefs = {
			dead = {
				blocking = true,
				category = "corpses",
				collisionvolumeoffsets = "1.8653717041 -0.0807505981445 0.994560241699",
				collisionvolumescales = "89.9762878418 27.3368988037 72.5986480713",
				collisionvolumetype = "Box",
				damage = 3210,
				description = Spring.I18N('units.dead', { name = unitName }),
				energy = 0,
				featuredead = "HEAP",
				footprintx = 5,
				footprintz = 5,
				height = 20,
				hitdensity = 100,
				metal = 3099,
				object = "Units/coruwfus_dead.s3o",
				reclaimable = true,
				seqnamereclamate = "TREE1RECLAMATE",
				world = "All Worlds",
			},
			heap = {
				blocking = false,
				category = "heaps",
				damage = 1605,
				description = Spring.I18N('units.heap', { name = unitName }),
				energy = 0,
				footprintx = 5,
				footprintz = 5,
				height = 4,
				hitdensity = 100,
				metal = 1240,
				object = "Units/cor5X5A.s3o",
				reclaimable = true,
				resurrectable = 0,
				seqnamereclamate = "TREE1RECLAMATE",
				world = "All Worlds",
			},
		},
		sfxtypes = {
			pieceexplosiongenerators = {
				[1] = "deathceg2",
				[2] = "deathceg3",
				[3] = "deathceg4",
			},
		},
		sounds = {
			canceldestruct = "cancel2",
			underattack = "warning1",
			count = {
				[1] = "count6",
				[2] = "count5",
				[3] = "count4",
				[4] = "count3",
				[5] = "count2",
				[6] = "count1",
			},
			select = {
				[1] = "watfusn2",
			},
		},
	},
}
