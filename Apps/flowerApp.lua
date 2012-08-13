--==========================================================
-- Script Name: Flower Application
-- Author: McHale
-- Version: 1.0
-- OpenEUO version tested with: 0.91
-- Purpose: Automates many flower tending functions
--==========================================================

dofile("../Lib/itemlib.lua")
dofile("../Lib/basiclib.lua")
dofile("../Lib/menulib.lua")
dofile("../Lib/journallib.lua")
dofile("../Lib/config.lua")

local flower_types = {3203,3206,3208,3220,3211,3237,3239,3223,3231,3238,3328,3377,3332,3241,3372,3366,3367}

function crossPollinate()
	UO.ExMsg(UO.CharID,3,11,"You will cross-pollinate same type plants of the stack you are standing on.")
	wait(500)
	UO.ExMsg(UO.CharID,3,20,"This is meant to pollinate same bright colors, or plains for mutations.")
	local flowers = item:scan():ground(0):z_axis(0,20):tp(flower_types):property()
	local next = next
	if next(flowers) == nil then	
		UO.ExMsg(UO.CharID,3,18,"You are not near any flowers.")
		return
	end
	local donor = flowers:pop()
        donor:use():waitContSize(263,231):wait(1000)
        Click.Gump(75, 75)
	for i=1,#flowers do
	    local flower =flowers:pop(i)
	    wait(250)
	    if flower.tp == donor.tp and flower.id ~= donor.id then
		Click.Gump(75,170)
		wait(500)
		flower:target()
		wait(500)
   	     end
	     if i == #flowers then
                 Click.CloseGump()
                 wait(500)
	   	 flower:use():waitContSize(263,231):wait(1000)
		 Click.Gump(75,75)
		 wait(500)
		 Click.Gump(75,170)
		 wait(500)
		 donor:target()
		 wait(500)
	     end
	end
	UO.ExMsg(UO.CharID,3,15,"Finished Pollinating")
	Click.CloseGump()
end


function checkPitcher()
	local next = next
	local watertroughs = item:scan():ground(2):tp({2881,2882,2883,2884})
        if next(watertroughs) ~= nil then
		watertrough = watertroughs:pop()
	else 
		UO.ExMsg(UO.CharID,3,18, "You must be next to a water trough.")
		return
	end
	local pitchers = item:scan():cont(UO.BackpackID):tp({8093,4086}):property()
	if next(pitchers) == nil then
		UO.ExMsg(UO.CharID,3,18, "You need a glass pitcher or water pitcher in your main pack.")
		return
	end
	pitcher = pitchers:pop()
	if pitcher.stats == "It's Empty." then
		pitcher:use():waitTarget():target(watertrough.id)
		wait(500)
	end

	return pitcher
end

--Won't Stop - fix later
function fillSprinkler()
	local sprinklers = item:scan():ground(3):tp(3706):property():name("Water Sprinkler")
	if next(sprinklers) == nil then 
		UO.ExMsg(UO.CharID,3,18,"You need to be within three tiles of a water sprinkler")
		return
	end
	local sprinkler = sprinklers:property():pop()
	local s,e,num = string.find(sprinkler.stats,"Water Left: (%d+)")
	if num == 100 then
		UO.ExMsg(UO.CharID,3,15,"Water Sprinkler is full.")
	end
	notDone = true
	UO.ExMsg(UO.CharID,3,11,"Filling Water Sprinkler...")
	while notDone do
		pitcher = checkPitcher()
		if not pitcher then
		   return
                end
		pitcher:use():target(sprinkler.id)
		wait(750)
		local name, info = UO.Property(sprinkler.id)
		s,e,num = string.find(info,"Water Left: (%d+)")
		if tonumber(num) == 100 then 
			notDone = false 
		end
	end
	UO.ExMsg(UO.CharID,3,15,"Water Sprinkler is full.")
end

function softenDirt()
	local myBowls = item:scan():cont(UO.BackpackID):tp(5634):property():name("A Bowl Of Hard Dirt")
	if next(myBowls) == nil then
		UO.ExMsg(UO.CharID,3,18, "You need to have bowls filled with hard dirt in your main pack")
		return
	end
	for i=1, #myBowls do
		bowl = myBowls[i]
		notSoftened = true
		while notSoftened do
			if bowl.name == "A Bowl Of Hard Dirt" then
				pitcher = checkPitcher()
				if pitcher == nil then return end
                                pitcher:use():waitTarget():target(bowl.id)
			end
			wait(1250)
			name, stats = UO.Property(bowl.id)
			if name == "A Bowl Of Soft Dirt" then
				UO.ExMsg(UO.CharID,3,11, string.format("Softened Dirt %i/%i", i, #myBowls))
				notSoftened = false
			end   
		end
	end 
end

function storeSeeds()
	local next = next
	local seeds = item:scan():cont(UO.BackpackID):tp(3535)
	if next(seeds) == nil then
		UO.ExMsg(UO.CharID,3,18,"There are no seeds to store.")
		return
	end
	local seed_box = item:scan():ground(3):tp(3649):property():name("Seed Box")
	if next(seed_box) == nil then
   		UO.ExMsg(UO.CharID,3,18,"You need to be near a seed box")
   		return
	end
	seed_box = seed_box:pop().id
	UO.ExMsg(UO.CharID,3,25,"Storing Seeds...")
	for i = 1, #seeds do
   		seed = seeds:pop(i):drop(seed_box)
   		wait(500)
	end
	UO.ExMsg(UO.CharID,3,20,"Storing Seeds Completed.")
end

function fillBowls(x,y)
	local bowls = item:scan():cont(UO.BackpackID):tp(5629)
	local next = next
	if next(bowls) == nil then 
		UO.ExMsg(UO.CharID,3,18,"There are no bowls to fill with dirt.")
		return
	end
	if x == nil then
           UO.ExMsg(UO.CharID,3,16,"Please select a farm dirt tile or fertile dirt.")
           UO.Macro(13,14)
           wait(750)
           while UO.TargCurs do
                 wait(1)
           end
           x = UO.CursorX
           y = UO.CursorY
           wait(500)
        end
	local originalCount = #bowls
	UO.ExMsg(UO.CharID,3,11,"Attempting to Fill Empty Bowls with Dirt.")
	for i=1, #bowls do
	    bowls:pop(i):use():waitTarget()
	    wait(250)
	    UO.Click(x,y,true,true,true,false)
	    wait(1000)
	    if i == 1 then
	    	local checkBowls = item:scan():cont(UO.BackpackID):tp(5629)
	        if #checkBowls == #bowls then
	           UO.ExMsg(UO.CharID,3,18,"That isn't farm dirt spot or not enough fertile dirt. Stopping...")
	           return
                end
            end
        end
	bowls = item:scan():cont(UO.BackpackID):tp(5629)
	local next = next
	if next(bowls) == nil then 
	        UO.ExMsg(UO.CharID,3,20,"Fill Bowls Completed.")
                return 
        else 
             fillBowls(x,y)
        end
	UO.ExMsg(UO.CharID,3,20,"Fill Bowls Completed.")
end

function pickUpPlants()
	local deco_plants = item:scan():z_axis(0,20):ground(2):tp(flower_types):property():name("A Decorative Plant")
	local next = next
	if next(deco_plants) == nil then
	   UO.ExMsg(UO.CharID,3,18,"No Deco Plants")
           return
	end
	UO.ExMsg(UO.CharID,3,20,"Picking Up Deco Plants")
	for i=1,#deco_plants do
	    deco_plants:pop(i):say("I wish to release this."):waitTarget():target(deco_plants[i].id):wait(250):drop(UO.BackpackID)
	end
end

function plant()
         local seeds = item:scan():cont(UO.BackpackID):tp(3535)
         if next(seeds) == nil then
	    UO.ExMsg(UO.CharID,3,18,"You have no seeds in your backpack")
	    return
          end
          local defaultSeed = seeds:pop()
          seeds = seeds:property():name(defaultSeed.name)
          UO.ExMsg(UO.CharID,3,11,defaultSeed.name)

          local bowls = item:scan():cont(UO.BackpackID):tp(5634):property():name("A Bowl Of Soft Dirt")
          if next(bowls) == nil then
	     UO.ExMsg(UO.CharID,3,18,"You have no bowls of soft dirt in your backpack")
             return
          end

          UO.ExMsg(UO.CharID,3,16,"Please select a place to secure your plant or plant stack")
          UO.Macro(13,14)
          wait(750)
          while UO.TargCurs do
	        wait(100)
          end
          local x = UO.LTargetX
          local y = UO.LTargetY
          wait(500)
          UO.ExMsg(UO.CharID,3,11,"Planting...")
          for i = 1, #seeds do
              if i > #bowls then
                 UO.ExMsg(UO.CharID,3,18,"Could not complete planting all seeds-short bowls")
                 return
              end
	      local seed = seeds:pop(i)
	      local bowl = bowls:pop(i)
	      seed:use():waitTarget():target(bowl.id):wait(750)
	      UO.Drag(bowl.id)
	      UO.DropG(x,y)
	      wait(500)
	      UO.Macro(1,0,"I wish to secure this")
	      wait(500)
	      bowl:target()
	      wait(500)
          end
          UO.ExMsg(UO.CharID,3,15,"Finished Planting.")
end

function openGumps()
	local flowers = item:scan():ground(2):z_axis(0,20):tp(flower_types)
	local next = next
	if next(flowers) == nil then	
		UO.ExMsg(UO.CharID,3,18,"You are not near any flowers.")
		return
	end
        local toEx = string.format("Opening %d plant gumps",#flowers)
        UO.ExMsg(UO.CharID,3,11,toEx)
        for i = 1, #flowers do
            local flower = flowers:pop(i)
            flower:use()
            wait(1000)
        end
        UO.ExMsg(UO.CharID,3,15,"Opening Gumps Completed")
end

function ifSeeds()
         local currSeeds = item:scan():cont(UO.BackpackID):tp(3535)
         --There were no seeds in your backpack or grabbing from the plant
         if next(currSeeds) == nil then
            return false
         end
         if #currSeeds > numSeeds then
            numSeeds = #currSeeds
            return true
         end
end
          
function getSeeds()
        UO.ExMsg(UO.CharID,3,11,"Attempting to collect seeds from all plants within a 3 tile radius...")
	wait(500)
	local numSeeds = item:scan():cont(UO.BackpackID):tp(3535)
	if next(numSeeds) == nil then
		numSeeds = 0
	else
		numSeeds = #numSeeds
	end
	local flowers = item:scan():z_axis(0,20):ground(3):tp(flower_types):property()
	if next(flowers) == nil then
		UO.ExMsg(UO.CharID,3,18,"You are not near any flowers")
		return
	end
	
	UO.ExMsg(UO.CharID,3,13,string.format("Checking %d Flowers For Seeds.",#flowers))
	for i=1,#flowers do
		local flower = flowers:pop(i)
		if flower.name ~= "A Decorative Plant" then
			flower:use():waitConSize(263,231):wait(1000)
			Click.Gump(75,75)
			wait(1000)
			local canCollect = true
			while canCollect do
				Click.Gump(220,175)
				wait(750)
				canCollect = ifSeeds()
				local my_bk = item:scan():cont(UO.BackpackID)
				if #my_bk == 125 then
					UO.ExMsg(UO.CharID,3,18,"Your backpack is full.")
					return
				end
			end
		end
	end
	Click.CloseGump()
end


--------------------------GUI----------------------------------
flowerApp = menu:form(130,270,"Flower Helpers")

sprinklerB = flowerApp:button("sprinkler",10,10,100,20,"Fill Water Sprinkler") 
seedsB = flowerApp:button("seeds",10,35,100,20,"Store Seeds") 
fillB = flowerApp:button("fill",10,60,100,20,"Fill Bowls")
softenB = flowerApp:button("soften",10,85,100,20,"Soften Dirt")
crossB = flowerApp:button("cross",10,110,100,20,"Cross Pollinate")
pickB = flowerApp:button("pickUP",10,135,100,20,"Pick Up Decoed")
plantB = flowerApp:button("plant",10,160,100,20,"Plant")
openB = flowerApp:button("open",10, 185, 100,20,"Open Gumps")
collectB = flowerApp:button("collectB",10, 210, 100, 20, "Collect Seeds")

sprinklerB:onclick(function() fillSprinkler() end)
seedsB:onclick(function() storeSeeds() end)
fillB:onclick(function() fillBowls() end)
softenB:onclick(function() softenDirt() end)
crossB:onclick(function() crossPollinate() end)
pickB:onclick(function() pickUpPlants() end)
plantB:onclick(function() plant() end)
openB:onclick(function() openGumps() end)
collectB:onclick(function() getSeeds() end)
flowerApp:show()
Obj.Loop()
flowerApp:free()