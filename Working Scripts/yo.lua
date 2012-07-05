dofile("menulib.lua")
dofile("bodlib.lua")
dofile("craftlib.lua")
dofile("itemlib.lua")
dofile("basiclib.lua")

-----------------GLOBAL VARIABLES---------------
local completedBook = ""
local todoBook = ""
local myBod = false
local init = false

------------------------------------------------
function initBodBooks() 
	
	local bod_books = item:scan():cont(UO.BackpackID):tp(8793):property():name("Bulk Order Book")

	if next(bod_books) == nil then
		UO.ExMsg(UO.CharID,3,33,"There are no BOD books in your main pack.")
		return false
	end

	for i = 1, #bod_books do
		local book = bod_books:pop(i)
		local s,e,name = string.find(book.stats,"Book Name: (%a+%s?%a+)")
		if name ~= nil then
			if name == "Todo" then
				todoBook = book
				local s,e,count = string.find(book.stats,"Deeds In Book: (%d+)")
				if count == 0 then
					UO.ExMsg(UO.CharID,3,33,"There are no deeds in your book of small bods")
					return false
				end
			elseif name == "Completed" then
				completedBook = book
			end
		end
	end

	if completedBook == "" or todoBook == "" then
		UO.ExMsg(UO.CharID,3,33,"You need a bod book called 'Completed' and a book called bod 'Todo' in your mainpack.")
		return false
	end
	return true
end

function carpentryCheck()
	if myBod.bod_type == 3 then
		if myBod.items[1] == "Tambourine" or myBod.items[1] == "Crate" then
			--create one item, try to put it in bod, if fail...
			--then create the other item == index+1
	end		
end

---Does a bod
function doBod()

	myBod = bod:scanBod()
	if not myBod then 
		UO.ExMsg(UO.CharID,3,33,"You have no bods")
   		return false
	end

	if myBod.size ~= "Small Bod" then
		UO.ExMsg(UO.CharID,3,33,"This is not a small bod.")
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
   		UO.ExMsg(UO.CharID,3,33,"Error setting item index for crafting gump")
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
   		UO.ExMsg(UO.CharID,3,33,"Failed to add items/Missing Materials")
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

---Drops a Bod from "Todo" Bod Book
function getBod()
	todoBook:use():waitContSize(615,454)
	Click.Gump(40,105)
	wait(1000)
	Click.CloseGump()
end

---Stores Completed Bod in "Completed" Bod Book
function storeBod()
	if myBod == nil then
		return
	end
	UO.Drag(myBod.id)
	wait(100)
	UO.DropC(completedBook.id)
	wait(1000)
	Click.CloseGump()
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
