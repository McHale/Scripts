--==================================
-- Script Name: Fire Champ Looter
-- Author: McHale
-- Version: 1.0
-- OpenEUO version tested with: 0.91
-- Purpose: Loots Gold, Gargoyle Pickaxe, Knife
--==================================

dofile("../Lib/basiclib.lua")
dofile("../Lib/itemlib.lua")
dofile("../Lib/storagelib.lua")
dofile("../Lib/config.lua")

-----------------------Variables to change------------------
-- Master loot list
-- See Lib/Storagelib.lua for items types
-- Change variables in your Lib/config.lua
-- Currently Looting pickaxe, skinning knife, and gold

toLoot = {5110,3718,3821}
------------------------------------------------------------   

------------------------------------------------------------
-- how to find corpses nearby and loots stuff from them
-- and claim them
------------------------------------------------------------

function loot()

	-- find gargoyle corpses
	corpses = item:scan():ground(2):tp(8198):property():name({"A Gargoyle Corpse","A Charred Corpse"})
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
			end
		   end
		-- drop tools into your backpack
		else
                    if UO.weight < MAX_WEIGHT then
		    	looted:drop(UO.BackpackID)
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
