--==========================================================
-- Script Name: Leather Looter
-- Author: McHale
-- Version: 1.0
-- OpenEUO version tested with: 0.91
-- Purpose: Pathfind to Corpses, Cut and Loot
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
4217,4225,9908,3576,4110,4111,4112,4115,3535,3962,3963,3972,3973,3974,3976,
3980,3981,3960,3983,3965,3982,3978,3969,9911,9912,3966,3968,3827,3854,5154,
3620,2426,3615,7956,4586,6464,3821,3885,3878,3859,3865,3873,3862,3856,7847,
3861,3877,12693,12695,12697,12692,12696,12690,12691,12694}

KNIFE_TYPE = 5049
------------------------------------------------------------   
---------------------VARIABLES TO TEST----------------------
------------------------------------------------------------   
backpack = item:scan():cont(UO.BackpackID):tp(KNIFE_TYPE)
if next(backpack) == nil then
	--UO.ExMsg for needing a skinning knife
	return
else
	knife = backpack:pop()
end

function zero(element)
	 local x = math.abs(UO.CharPosX-element.x)
	 local y = math.abs(UO.CharPosY-element.y)
         if x < 2 and y < 2 then
            return true
         end
         return false
end



------------------------------------------------------------   
---------------------LOOTING FUNCTION-----------------------
------------------------------------------------------------

function loot()
	-- find corpses
	corpses = item:scan():ground(10):tp(8198)
	local next = next
	if next(corpses) == nil then
		return
	end

	UO.Key("ESC")
	wait(500)
	local corpse = corpses:nearest()
	UO.Pathfind(corpse.x,corpse.y,corpse.z)
	while not zero(corpse) do
		wait(10)
	end
	knife:use():waitTarget():target(corpse.id)
	wait(1000)

	
	loots = item:scan():cont(corpse.id):tp(toLoot)

	-- grab of a list of ids for all items on all corpses that match the toLoot list
	loots = item:scan():cont(corpses:getIDs()):tp(toLoot)
	for i = 1,#loots do
		looted = loots:pop(i)
		wait(100)
		-- loot gold
		if looted.tp == 3821 and LOOT_GOLD then
		   if BOH then
		   	looted:drop(BOH_ID)
		   else
			if UO.weight < MAX_WEIGHT then
				looted:drop(UO.BackpackID)
			else if BOS then
				Storage.storeGoldBOS()
			end
		   end
		-- drop items into your backpack
		else
                    if UO.weight < MAX_WEIGHT then
			if looted.tp == 4217 then
				if BOH then
					looted:drop(BOH_ID)
				else
		    			looted:drop(UO.BackpackID)
				end
			end
		    else if STORAGE_KEYS then
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
