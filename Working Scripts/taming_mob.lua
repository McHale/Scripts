dofile("../Lib/bodlib.lua")
dofile("../Lib/basiclib.lua")

taming_books = item:scan():cont(UO.BackpackID):tp(8793):property():name("Taming Bulk Order Book")
local next = next
if next(taming_books) == nil then
	UO.ExMsg(UO.CharID,3,33,"There are no Taming BOD books in your main pack.")
end
for i=1,#taming_books do
	local book = taming_books:pop(i)
	standStr,e = string.find(book.stats,"Book Name: Stand Alone")
	if standStr ~= nil then
		standalone = book
	end
	defStr,e = string.find(book.stats,"Book Name: Default")
	if defStr ~= nil then
		default = book
	end
end

function cleanUpBods()
	bods = bod:scanAllTaming()
	bods = addItemMetatable(bods)
	for i = 1, #bods do
		toStore = bods:pop(i)
		if toStore.complete then 
			if toStore.standAlone then
		        	UO.Drag(toStore.id,toStore.stack)
    		         	UO.DropC(standalone.id)
				wait(500)
                                Click.CloseGump()
			else
				UO.Drag(toStore.id,toStore.stack)
				UO.DropC(default.id)
				wait(500)
				Click.CloseGump()
			end
		end
	end
end
		
function tame_mob()
cleanUpBods()
taming_bods = bod:scanAllTaming()
taming_bods = addItemMetatable(taming_bods)

animals = item:scan():ground(3):property():rep({3,4})

for i=1,#animals do
	notTamed = true
        local animal = animals:pop(i)
        for i=1,#taming_bods do
            local taming_bod = taming_bods:pop(i)
	    if not taming_bod.complete then
            	local toTame = taming_bod.items[1]
            	s,e,animalName = string.find(animal.name, "%a+%s*(%a+%s*%a+)")
             print(animalName)	
              if animalName == toTame  and notTamed then 
            	 UO.LObjectID = 1121516989
               	UO.Macro(17,0)
               wait(250)
               UO.LTargetID = animal.id
               UO.LTargetKind = 1
               UO.Macro(22,0)
               wait(250)
               UO.LTargetID = UO.CharID
               UO.LTargetKind = 1
               UO.Macro(22,0)
               wait(3000)
               UO.LTargetID = animal.id
               UO.LTargetKind = 1
               UO.Macro(13,35)
               wait(750)
               UO.Macro(22,0)
               wait(13000)
               taming_bod:use():waitContSize(510,275)
               Click.Gump(135,205)
               wait(750)
               UO.LTargetID = animal.id
               UO.LTargetKind = 1
               UO.Macro(22,0)
               wait(750)
               Click.CloseGump()
	       notTamed = false
            end
	   end
        end
end
end

while true do
	tame_mob()
	wait(7500)
end
	