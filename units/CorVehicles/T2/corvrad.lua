local unitName = Spring.I18N('units.names.corvrad')

return {
	corvrad = {
		acceleration = 0.01043,
		activatewhenbuilt = true,
		brakerate = 0.02086,
		buildcostenergy = 1300,
		buildcostmetal = 92,
		buildpic = "CORVRAD.DDS",
		buildtime = 4223,
		canattack = false,
		canmove = true,
		category = "ALL TANK MOBILE NOTSUB NOWEAPON NOTSHIP NOTAIR NOTHOVER SURFACE EMPABLE",
		collisionvolumeoffsets = "0 0 0",
		collisionvolumescales = "24 18 29",
		collisionvolumetype = "box",
		corpse = "dead",
		description = Spring.I18N('units.descriptions.corvrad'),
		explodeas = "smallexplosiongeneric",
		footprintx = 3,
		footprintz = 3,
		idleautoheal = 5,
		idletime = 1800,
		leavetracks = true,
		maxdamage = 510,
		maxslope = 16,
		maxvelocity = 1.2,
		maxwaterdepth = 0,
		movementclass = "TANK3",
		name = unitName,
		objectname = "Units/CORVRAD.s3o",
		onoffable = false,
		radardistance = 2200,
		script = "Units/CORVRAD.cob",
		selfdestructas = "smallExplosionGenericSelfd",
		sightdistance = 900,
		sonardistance = 0,
		trackstrength = 10,
		tracktype = "corwidetracks",
		trackwidth = 23,
		turninplace = true,
		turninplaceanglelimit = 90,
		turninplacespeedlimit = 0.825,
		turnrate = 210,
		customparams = {
			unitgroup = 'util',
			model_author = "Beherith",
			normaltex = "unittextures/cor_normal.dds",
			subfolder = "corvehicles/t2",
			techlevel = 2,
		},
		featuredefs = {
			dead = {
				blocking = true,
				category = "corpses",
				collisionvolumeoffsets = "-0.611381530762 -0.0270607836914 -0.43489074707",
				collisionvolumescales = "23.1105194092 8.20951843262 32.5806274414",
				collisionvolumetype = "Box",
				damage = 546,
				description = Spring.I18N('units.dead', { name = unitName }),
				energy = 0,
				featuredead = "HEAP",
				featurereclamate = "SMUDGE01",
				footprintx = 2,
				footprintz = 2,
				height = 20,
				hitdensity = 100,
				metal = 64,
				object = "Units/corvrad_dead.s3o",
				reclaimable = true,
				seqnamereclamate = "TREE1RECLAMATE",
				world = "All Worlds",
			},
			heap = {
				blocking = false,
				category = "heaps",
				collisionvolumescales = "35.0 4.0 6.0",
				collisionvolumetype = "cylY",
				damage = 450,
				description = Spring.I18N('units.heap', { name = unitName }),
				energy = 0,
				featurereclamate = "SMUDGE01",
				footprintx = 2,
				footprintz = 2,
				height = 4,
				hitdensity = 100,
				metal = 48,
				object = "Units/cor2X2F.s3o",
				reclaimable = true,
				resurrectable = 0,
				seqnamereclamate = "TREE1RECLAMATE",
				world = "All Worlds",
			},
		},
		sfxtypes = {
			explosiongenerators = {
				[1] = "custom:radarpulse_t2",
			},
			pieceexplosiongenerators = {
				[1] = "deathceg2",
				[2] = "deathceg3",
				[3] = "deathceg4",
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
				[1] = "vcormove",
			},
			select = {
				[1] = "cvradsel",
			},
		},
	},
}
