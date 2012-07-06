--==========================================================
-- Script Name: Resource Application
-- Author: McHale
-- Version: 1.0
-- OpenEUO version tested with: 0.91
-- Purpose: Manipulation of Various Resources
--==========================================================

dofile("../Lib/craftlib.lua")
dofile("../Lib/itemlib.lua")
dofile("../Lib/menuLib.lua")
dofile("../Lig/config.lua")

local bohID = 1076683851

function targetItem(message)
	UO.ExMsg(UO.CharID,3,50,message)
	UO.Macro(13,3)
	wait(750)
	while UO.TargCurs do
		wait(10)
	end
	return UO.LTargetID
end

function destroyItems(profession)
	local target_id = targetItem("Please target item types to be destroyed")
	
	local target_type = item:scan():cont(UO.BackpackID):id(target_id)
	
	if next(target_type) == nil then
   		stop()
	end

	target_type = target_type:pop().tp

	local items = item:scan():cont(UO.BackpackID):tp(target_type)

	for i =1, #items do
		if profession == "tailor" then
    			Craft.Cut(items:pop(i).id)
    			wait(500)
		else 
			Craft.Smelt(items:pop(i).id)
		end
	end
end

function smeltOre()
	local container_id = targetItem("Please target container storing ore.")
	ores = item:scan():cont(container_id):tp(6585)

	if next(ores) == nil then
   		return
	end

	local mobile = item:scan():cont(UO.BackpackID):property():name("Mobile Forge")
	if next(mobile) == nil then		  
		return
	end

	mobile = mobile:pop()

	hasOre = true
	while hasOre do
		local ore = ores:pop()
    		UO.Drag(ore.id, 1)
    		UO.DropC(UO.BackpackID)
    		wait(250)
    		local oneOre = item:scan():cont(UO.BackpackID):tp(6585):pop()
    		wait(250)
    		oneOre:use():target(mobile.id)
    		wait(250)
    		ores = item:scan():cont(container_id):tp(6585)
    		wait(250)
    		if next(ores) == nil then
			hasOre = false
    		end
	end
end

function amount(to_process)
         to_process = item:scan():id(to_process.id)
         if next(to_process) ~= nil then
            return true
         end
         return false
end

function spin()
	local storage_id = targetItem("Please target container storaging wool/cotton/flax.")

	to_spin = item:scan():cont(storage_id):tp({6812,3576,3577}):pop()
	if next(to_spin) == nil then
		errorMsg("Nothing to spin")
		return
	end
		
	spinning_wheels = item:scan():ground(4):tp({11737,4121,4117})
	if next(spinning_wheels) == nil then
		errorMsg("No Spinning Wheels within 4 tiles.")
		return
	end

	local container_id = targetItem("Please target container to store yarn/thread.")
	while amount(to_spin) do
		for i = 1, #spinning_wheels do
			if UO.Weight > UO.MaxWeight or UO.Weight > 350 then
				toReturn = item:scan():cont(UO.BackpackID):tp({3613,4000})

				for i=1,#toReturn do
    					toReturn:pop(i):drop(container_id)
    					wait(500)
				end
			end
    			local wheel = spinning_wheels:pop(i)
    			to_spin:use():waitTarget():target(wheel.id)
    			wait(500)
		end
	end
end

function weave()
	local storage_id = targetItem("Please target container that is storing yarn/thread.")

	to_weave = item:scan():cont(storage_id):tp({3613,4000}):pop()
	if next(to_weave) == nil then
		errorMsg("Nothing to Weave")
		return
	end

	loom = item:scan():ground(1):tp({4191,4192}):pop()
	if next(loom) == nil then
		errorMsg("No Loom within 1 tile")
		return
	end

	local container_id = targetItem("Please target container to store cloth.")
	while amount(to_weave) do
              if UO.Weight > 350 then
                 wait(250)
	         bolts = item:scan():cont(UO.BackpackID):tp(3989)
	         for i=1,#bolts do
	             bolts:pop(i):drop(container_id)
     		     wait(500)
                 end
              end
	      to_weave:use():waitTarget():target(loom.id)
	      wait(275)
	end
end

weave()
