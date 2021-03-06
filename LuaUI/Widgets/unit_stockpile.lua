--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  file:    unit_stockpile.lua
--  brief:   adds 100 builds to all new units that can stockpile
--  author:  Dave Rodgers
--
--  Copyright (C) 2007.
--  Licensed under the terms of the GNU GPL, v2 or later.
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function widget:GetInfo()
	return {
		name      = "Stockpiler",
		desc      = "Automatically adds 100 stockpile builds to new units",
		author    = "trepan",
		date      = "Jan 8, 2007",
		license   = "GNU GPL, v2 or later",
		layer     = 0,
		enabled   = true  --  loaded by default?
	}
end

local constantStockpile = {
	[UnitDefNames["screamer"].id] = true,
}

local CMD_STOCKPILE = CMD.STOCKPILE

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
function widget:Initialize()
	 if (Spring.GetSpectatingState() or Spring.IsReplay()) and (not Spring.IsCheatingEnabled()) then
		Spring.Echo("<Stockpiler>: disabled for spectators")
		widgetHandler:RemoveWidget()
	end
end

function widget:UnitCreated(unitID, unitDefID, unitTeam)
	local ud = UnitDefs[unitDefID]
	if ((ud ~= nil) and (unitTeam == Spring.GetMyTeamID())) then
		if (ud.canStockpile) then
			-- give stockpilers 100 units to build
			Spring.GiveOrderToUnit(unitID, CMD.STOCKPILE, {}, { "ctrl", "shift" })
		end
	end
end

function widget:StockpileChanged(unitID, unitDefID, unitTeam, weaponNum, oldCount, newCount)
	if constantStockpile[unitDefID] then
		Spring.GiveOrderToUnit(unitID, CMD_STOCKPILE, {}, {})
	end
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
