

    ------------------------------------------------------------
    -- how to find corpses nearby and loots stuff from them
    -- and claim them
    ------------------------------------------------------------
--==========================================================
-- Script Name: Comprehensive Looter
-- Author: McHale
-- Version: 1.0
-- OpenEUO version tested with: 0.91
-- Purpose: Loot Doom Related Items
--==========================================================

------------------------------------------------------------   
--------------------------IMPORTS---------------------------
------------------------------------------------------------   

dofile("../Lib/basiclib.lua")
dofile("../Lib/itemlib.lua")
dofile("../Lib/storagelib.lua")
dofile("../Lib/config.lua")



------------------------------------------------------------   
--------------------VARIABLES TO CHANGE---------------------
------------------------------------------------------------   
-- Master loot list
-- See Lib/Storagelib.lua for items types
-- Change variables in your Lib/config.lua
-- Currently Looting: EVERYTHING

toLoot = { 
4110,4111,4112,4115,3535,3962,3963,3972,3973,3974,3976,3980,
3981,3960,3983,3965,3982,3978,3969,9911,9912,3966,3968,3827,
3854,5154,3620,2426,3615,7956,4586,6464,3821,3885,3878,3859,
3865,3873,3862,3856,7847,3861,3877,12693,12695,12697,12692,
12696,12690,12691,12694}


------------------------------------------------------------   
---------------------LOOTING FUNCTION-----------------------
------------------------------------------------------------
   
function loot()

	-- find corpses
	corpses = item:scan():ground(2):tp(8198)
	local next = next
	if next(corpses) == nil then
		return
	end

	-- grab of a list of ids for all items on all corpses that match the toLoot list
	loots = item:scan():cont(corpses:getIDs()):tp(toLoot)
	for i = 1,#loots do
		looted = loots:pop(i)
		wait(100)
		-- loot gold
		if looted.tp == 3821 and LOOT_GOLD then
		   if boh then
		   	looted:drop(BOH_ID)
		   else
			if UO.weight < MAX_WEIGHT then
				looted:drop(UO.BackpackID)
			elseif BOS then
				Storage.storeGoldBOS()
			end
		   end
		-- drop tools into your backpack
		else
                    if UO.weight < MAX_WEIGHT then
		    	looted:drop(UO.BackpackID)
		    elseif STORAGE_KEYS then
			Storage.storeAll()
	            end
		end   
	end
	-- claim them
	pop:say("[claim"):waitTarget()


	for i = 1,#corpses do
		corpses:pop(i):target():waitTarget()
	end
	UO.Key("ESC")
end

-- looping until user stops script
while true do
	loot()
	wait(1500)
end
