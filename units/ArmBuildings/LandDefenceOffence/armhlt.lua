local unitName = Spring.I18N('units.names.armhlt')

return {
	armhlt = {
		acceleration = 0,
		brakerate = 0,
		buildangle = 8192,
		buildcostenergy = 4700,
		buildcostmetal = 440,
		buildinggrounddecaldecayspeed = 30,
		buildinggrounddecalsizex = 4,
		buildinggrounddecalsizey = 4,
		buildinggrounddecaltype = "decals/armhlt_aoplane.dds",
		buildpic = "ARMHLT.DDS",
		buildtime = 12500,
		canrepeat = false,
		category = "ALL NOTLAND WEAPON NOTSUB NOTSHIP NOTAIR NOTHOVER SURFACE EMPABLE",
		collisionvolumeoffsets = "0 11 0",
		collisionvolumescales = "36 88 36",
		collisionvolumetype = "CylY",
		corpse = "DEAD",
		description = Spring.I18N('units.descriptions.armhlt'),
		explodeas = "mediumBuildingExplosionGeneric",
		footprintx = 2,
		footprintz = 2,
		icontype = "building",
		idleautoheal = 5,
		idletime = 1800,
		maxdamage = 2325,
		maxslope = 10,
		maxwaterdepth = 0,
		name = unitName,
		nochasecategory = "MOBILE",
		objectname = "Units/ARMHLT.s3o",
		script = "Units/ARMHLT.cob",
		seismicsignature = 0,
		selfdestructas = "mediumBuildingExplosionGenericSelfd",
		sightdistance = 494,
		usebuildinggrounddecal = true,
		yardmap = "oooo",
		customparams = {
			unitgroup = 'weapon',
			model_author = "Beherith",
			normaltex = "unittextures/Arm_normal.dds",
			removewait = true,
			subfolder = "armbuildings/landdefenceoffence",
		},
		featuredefs = {
			dead = {
				blocking = true,
				category = "corpses",
				collisionvolumeoffsets = "-0.0445556640625 -0.0718220947266 6.04946899414",
				collisionvolumescales = "42.0427246094 74.7609558105 56.8743896484",
				collisionvolumetype = "Box",
				damage = 1395,
				description = Spring.I18N('units.dead', { name = unitName }),
				energy = 0,
				featuredead = "HEAP",
				featurereclamate = "SMUDGE01",
				footprintx = 2,
				footprintz = 2,
				height = 20,
				hitdensity = 100,
				metal = 269,
				object = "Units/armhlt_dead.s3o",
				reclaimable = true,
				seqnamereclamate = "TREE1RECLAMATE",
				world = "All Worlds",
			},
			heap = {
				blocking = false,
				category = "heaps",
				collisionvolumescales = "35.0 4.0 6.0",
				collisionvolumetype = "cylY",
				damage = 698,
				description = Spring.I18N('units.heap', { name = unitName }),
				energy = 0,
				featurereclamate = "SMUDGE01",
				footprintx = 2,
				footprintz = 2,
				height = 4,
				hitdensity = 100,
				metal = 108,
				object = "Units/arm2X2A.s3o",
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
			cloak = "kloak1",
			uncloak = "kloak1un",
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
				[1] = "twractv3",
			},
			select = {
				[1] = "twractv3",
			},
		},
		weapondefs = {
			arm_laserh1 = {
				areaofeffect = 14,
				avoidfeature = false,
				beamtime = 0.15,
				corethickness = 0.25,
				craterareaofeffect = 0,
				craterboost = 0,
				cratermult = 0,
				edgeeffectiveness = 0.15,
				energypershot = 75,
				explosiongenerator = "custom:laserhit-medium-green",
				firestarter = 90,
				impactonly = 1,
				impulseboost = 0,
				impulsefactor = 0,
				laserflaresize = 9.9,
				name = "Heavy g2g high energy laser",
				noselfdamage = true,
				range = 620,
				reloadtime = 1.8,
				rgbcolor = "0 1 0",
				soundhitdry = "",
				soundhitwet = "sizzle",
				soundstart = "Lasrmas2",
				soundtrigger = 1,
				targetmoveerror = 0.2,
				thickness = 3,
				tolerance = 10000,
				turret = true,
				weapontype = "BeamLaser",
				weaponvelocity = 2250,
				damage = {
					bombers = 35,
					commanders = 700,
					default = 387,
					fighters = 35,
					vtol = 35,
				},
			},
		},
		weapons = {
			[1] = {
				badtargetcategory = "VTOL",
				def = "ARM_LASERH1",
				onlytargetcategory = "NOTSUB",
			},
		},
	},
}
