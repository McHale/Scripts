--==========================================================
-- Script Name: Doom Looter
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
-- Currently Looting: ??

toLoot = {3968,3821,3625,8765,9007,3535} 



------------------------------------------------------------   
---------------------LOOTING FUNCTION-----------------------
------------------------------------------------------------
   
function loot()

	corpses = item:scan():ground(2):tp(8198)
	local next = next
	if next(corpses) == nil then
		return
	end

	loots = item:scan():cont(corpses:getIDs()):tp(toLoot)
	for i = 1,#loots do
		looted = loots:pop(i)
		wait(100)

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
		else
                    if UO.weight < MAX_WEIGHT then
		    	looted:drop(UO.BackpackID)
		    elseif STORAGE_KEYS then
			Storage.storeAll()
	            end
		end   
	end

	pop:say("[claim"):waitTarget()

	for i = 1,#corpses do
		corpses:pop(i):target():waitTarget()
	end
	UO.Key("ESC")
end

while true do
	loot()
	wait(1500)
end
