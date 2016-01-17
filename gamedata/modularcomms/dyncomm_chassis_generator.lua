local chassisDefs = {
	{
		name = "dynrecon1",
		weapons = {
			"commweapon_peashooter",
			"commweapon_beamlaser",
			"commweapon_lparticlebeam",
			"commweapon_disruptor",
			"commweapon_shotgun",
			"commweapon_shotgun_disrupt",
			"commweapon_lightninggun",
			"commweapon_flamethrower",
			"commweapon_heavymachinegun",
			"commweapon_heavymachinegun_disrupt",
			"commweapon_multistunner",
			"commweapon_napalmgrenade",
			"commweapon_clusterbomb",
			"commweapon_disruptorbomb",
			"commweapon_concussion",
			-- Space for shield
		}
	},
	{
		name = "dynsupport1",
		weapons = {
			"commweapon_peashooter",
			"commweapon_beamlaser",
			"commweapon_shotgun",
			"commweapon_shotgun_disrupt",
			"commweapon_lparticlebeam",
			"commweapon_disruptor",
			"commweapon_hparticlebeam",
			"commweapon_heavy_disruptor",
			"commweapon_lightninggun",
			"commweapon_lightninggun_improved",
			"commweapon_missilelauncher",
			"commweapon_shockrifle",
			"commweapon_multistunner",
			"commweapon_multistunner_improved",
			"commweapon_disruptorbomb",
			-- Space for shield
		}
	},
	{
		name = "dynassault1",
		weapons = {
			"commweapon_peashooter",
			"commweapon_beamlaser",
			"commweapon_heatray",
			"commweapon_heavymachinegun",
			"commweapon_heavymachinegun_disrupt",
			"commweapon_flamethrower",
			"commweapon_rocketlauncher",
			"commweapon_rocketlauncher_napalm",
			"commweapon_hpartillery",
			"commweapon_hpartillery_napalm",
			"commweapon_riotcannon",
			"commweapon_riotcannon_napalm",
			"commweapon_disintegrator",
			"commweapon_slamrocket",
			"commweapon_clusterbomb",
			-- Space for shield
		}
	},
}

local commanderCost = 1000
if (Spring.GetModOptions) then
	local modOptions = Spring.GetModOptions()
	if (modOptions and modOptions.commtest and modOptions.commtest ~= 0) then
		commanderCost = 100
	end
end

local statOverrides = {
	cloakcost       = 5, -- For personal cloak
	cloakcostmoving = 10, 
	onoffable       = true, -- For jammer and cloaker toggling
	canmanualfire   = true, -- For manualfire weapons.
	buildcostmetal  = commanderCost,
	buildcostenergy = commanderCost,
	buildtime       = commanderCost,
}

for i = 1, #chassisDefs do
	local name = chassisDefs[i].name
	local unitDef = UnitDefs[name]
	
	for _, wreckDef in pairs(unitDef.featuredefs) do
		wreckDef.metal = wreckDef.metal*commanderCost/1200
		wreckDef.reclaimtime = wreckDef.reclaimtime*commanderCost/1200
	end
	
	for key, data in pairs(statOverrides) do
		unitDef[key] = data
	end
	
	for i = 1, 7 do
		unitDef.sfxtypes.explosiongenerators[i] = unitDef.sfxtypes.explosiongenerators[i] or [[custom:NONE]]
	end
	
	for num = 1, #chassisDefs[i].weapons do
		weaponName = chassisDefs[i].weapons[num]
		DynamicApplyWeapon(unitDef, weaponName, num)
	end
	
	if #chassisDefs[i].weapons > 16 then
		Spring.Echo("Too many commander weapons on:", name, "Limit is 16, found weapons:", #chassisDefs[i].weapons)
	end
end