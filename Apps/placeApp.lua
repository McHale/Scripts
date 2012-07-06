--==========================================================
-- Script Name: House Decorator Helper
-- Author: McHale
-- Version: 1.0
-- OpenEUO version tested with: 0.91
-- Purpose: Helps place items into hard to reach places
--==========================================================
  
  -- House Decorator Helper
    -- by McHale of Excelsior's Orphan Mafia Guild
    -- v1.0 Completed 10/22/11 
    -- openEUO

dofile("../Lib/menulib.lua")
dofile("../Lib/itemlib.lua")
dofile("../Lig/config.lua")

-------------------------------START HELPER FUNCTIONS--------------------------

--loads a listbox with items (list of strings)
function loadListBox(listbox, items)
	listbox.ctrl.Clear()
	for i = 1, #items do
		listbox.ctrl.Items.Add(items[i].name)
        end
end

--Returns Select index from the listbox, which starts at 0
--instead of the usual 1, and gets the corresponding index in
--the items objects list returned by Jack Penny's itemlib
function GetSelectedIndex(listbox, items) 
        if next(items) == nil then
           return -1
        end
	for i =0, #items-1 do
		local bool = listbox.ctrl.GetSelected(i)
                if bool then return i end
	end
	return -1
end

--function to place the selected item
function place(listbox, items)
          if next(items) == nil then
             errorMsg("No Items in container.")
             return
          end
	  local index = GetSelectedIndex(listbox, items)
	  if index > -1 then    
	    myItem = items:pop(index+1)
          else
		errorMsg("No item is selected.")
		return
 	  end
	  UO.ExMsg(UO.CharID,3,16,"Please select a tile to place your item.")
          UO.Macro(13,14)
          wait(750)
          while UO.TargCurs do
	        wait(100)
          end
          local x = UO.LTargetX
          local y = UO.LTargetY
          wait(500)
	  UO.Drag(myItem.id)
	  UO.DropG(x,y)
	  if autoCB.ctrl.Checked then
             wait(500)
	     UO.Macro(1,0,"I wish to secure this")
	     wait(500)
	     myItem:target()
          end
          listbox.ctrl.ClearSelection()
end

-------------------------------END HELPER FUNCTIONS--------------------------

placeApp = menu:form(200,200,"House Deco")

itemsLB = placeApp:listbox("items",20,10,150,120)
itemsLB.ctrl.MultiSelect = false

--Scans Main Backpack for a container called "Place"
local my_cont = item:scan():cont(UO.BackpackID):property():name("Place")
if next(my_cont) == nil then 
   errorMsg("You must have a container renamed 'Place' in your Main Backpack.")
   UO.ExMsg(UO.CharID,3,50,"Stopping Script...")
   stop()
end

--popping container item from the list 
local my_cont = my_cont:pop()

--rescanning for list of items in place container
local itemsToPlace = item:scan():cont(my_cont.id):property()

placeB = placeApp:button("place",10,140,75,20,"Place Item") 
autoCB = placeApp:checkbox("auto",90,140,80,20,"Auto Secure")
updateT = placeApp:timer("update",5000,true)
updateT:ontimer(function()
        itemsToPlace = item:scan():cont(my_cont.id):property()
	loadListBox(itemsLB, itemsToPlace)
end)

placeB:onclick(function() 
	place(itemsLB,itemsToPlace)
end)

loadListBox(itemsLB, itemsToPlace)

placeApp:show()
Obj.Loop()
placeApp:free()
