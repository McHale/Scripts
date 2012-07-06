--==========================================================
-- Script Name: Keg Application
-- Author: McHale
-- Version: 1.0
-- OpenEUO version tested with: 0.91
-- Purpose: Makes and Fills Kegs 
--==========================================================

dofile("../Lib/craftlib.lua")
dofile("../Lib/menulib.lua")
dofile("../Lib/itemlib.lua")
dofile("../Lib/storagelib.lua")
dofile("../Lig/config.lua")

function makeKeg()
	local next = next
	--check boards present
	local boards = item:scan():cont(UO.BackpackID):tp(7127)
	if next(boards) == nil then 
		errorMsg("You don't have any boards")
		return
	end
	--check boards amount
	boards:property()
	local board = boards:pop()
	s,e,amt = string.find(board.name, "(%d+) Board")
	if tonumber(amt) < 23 then
		errorMsg("You don't have enough natural boards")
                return
	end
	--check ingots present
	local ingots = item:scan():cont(UO.BackpackID):tp(7154)
	if next(ingots) == nil then 
		errorMsg("You don't have any ingots")
		return
	end
	--check ingots amount
	ingots:property()
	local ingot = ingots:pop()
	s,e,amt = string.find(ingot.name,"(%d+) Ingots")
	if tonumber(amt) < 9 then
		errorMsg("You don't have enough iron ingots")
		return
	end
	--check saw present
	local saws = item:scan():cont(UO.BackpackID):tp(4148)
	if next(saws) == nil then
		errorMsg("You don't have a saw")
		return
	end	
	saws:property()	
	--check saw amount
	local saw_amount = 0
	for i=1,#saws do
		local saw = saws:pop(i)
		s,e,use = string.find(saw.stats,"Uses Remaining: (%d+)")
                saw_amount = saw_amount+tonumber(use)
	end
	if saw_amount < 6 then
		errorMsg("You don't have enough saw uses")
		return
	end	
	--check tink kit present
	local kits = item:scan():cont(UO.BackpackID):tp(7864)
	if next(kits) == nil then
		errorMsg("You don't have a tink kit")
		return
	end
	kits:property()
	--check tink kit amount
	local kit_amount = 0
	for i=1,#kits do
		local kit = kits:pop(i)
		s,e,use = string.find(kit.stats,"Uses Remaining: (%d+)")
		kit_amount = kit_amount+tonumber(use)
	end
	if kit_amount < 3 then
		errorMsg("You don't have enough tink kit uses")
		return
	end	
	--check bottles present
	local bottles = item:scan():cont(UO.BackpackID):tp(3854)
	if next(bottles) == nil then 
		errorMsg("You don't have any bottles")
		return
	end
	--check bottles amount
	bottles:property()
	local bottle = bottles:pop()
	s,e,amt = string.find(bottle.name,"(%d+) Empty Bottle")
	if amt == nil then
		errorMsg("You don't have enough empty bottles")
		return
	end
	if tonumber(amt) < 10 then
		errorMsg("You don't have enough empty bottles")
		return
	end
	
		
	Craft.Make("carpenter",1,3,1,1)
	wait(100)
	Craft.Make("carpenter",1,3,1,1)
	wait(100)
	Craft.Make("carpenter",1,3,1,1)
	wait(100)	
	Craft.Make("carpenter",1,4,1,1)
	wait(100)
	Craft.Make("carpenter",1,4,1,1)
	wait(100)
	Craft.Make("tinker",3,3,1,1)
	wait(100)
	Craft.Make("tinker",3,6,1,1)
	wait(100)
	Craft.Make("carpenter",3,20,1,1)
	wait(100)	
	Craft.Make("tinker",7,8,1,1)
end	


function greaterCure()
	container = item:scan():ground(1):property():name("Cure Potion Kegs")
	if next(container) == nil then 
		errorMsg("Not Near Your Cure Keg Storage")
		return
	end
	container = container:pop()
	local kegs = item:scan():cont(container.id):property():name("An Empty Potion Keg")
	if next(kegs) == nil then
		errorMsg("You do not have empty kegs for cure in storage")
		return
	end
	for i=1,#kegs do
		--write code to get regs
		local keg = kegs:pop(i)
		Craft.Make("alchemist",7,3,0,1)
		wait(200)
		local potions = item:scan():cont(UO.BackpackID):tp(3847)
		if next(potions) == nil then
			errorMsg("Failed to make cure potion")
		end
		keg:drop(UO.BackpackID)
		potions:pop():drop(keg.id)
		wait(150)
		Craft.Make("alchemist",7,3,0,99)
		wait(500)
		keg:drop(container.id)
	end
end

function greaterAgility()
	container = item:scan():ground(1):property():name("Agility Potion Kegs")
	if next(container) == nil then 
		errorMsg("Not Near Your Agility Keg Storage")
		return
	end
	agi_container = container:pop()
	local kegs = item:scan():cont(container.id):property():name("An Empty Potion Keg")
	if next(kegs) == nil then
		errorMsg("You do not have empty kegs for agi in storage")
		return
	end
	for i=1,#kegs do
		--write code to get regs
		local keg = kegs:pop(i)
		Craft.Make("alchemist",2,2,0,1)
		wait(200)
		local potions = item:scan():cont(UO.BackpackID):tp(3848)
		if next(potions) == nil then
			errorMsg("Failed to make agility potion")
		end
		keg:drop(UO.BackpackID)
		potions:pop():drop(keg.id)
		wait(150)
		Craft.Make("alchemist",2,2,0,99)
		wait(500)
		keg:drop(container.id)
	end
end

function greaterPoison()
	container = item:scan():ground(1):property():name("Poison Potion Kegs")
	if next(container) == nil then 
		errorMsg("Not Near Your poison Keg Storage")
		return
	end
	container = container:pop()
	local kegs = item:scan():cont(container.id):property():name("An Empty Potion Keg")
	if next(kegs) == nil then
		errorMsg("You do not have empty kegs for poison in storage")
		return
	end
	for i=1,#kegs do
		--write code to get regs
		local keg = kegs:pop(i)
		Craft.Make("alchemist",6,3,0,1)
		wait(200)
		local potions = item:scan():cont(UO.BackpackID):tp(3850)
		if next(potions) == nil then
			errorMsg("Failed to make poison potion")
		end
		keg:drop(UO.BackpackID)
		potions:pop():drop(keg.id)
		wait(150)
		Craft.Make("alchemist",6,3,0,99)
		wait(500)
		keg:drop(container.id)
	end
end

function greaterHeal()
	container = item:scan():ground(1):property():name("Heal Potion Kegs")
	if next(container) == nil then 
		errorMsg("Not Near Your heal Keg Storage")
		return
	end
	container = container:pop()
	local kegs = item:scan():cont(container.id):property():name("An Empty Potion Keg")
	if next(kegs) == nil then
		errorMsg("You do not have empty kegs for heal in storage")
		return
	end
	for i=1,#kegs do
		--write code to get regs
		local keg = kegs:pop(i)
		Craft.Make("alchemist",4,3,0,1)
		wait(200)
		local potions = item:scan():cont(UO.BackpackID):tp(3852)
		if next(potions) == nil then
			errorMsg("Failed to make heal potion")
		end
		keg:drop(UO.BackpackID)
		potions:pop():drop(keg.id)
		wait(150)
		Craft.Make("alchemist",4,3,0,99)
		wait(500)
		keg:drop(container.id)
	end
end

kegApp = menu:form(125,200,"")

cureB = kegApp:button("cure",10,10,100,20,"Greater Cure") 
poisonB = kegApp:button("poison",10,35,100,20,"Greater Poison") 
agilityB = kegApp:button("agility",10,60,100,20,"Greater Agility") 
healB = kegApp:button("heal",10,85,100,20,"Greater Heal")
finishB = kegApp:button("finish",10,110,100,20,"Finish Keg")  
makeB = kegApp:button("make",10,135,100,20,"Make Keg")

cureB:onclick(function() greaterCure() end)
poisonB:onclick(function() greaterPoison() end)
agilityB:onclick(function() greaterAgility() end)
healB:onclick(function() greaterHeal() end)
finishB:onclick(function() errorMsg("Needs to be implemented") end)
makeB:onclick(function() makeKeg() end)

kegApp:show()
Obj.Loop()
kegApp:free()
