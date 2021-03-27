--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
if not gadgetHandler:IsSyncedCode() then
	return
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function gadget:GetInfo()
    return {
        name      = "Controls Unit's maxrange",
        desc      = "Fixes some aa/ground units not closing in on target when given attack order",
        author    = "Doo",
        date      = "06 dec 2017",
        layer     = 0,
        enabled   = true  --  loaded by default?
    }
end

-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------

local unitMaxRange = {}
for unitDefID, unitDef in pairs(UnitDefs) do
    if unitDef.customParams.maxrange then
        unitMaxRange[unitDefID] = tonumber(unitDef.customParams.maxrange)
    end
end

function gadget:Initialize()
	for ct, unitID in pairs(Spring.GetAllUnits()) do
		gadget:UnitCreated(unitID, Spring.GetUnitDefID(unitID))
	end
end

function gadget:UnitCreated(unitID, unitDefID, unitTeam)
	if unitMaxRange[unitDefID] then
		Spring.SetUnitMaxRange(unitID, unitMaxRange[unitDefID])
	end
end