--==========================================================
-- Script Name: Bee Tending Application
-- Author: McHale
-- Version: 1.0
-- OpenEUO version tested with: 0.91
-- Purpose: Tending and Harvesting Bee Hives
--==========================================================

dofile("../Lib/itemlib.lua")
dofile("../Lib/functions.lua")
dofile("../Lib/menulib.lua")
dofile("../Lig/config.lua")
-----------BEE LIST----------
local potions = {"Agility","Poison","Cure","Heal","Strength"}
local potionPresent = {1,1,1,1,1}
local potionClickX = 210
local potionClickY = {55,80,105, 130, 155}
local potionStatusX = 196
local potionStatusY =  {54,80,104,130,154}

----BEE STATUS--------------
---0: no pots, 1: 1 pot, 2: 2 pots
function infestationStatus(id)
         local status = UO.GetPix(UO.ContPosX+84 ,UO.ContPosY+80)
         if status == 59367 then
            UO.ExMsg(id,3,48,"yellow infestation")
            return 1
         elseif status == 4340025 then
            UO.ExMsg(id,3,68,"infestation free")
            return 0
         else --red status
            UO.ExMsg(id,3,33,"red infestation")
            return 2
         end
end
function diseaseStatus(id)
         local status = UO.GetPix(UO.ContPosX+84 ,UO.ContPosY+105)
         if status == 59367 then
            UO.ExMsg(id,3,48,"yellow disease")
            return 1
         elseif status == 3746089 then
            UO.ExMsg(id,3,68,"disease free")
            return 0
         else --red status
            UO.ExMsg(id,3,33,"red disease")
            return 2
         end
end

function healthStatus(bee_hive)
	local name = bee_hive.name
	if name == "Thriving BeeHive" then
		return 0
	elseif name == "Healthy BeeHive" then
		return 1
	elseif name == "Sickly BeeHive" then
		return 2
	else
		return 2
	end
end

function analyzeNumber(potion_id)
	local x = UO.ContPosX+potionStatusX
        local y = UO.ContPosY+potionStatusY[potion_id]
        local orc_1 = UO.GetPix(x,y)
	y = y + 4
	local orc_2 = UO.GetPix(x,y)
	if (orc_1 == 13024701 or orc_1 == 15724502) and
		(orc_2 == 13024701 or orc_2 == 15724502) then
		return 0
	end
	if (orc_1 == 13024701 or orc_1 == 15724502) then
		return 2
	end
	return 1
end

---APPLYING POTIONS---

local timeout = 500
--[[
function waitGump(x,y)
    local current_time = getticks()
    while true do
          if UO.ContSizeX == x and UO.ContSizeY == y then
             return
          end
         wait(5)
         if getticks()-current_time > timeout then
            return
         end
    end
end
--]]
function pressDots()
    for i = UO.ContPosX+20, UO.ContPosX+158, 4 do
        for j = UO.ContPosY+6, UO.ContPosY+138 do
             local pix = UO.GetPix(i,j)
             if pix == 1052812 or pix == 1052804 then
                 UO.Click(i,j,true,true,true,false)
                 wait(50)
             end
             if UO.ContSizeX == 258 and UO.ContSizeY == 219 then
                return
             end
             --waitGump(178,178)
			 pop:waitContSize(178, 178)
        end
    end
end

function applyPotion(bee_id, potion_id, num_clicks)
         local applied = analyzeNumber(potion_id)
         while applied < num_clicks do
               Click.Gump(potionClickX, potionClickY[potion_id])
               --waitGump(178,178)
			   pop:waitContSize(178,178)
               pressDots()
               if UO.ContSizeX == 178 and UO.ContSizeY == 178 then --intended or needed?
                  pressDots()
               end
	       sucApplied = analyzeNumber(potion_id)
	       if sucApplied == applied then
			potionPresent[potion_id] = 0
			return
	       end
	       applied = sucApplied
         end
end

function potion()
potionPresent = {1,1,1,1,1}
bee_hives = item:scan():ground(2):tp(2330):property()
local next = next
if next(bee_hives) == nil then
	errorMsg("You are not near any bees.")
end
for i=1,#bee_hives do
    local hive =bee_hives:pop(i)
    hive:use():waitContSize(UO.ContSizeX,UO.ContSizeY):wait(1000)
    local infestation = infestationStatus(hive.id)
    wait(250)
    local disease = diseaseStatus(hive.id)
    wait(250)
    local health = healthStatus(hive)
    if potionPresent[1] == 1 then
    	applyPotion(hive.id, 1, 2)
    	wait(250)
    end
    if potionPresent[2] == 1 then
	applyPotion(hive.id, 2, infestation)
	wait(250)
    end
    if potionPresent[3] == 1 then
    	applyPotion(hive.id, 3, disease)
    	wait(250)
    end
    if potionPresent[4] == 1 then
	applyPotion(hive.id, 4, health)
	Click.CloseGump()
    end
end
for i=1,#potionPresent do
	if potionPresent[i] == 0 then
		UO.ExMsg(UO.CharID,string.format("You need a keg of greater %s",potions[i]))
		wait(500)
	end
end
end

-------------BeeHive Resources & Supples-----
local tools_names = {"Hive Tool","Small Wax Pot","Empty Bottle"}
local tools_types = {2549, 2532, 3854}


function checkTools(tool_type)
	local next = next
	local tools = item:scan():cont(UO.BackpackID):tp(tool_type):property()
	if next(tools) == nil then
		return false
	end
	return tools:pop()
end

function collectHoney()
if not checkTools(2549) then
	errorMsg("No Hive Tool")
	return
end
local oldBottles = checkTools(3854)
if not oldBottles then
	errorMsg("No Empty Bottles")
	return
end
bee_hives = item:scan():ground(2):tp(2330):property()
local next = next
if next(bee_hives) == nil then
	errorMsg("You are not near any bees.")
end
	for i=1,#bee_hives do
	    local bee_hive =bee_hives:pop(i)
	    bee_hive:use():waitContSize(258,219)
            wait(1000)
	    Click.Gump(65,55)
	    wait(250)
	    local canCollect = true
	    while canCollect do
	    		Click.Gump(210,155)
	    		wait(500)
			if not checkTools(2549) then
				errorMsg("No Hive Tool")
				Click.CloseGump()
				return
			end
			local bottles = checkTools(3854)
			if not bottles then
				errorMsg("No Empty Bottles")
				Click.CloseGump()
				return
			end
			if oldBottles.name == bottles.name then
				UO.ExMsg(bee_hive.id,3,40,"Emptied Hive")
				canCollect = false
				Click.CloseGump()
			else
				oldBottles = bottles
			end
   	     end
	end

end

beeApp = menu:form(200,100,"Bee Helpers")


potionB = beeApp:button("potion",50,10,100,20,"Apply Potions")
honeyB = beeApp:button("honey",50,35,100,20,"Collect Honey")
--waxB = beeApp:button("wax",50,60,100,20,"Collect Wax")

potionB:onclick(function() potion() end)
honeyB:onclick(function() collectHoney() end)
--waxB:onclick(function() errorMsg("Not Implemented") end)

beeApp:show()
Obj.Loop()
beeApp:free()
