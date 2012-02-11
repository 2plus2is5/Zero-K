unitDef = {
  unitname                      = [[armsolar]],
  name                          = [[Solar Collector]],
  description                   = [[Produces Energy (2)]],
  acceleration                  = 0,
  activateWhenBuilt             = true,
  brakeRate                     = 0,
  buildAngle                    = 4096,
  buildCostEnergy               = 70,
  buildCostMetal                = 70,
  builder                       = false,
  buildingGroundDecalDecaySpeed = 30,
  buildingGroundDecalSizeX      = 4,
  buildingGroundDecalSizeY      = 4,
  buildingGroundDecalType       = [[arm_solar_ground.dds]],
  buildPic                      = [[ARMSOLAR.png]],
  buildTime                     = 70,
  category                      = [[SINK UNARMED]],
  corpse                        = [[DEAD]],

  customParams                  = {
    description_de = [[Erzeugt Energie (2)]],
    helptext       = [[Solar collectors are the least cost-efficient of the energy structures, but they are also the most reliable and sturdy. When attacked, solars will curl up into armored form, which reduces incoming damage to a quarter and offers excellent protection against raiders.]],
	helptext_de    = [[Solaranlagen sind von den Energiestrukturen die mit der geringsten Kosteneffizienz, aber sie sind auch die verlässlichsten und stabilsten unter ihnen. Sobald sie angegriffen werden ziehen sie sich in eine gepanzerte Form zurück, die als exzellenter Schutz gegen Raider fungiert.]],
    pylonrange = 100,
  },

  damageModifier                = 0.25,
  energyMake                    = 0,
  energyUse                     = -2,
  explodeAs                     = [[SMALL_BUILDINGEX]],
  footprintX                    = 5,
  footprintZ                    = 5,
  iconType                      = [[energy1]],
  idleAutoHeal                  = 5,
  idleTime                      = 1800,
  mass                          = 104,
  maxDamage                     = 500,
  maxSlope                      = 18,
  maxVelocity                   = 0,
  maxWaterDepth                 = 0,
  minCloakDistance              = 150,
  noAutoFire                    = false,
  objectName                    = [[arm_solar.s3o]],
  onoffable                     = true,
  script						= [[armsolar.lua]],
  seismicSignature              = 4,
  selfDestructAs                = [[SMALL_BUILDINGEX]],
  side                          = [[ARM]],
  sightDistance                 = 273,
  turnRate                      = 0,
  useBuildingGroundDecal        = true,
  workerTime                    = 0,
  yardMap                       = [[ooooooooooooooooooooooooo]],

  featureDefs                   = {

    DEAD  = {
      description      = [[Wreckage - Solar Collector]],
      blocking         = true,
      category         = [[corpses]],
      damage           = 500,
      energy           = 0,
      featureDead      = [[HEAP]],
      featurereclamate = [[SMUDGE01]],
      footprintX       = 5,
      footprintZ       = 5,
      height           = [[20]],
      hitdensity       = [[100]],
      metal            = 28,
      object           = [[armremake3_dead.s3o]],
      reclaimable      = true,
      reclaimTime      = 28,
      seqnamereclamate = [[TREE1RECLAMATE]],
      world            = [[All Worlds]],
    },

    HEAP  = {
      description      = [[Debris - Solar Collector]],
      blocking         = false,
      category         = [[heaps]],
      damage           = 500,
      energy           = 0,
      featurereclamate = [[SMUDGE01]],
      footprintX       = 5,
      footprintZ       = 5,
      height           = [[4]],
      hitdensity       = [[100]],
      metal            = 14,
      object           = [[debris4x4a.s3o]],
      reclaimable      = true,
      reclaimTime      = 14,
      seqnamereclamate = [[TREE1RECLAMATE]],
      world            = [[All Worlds]],
    },

  },

}

return lowerkeys({ armsolar = unitDef })
