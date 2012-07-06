dofile("../Lib/menulib.lua")
dofile("../Lib/bodlib.lua")
dofile("../Lib/craftlib.lua")
dofile("../Lib/itemlib.lua")
dofile("../Lib/basiclib.lua")
dofile("../Lib/functions.lua")

-----------------LOCAL VARIABLES---------------
local myBod = false

------------------------------------------------

---Does a bod
function doBod()

	myBod = bod:scanBod()
	if not myBod then 
		errorMsg("You have no bods")
   		return false
	end

	if myBod.size ~= "Small Bod" then
		errorMsg("This is not a small bod.")
   		return false
	end
        if myBod:Complete() then
	   errorMsg("This Bod was alread completed")
	   return false
         end

	local resource_index = 0
		for k,v in pairs(Resource[myBod.bod_type]) do 
    		if k == myBod.resource then
       			local myVal = v
       			for k,v in pairs(Resource[myBod.bod_type]) do
           			if k ~= myBod.resource and myVal > v then
              				resource_index = resource_index + 1
           			end
       			end
    		end
	end
	resource_index = resource_index + 1   

	local index = myBod:craftIndex()
	local category = myBod:craftCategory()

	if index == nil or category == nil then
   		errorMsg("Error setting item index for crafting gump")
	   	return false
	end         

	local profession = myBod:getProfession()

	if myBod.caliber == "Exceptional" then
   		Craft.MakeExc(profession,category,index,resource_index,myBod.base)
	else
    		Craft.Make(profession,category,index,resource_index,myBod.base)
	end

	local toAdd = item:scan():cont(UO.BackpackID):tp(Craft.LastItemType)
	if next(toAdd) == nil then
   		errorMsg("Failed to add items/Missing Materials")
	   	return false
	end


	UO.LObjectID = myBod.id
	UO.Macro(17,0)
	wait(750)
	Click.Gump(105,200)
	wait(1000)

	for i = 1, #toAdd do
    		toAdd:pop(i):target()
    		wait(1500)
	end
	Click.CloseGump()
	return myBod
end

------------------------_________GUI CODE_________---------------------

bodApp = menu:form(200,150,"Bod Filler")

fillB = bodApp:button("fill",10,10,175,20,"Fill Bod") 
rewardB = bodApp:button("reward",10,35,175,20,"Bod Reward")
referenceB = bodApp:button("reference",10,60,175,20,"Cross-Reference Bod")
cycleCB = bodApp:checkbox("cycle",30,95,125,20,"Cycle With Bod Books")

rewardB:onclick(function() 
             local newBod = bod:scanBod()
             if newBod then newBod:ExMsgAll() end
             end)

referenceB:onclick(function()
               local newBod = bod:scanBod()
               if newBod then newBod:ExCrossRef() end
               end)

fillB:onclick(function() 
	while cycleCB.ctrl.Checked do
		if not init then
			initBodBooks()
		end
		getBod()
		if doBod() then
		   storeBod()
                else
                    cycleCB.ctrl.Checked = false
                end
	end
	if not cycleCB.ctrl.Checked then
		doBod()
	end
	
end)



bodApp:show()
Obj.Loop()
bodApp:free()
