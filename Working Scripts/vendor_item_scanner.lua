dofile("../Lib/itemlib.lua")
dofile("../Lib/basiclib.lua")
dofile("../Lib/journallib.lua")

------------------------VARS-------------------
allItems = false
itemToFind = "Elixir"
------------tile radius of vendors-------------
------For best results set to 0 and stand on top
------Scanning more than one takes forever :]
------Of the vendor you are scanning.
radius = 0

---attribute is {Weapon Hits}
---statsString is bow.stats
---toFind is (for example) Hit Chance Increase
---propKey is shorthand for prop
---toReturn is attrString with old or no slimProps attatched.
function slimProp(attribute, stats, toFind, toReturn, propKey)
	local val = ""
	patternStr = string.format("%s %s", toFind, "(%d+)")
	s,e,val = string.find(stats,patternStr)
	if val ~= nil then
	   	if toReturn == attribute then
			return toReturn .. string.format("%s %d",propKey, val)
	   	else
			return toReturn .. string.format(" : %s %d",propKey,val)
      		end
	end
	return toReturn
end

function findSkills(stats)
	for skill,val in stats:gmatch"(%a+%s?%a+)%s?([+]+%d+)" do
		if skill ~= nil then
			print(string.format("%s %s",skill,val))
		end
	end
end		
	

function slimSignProp(attribute, stats, toFind, toReturn, propKey)
	local val = ""
	patternStr = string.format("%s %s", toFind, "(.?%d)")
	s,e,val = string.find(stats,patternStr)
	if val ~= nil then
	   	if toReturn == attribute then
			return toReturn .. string.format("%s %d",propKey, val)
	   	else
			return toReturn .. string.format(" : %s %d",propKey,val)
      		end
	end
	return toReturn
end


function wrangleProps(stats)
	 ---------Can Be Changed to users preference-----
	 local meleeAttr = "{Melee Attributes} "
	 local magicAttr = "{Magic Attributes} "
	 local resistAttr = "{Resistances} "
	 local hitAttr = "{Weapon Hits} "
	 local miscAttr = "{Misc. Attributes} "
         local charAttr = "{Character Stats} "
	 local randomAttr = ""
	
	 -----------Don't change------------
	 local meleeString = meleeAttr
         local magicString = magicAttr
         local resistString = resistAttr 
	 local hitString =  hitAttr
	 local miscString = miscAttr
	 local charString = charAttr
	 local randomString = randomAttr
	
          ---------Melee Attributes
	 meleeString = slimProp(meleeAttr,stats, "Damage Increase",meleeString,"DI")
	 meleeString = slimProp(meleeAttr,stats, "Defense Chance Increase",meleeString,"DCI")
	 meleeString = slimProp(meleeAttr,stats, "Hit Chance Increase",meleeString,"HCI")
	 meleeString = slimProp(meleeAttr,stats, "Swing Speed Increase",meleeString,"SSI")

	--------MAGIC ATTRIBUTES
	 local s,e,fc = string.find(stats,"Faster Casting (.?%d)")
         if fc ~= nil then
		if magicString == magicAttr then
			magicString = magicString .. string.format("FC %s",fc)
		else 
			magicString = magicString .. string.format(" : FC %s",fc)
		end
	 end
	 local s,e,fcr = string.find(stats,"Faster Cast Recovery (.?%d)")
	 if fcr ~= nil then
		if magicString == magicAttr then
			magicString = magicString .. string.format("FCR %s",fcr)
		else
			magicString = magicString .. string.format(" : FCR %s",fcr)
		end
	 end
	 
	 local s,e = string.find(stats, "Spell Channeling")
	 if s ~= nil then
		if magicString == magicAttr then
			magicString = magicString .. "SC"
		else
			magicString = magicString .. " : SC"
		end
	  end
	  
	magicString = slimProp(magicAttr,stats, "Spell Damage Increase",magicString,"SDI")
	magciString = slimProp(magiicAttr,stats, "Lower Reagent Cost",magicString,"LRC")
	magicString = slimProp(magicAttr,stats, "Lower Mana Cost",magicString,"LMC")
	magicString = slimProp(magicAttr,stats, "Enhance Potions",magicString,"Enhance Pots")
  
	  ----------------Resistances
	 resistString = slimProp(resistAttr,stats, "Physical Resist",resistString,"Physical")
	 resistString = slimProp(resistAttr,stats, "Fire Resist",resistString,"Fire")
	 resistString = slimProp(resistAttr,stats, "Cold Resist",resistString,"Cold")
	 resistString = slimProp(resistAttr,stats, "Poison Resist",resistString,"Poison")
	 resistString = slimProp(resistAttr,stats, "Energy Resist",resistString,"Energy")
	 
	---------Weapon Hits
	hitString = slimProp(hitAttr,stats, "Hit Life Leech",hitString, "HLL")
	hitString = slimProp(hitAttr,stats, "Hit Stamina Leech",hitString, "HSL")
	hitString = slimProp(hitAttr,stats, "Hit Mana Leech",hitString, "HML")
	hitString = slimProp(hitAttr,stats, "Hit Lower Attack",hitString, "HLA")
	hitString = slimProp(hitAttr,stats, "Hit Lower Defense",hitString, "HLD")
	hitString = slimProp(hitAttr,stats, "Hit Magic Arrow",hitString, "Magic Arrow")
	hitString = slimProp(hitAttr,stats, "Hit Harm",hitString, "Harm")
	hitString = slimProp(hitAttr,stats, "Hit Fireball",hitString, "Fireball")
	hitString = slimProp(hitAttr,stats, "Hit Lightning",hitString, "Lightning")
	hitString = slimProp(hitAttr,stats, "Hit Dispel",hitString, "Dispel")
	hitString = slimProp(hitAttr,stats, "Hit Cold Area",hitString, "Cold AoE")
	hitString = slimProp(hitAttr,stats, "Hit Fire Area",hitString, "Fire AoE")
	hitString = slimProp(hitAttr,stats, "Hit Poison Area",hitString, "Poison AoE")
	hitString = slimProp(hitAttr,stats, "Hit Energy Area",hitString, "Energy AoE")
	hitString = slimProp(hitAttr,stats, "Hit Physical Area",hitString, "Physical AoE")
	
	----------Character Stats
	charString = slimProp(charAttr,stats,"Mana Regeneration",charString, "Mana Regen")
	charString = slimProp(charAttr,stats,"Hit Point Regeneration",charString, "HP Regen")
	charString = slimProp(charAttr,stats,"Stamina Regeneration",charString, "Stam Regen")
	charString = slimProp(charAttr,stats,"Strength Bonus",charString, "Str")
	charString = slimProp(charAttr,stats,"Dexterity Bonus",charString, "Dex")
	charString = slimProp(charAttr,stats,"Int Bonus",charString, "Int")
	charString = slimProp(charAttr,stats,"Hit Point Increase",charString, "+HP")
	charString = slimProp(charAttr,stats,"Stamina Increase",charString, "+Stam")
	charString = slimProp(charAttr,stats,"Mana Increase",charString, "+Mana")
--	charString = slimProp(charAttr,stats,"Lower Requirements",charString, "Lower Requirements")

-----------------------MISC ATTRIBUTES---------------
	miscString = slimProp(miscAttr,stats, "Luck", miscString,"Luck")
	miscString = slimProp(miscAttr,stats, "Self Repair", miscString, "SR")

----------------------Random Attributes----------
	local s = string.find(stats,"Exceptional")
	if s ~= nil then
		if randomString == randomAttr then
			randomString = randomString .. "Exceptional"
		else 
			randomString = randomString .. " : Exceptional"
		end
	end
	local s,e,dura = string.find(stats,"Durability (%d+)")
	if dura ~= nil then
		if randomString == randomAttr then
			randomString = randomString .. string.format("Durability %s",dura)
		else
			randomString = randomString .. string.format(" : Durability %s",dura)
		end
	end
	 local s,e,slayer = string.find(stats,"(%a+) Slayer")
	 if slayer ~= nil then
		if randomString == randomAttr then
			randomString = randomString .. string.format("%s Slayer",slayer)
		else
			randomString = randomString .. string.format(" : %s Slayer",slayer)
		end
	 end
	s,e = string.find(stats,"Night Sight")
	if s ~= nil then
		if randomString == randomAttr then
			randomString = randomString .. "Night Sight"
		else
			randomString = randomString .. " : Night Sight"
		end
	end
----------------------ATTRIBUTES-------------------------
         local s,e,price =string.find(stats,"Price: (%d+)")
         if price ~= nil then
                print(string.format("Price: %s",price)) 
         end
	
	findSkills(stats)
	if randomString ~= randomAttr then print(randomString) end
	if charString ~= charAttr then print(charString) end
 	if meleeString ~= meleeAttr then print(meleeString) end
	if magicString ~= magicAttr then print(magicString) end
	if resistString ~= resistAttr then print(resistString) end
	if hitString ~= hitAttr then print(hitString) end
	if miscString ~= miscAttr then print(miscString) end
end
	  

---------For Other Players Vendors & recursing on inner bags------
function displayItems(container)
         container:use()
         wait(250)
         local items = item:scan():cont(UO.ContID):property()
         wait(500)
         local recursiveContainers = {}
         for i=1, #items do
             local myitem = items:pop(i)
             startIndex, endIndex = string.find(myitem.stats, "Price: Not For Sale.")
             if startIndex == 1 and endIndex == 20 then            
                startIndex, endIndex, numItems = string.find(myitem.stats,"(%d+) Items")
                if numItems ~= 0 and myitem.type ~= 9002 then 
                      table.insert(recursiveContainers, myitem)
                end
             else
		if allItems then
	                print("~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~")
			print(myitem.name)
			wrangleProps(myitem.stats)
		else
                 	s,e = myitem.name:find(itemToFind)
                 	if s ~= nil then
                    		print("~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~")
                    		wrangleProps(myitem.stats)
                    		print("")
                 	end--not the item you want end
		end--all items 
	     end--price not for sale if
         end--for loop
                                        
         for i=1, #recursiveContainers do
             displayItems(recursiveContainers[i])
         end
end

-------For Your vendor(as double clicking opens the options gump)
function displayMyItems(container)
         container:use()
         wait(250)
   	 if UO.ContSizeX == 547 and UO.ContSizeY == 290 then
	 	Click.Gump(395,30)
	 end
         local items = item:scan():cont(UO.ContID):property()
         wait(500)
         local recursiveContainers = {}
         for i=1, #items do
             local myitem = items:pop(i)
             startIndex, endIndex = string.find(myitem.stats, "Price: Not For Sale.")
             if startIndex == 1 and endIndex == 20 then            
                startIndex, endIndex, numItems = string.find(myitem.stats,"(%d+) Items")
                if numItems ~= 0 and myitem.type ~= 9002 then 
                      table.insert(recursiveContainers, myitem)
                end
             else
 		if allItems then
	                print("~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~")
			print(myitem.name)
			wrangleProps(myitem.stats)
		else
                 	s,e = myitem.name:find(itemToFind)
                 	if s ~= nil then
                    		print("~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~")
                    		wrangleProps(myitem.stats)
                    		print("")
                 	end
		end
             end
         end
                                        
         for i=1, #recursiveContainers do
             displayItems(recursiveContainers[i])
         end
end

---------------------kinda pointless for one vendor stuff---------------
vendors = item:scan():ground(radius):tp({400,401}):property()
for i=1,#vendors do
    local vendor = vendors:pop(i)
    vendor:use()
    wait(2500)
    if UO.ContSizeX == 547 and UO.ContSizeY == 290 then
       print("~~~~~~~~~~~~~~~~~~~~~~~~~~")
       print(string.format("******  %s  *****", vendor.name))
       print(vendor.stats)
       print("~~~~~~~~~~~~~~~~~~~~~~~~~~")
       displayMyItems(vendor)
    elseif UO.ContSizeX == 230 and UO.ContSizeY == 204 then
       print("~~~~~~~~~~~~~~~~~~~~~~~~~~")
       print(string.format("******  %s  *****", vendor.name))
       print(vendor.stats)
       print("~~~~~~~~~~~~~~~~~~~~~~~~~~")
       displayItems(vendor)
    else
        Click.CloseGump()
        print("~~~~~~~~~~~~~~~~~~~~~~~~~~")
    end
    wait(2000)
end