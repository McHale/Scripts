dofile("../Lib/basiclib.lua")
dofile("../Lib/journallib.lua")
dofile("../Lib/menulib.lua")
dofile("../Lib/itemlib.lua")

local me = item:scan():ground(0):property():name(UO.CharName):pop()

function waitTarget()
while not UO.TargCurs do wait(150) end
end

function peacemaking()
    local capped = false
    while not capped do
    	local flutes = item:scan():cont(UO.BackpackID):tp(10245)
    	if next(flutes) == nil then
		UO.ExMsg(UO.CharID,3,33,"There are no bamboo flutes in your backpack.")
		return
    	end
    	flutes:pop():use()
	local nNorm,cap = UO.GetSkill("Peacemaking")
	if nNorm < 1200 then
		if cap == 1000 and nNorm == 1000 then
			capped = true
		end
		UO.Macro(13,9)
	    	waitTarget()
		me:target()
		wait(10500)
	else
		capped = true
	end
    end
end		

function bushido()
    local capped = false
    while not capped do
	local nNorm = UO.GetSkill("Bushido")
	if nNorm < 600 then
		UO.Macro(15,146)
	elseif nNorm < 750 then
		UO.Macro(15, 148)
	elseif nNorm < 975 then
		UO.Macro(15, 147)
	else
	    UO.SysMessage("97.5 to 120: Momentum Strike--Use on enemy to gain")
	    capped = true
	end
	wait(2500)
   end
end

function necromancy()
    local capped = false 
    while not capped do
	local nNorm,cap = UO.GetSkill("Necromancy")
	if nNorm < 540 then
		UO.Macro(15,109)
	elseif nNorm < 710 then
		UO.Macro(15,106)
	elseif nNorm < 810 then
		UO.Macro(15,115)
		waitTarget()
		me:target()
	elseif nNorm < 1100 then
		if cap == 1000 and nNorm == 1000 then
			UO.SysMessage("Necromancy is at 100")
			capped = true
		end
		UO.Macro(15,107)
	elseif nNorm < 1200 then
		UO.Macro(15,113)
	else
		UO.SysMessage("Necromancy is at 120")
		capped = true
	end
	wait(2500)
    end
end
	

----UNtested------------
function chivalry()
   local capped = false
   while not capped do
	local nNorm = UO.GetSkill("Chivalry")
	if nNorm < 400 then
		UO.Macro(1,0,"[cs consecrateweapon")
	elseif nNorm < 550 then
		UO.Macro(1,0,"[cs divinefury")
	elseif nNorm < 690 then
		UO.Macro(1,0,"[cs enemyofone")
	elseif nNorm < 880 then
		UO.Macro(1,0,"[cs holylight")
	elseif nNorm < 1150 then
		UO.Macro(1,0,"[cs noblesacrifice")
	else
	    capped = true
        end
	wait(4000)
   end
end


---------seems to break working on it----------
function ninjitsu()
  local capped = false
  while not capped do
	local nNorm = UO.GetSkill("Ninjitsu")
	if nNorm < 300 then
		myjournal = journal:new()
		ratForm()
		if myjournal:next() ~= nil then
			if myjournal:find("The spell fizzles.") ~= nil then	
                	print("IN journal block")
                        	ratForm()
               		else 
                                UO.Macro(15,247)
				wait(3000)
				    print("Got HerE")            
			end
		end
	elseif nNorm < 45 then
		UO.Macro(15,250)
	end
  end
end

function ratForm()
	UO.Macro(15,247)
        wait(2500)	
	WaitForGump(408,298)
	Click.Gump(220, 220)
	Click.Gump(40, 280)
	wait(1000)
end

function magery()
  local capped = false
  while not capped do
	local nNorm,cap = UO.GetSkill("Magery")
	if nNorm < 450 then
		UO.Macro(15,16)
		waitTarget()
		me:target()
	elseif nNorm < 600 then
		UO.Macro(15,24)
		waitTarget()
		me:target()
	elseif nNorm < 900 then
		UO.Macro(15,47)
		waitTarget()
		me:target()
	elseif nNorm < 1001 then
		if cap == 1000 and nNorm == 1000 then
			UO.SysMessage("Magery is at 100")
			capped = true
		end
		UO.Macro(15,52)
		waitTarget()
		me:target()
	elseif nNorm < 1200 then
		UO.Macro(15,56)
		waitTarget()
		me:target()
	else
		UO.SysMessage("Magery is at 120")
		capped = true
	end
	wait(2500)
    end
end

trainerApp = menu:form(200,300,"McHale's Trainer")

-- adds a button to the form at 0,0 sized 100x20 and with text "click me!" on it
ninjitsuB = trainerApp:button("ninjitsu",50,10,100,20,"Ninjitsu") 
bushidoB = trainerApp:button("bushido",50,35,100,20,"Bushido") 
necroB = trainerApp:button("necro",50,60,100,20,"Necromancy") 
mageB = trainerApp:button("mage",50,85,100,20,"Magery") 
chivB = trainerApp:button("chiv",50,110,100,20,"Chivalry") 
peaceB = trainerApp:button("peace",50,135,100,20,"Peacemaking") 
--runicB = trainerApp:button("runic",50,160,100,20,"Runic Tools") 
--stoneB = trainerApp:button("stone",50,185,100,20,"Stone") 

ninjitsuB:onclick(function() ninjitsu() end)
bushidoB:onclick(function() bushido() end)
necroB:onclick(function() necromancy() end)
mageB:onclick(function() magery() end)
chivB:onclick(function() chivalry() end)
peaceB:onclick(function() peacemaking() end)
--runicB:onclick(function() Storage.storeRunics() end)
--stoneB:onclick(function() Storage.storeStone() end)


trainerApp:show()
Obj.Loop()
trainerApp:free()