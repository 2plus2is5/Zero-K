unitDef = {
  unitname                      = [[factoryplane]],
  name                          = [[Airplane Plant]],
  description                   = [[Produces Airplanes, Builds at 6 m/s]],
  acceleration                  = 0,
  activateWhenBuilt             = false,
  brakeRate                     = 0,
  buildCostEnergy               = 550,
  buildCostMetal                = 550,
  builder                       = true,
  buildingGroundDecalDecaySpeed = 30,
  buildingGroundDecalSizeX      = 9,
  buildingGroundDecalSizeY      = 7,
  buildingGroundDecalType       = [[factoryplane_aoplane.dds]],

  buildoptions                  = {
    [[armca]],
    [[fighter]],
    [[corvamp]],
    [[corshad]],
    [[corhurc2]],
    [[armstiletto_laser]],
    [[armcybr]],
    [[corawac]],
  },

  buildPic                      = [[factoryplane.png]],
  buildTime                     = 550,
  canMove                       = true,
  canPatrol                     = true,
  canstop                       = [[1]],
  category                      = [[SINK UNARMED]],
  collisionVolumeTest           = 1,
  corpse                        = [[DEAD]],

  customParams                  = {
    description_de = [[Produziert Flugzeuge]],
    helptext       = [[The Airplane Plant offers a variety of fixed-wing aircraft to suit your needs. Choose between multirole fighters that can double as light attackers or specialized interceptors, and between precision bombers for taking down specific targets or their saturation counterparts for destroying swarms.]],
	helptext_de    = [[Das Airplane Plant erm�glicht den Bau vielf�ltiger Starrfl�gelflugzeuge, um deine Bed�rfnisse zu stillen. W�hle zwischen Allzweckj�gern, die sowohl leichte Attacken fliegen k�nnen, als auch als Abfangj�ger fungieren, und pr�zisen Bombern, um spezielle Ziele zu vernichten.]],
    sortName = [[4]],
  },

  energyMake                    = 0.225,
  energyUse                     = 0,
  explodeAs                     = [[LARGE_BUILDINGEX]],
  fireState                     = 0,
  footprintX                    = 8,
  footprintZ                    = 6,
  iconType                      = [[facair]],
  idleAutoHeal                  = 5,
  idleTime                      = 1800,
  isAirBase                     = true,
  mass                          = 324,
  maxDamage                     = 4000,
  maxSlope                      = 15,
  maxVelocity                   = 0,
  metalMake                     = 0.225,
  minCloakDistance              = 150,
  noAutoFire                    = false,
  objectName                    = [[CORAP.s3o]],
  script                        = [[factoryplane.lua]],
  seismicSignature              = 4,
  selfDestructAs                = [[LARGE_BUILDINGEX]],
  showNanoSpray                 = false,
  side                          = [[CORE]],
  sightDistance                 = 273,
  turnRate                      = 0,
  useBuildingGroundDecal        = true,
  workerTime                    = 6,
  yardMap                       = [[ooooooo ooooooo occccco occccco occccco occccco]],

  featureDefs                   = {

    DEAD = {
      description      = [[Wreckage - Airplane Plant]],
      blocking         = true,
      category         = [[corpses]],
      damage           = 4000,
      energy           = 0,
      featureDead      = [[HEAP]],
      featurereclamate = [[SMUDGE01]],
      footprintX       = 7,
      footprintZ       = 6,
      height           = [[20]],
      hitdensity       = [[100]],
      metal            = 220,
      object           = [[corap_dead.s3o]],
      reclaimable      = true,
      reclaimTime      = 220,
      seqnamereclamate = [[TREE1RECLAMATE]],
      world            = [[All Worlds]],
    },


    HEAP = {
      description      = [[Debris - Airplane Plant]],
      blocking         = false,
      category         = [[heaps]],
      damage           = 4000,
      energy           = 0,
      featurereclamate = [[SMUDGE01]],
      footprintX       = 6,
      footprintZ       = 6,
      height           = [[4]],
      hitdensity       = [[100]],
      metal            = 110,
      object           = [[debris4x4c.s3o]],
      reclaimable      = true,
      reclaimTime      = 110,
      seqnamereclamate = [[TREE1RECLAMATE]],
      world            = [[All Worlds]],
    },

  },

}

return lowerkeys({ factoryplane = unitDef })
