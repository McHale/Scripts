dofile("../Lib/menuLib.lua")
dofile("../Lib/basiclib.lua")
dofile("../Lib/itemlib.lua")

leftOffset = 135
rightOffset = 300

recallOffset = 145
gateOffset = 165
sacredOffset = 180

circleYOffset = 205
circleXOffset = {140,175,210,245,310,345,380,415}

position = 0
xOffset = 0
yOffset = 0
runebook = nil
books = nil
--runebook type 8901

--------------------------LIST BOX CODE---------------------------
--loads a listbox with items (list of strings)
function loadListBox(listbox,items)
	listbox.ctrl.Clear()
	if next(items) == nil then
		errorMsg("There are no runebooks in the selected container")
		return
	end
	for i = 1, #items do
		listbox.ctrl.Items.Add(getName(items[i]))
        end
end

--Returns Select index from the listbox, which starts at 0
--instead of the usual 1, and gets the corresponding index in
--the items objects list returned by Jack Penny's itemlib
function GetSelectedItem(listbox, items) 
        if next(items) == nil then
	   errorMsg("There are no items")
           return 
        end
	for i =0, #items-1 do
		local bool = listbox.ctrl.GetSelected(i)
                if bool then
			return items:pop(i+1)
		end
	end
	errorMsg("No item is selected.")
	return
end

function getRunebooks()
	UO.ExMsg(UO.CharID,3,50,"Please Target a container holding runebooks")
	UO.Macro(13,3)
	wait(750)
	while UO.TargCurs do
		wait(10)
	end
	local container = UO.LTargetID
	UO.LObjectID = container
	
	return item:scan():cont(container):tp(8901):property()
end
-----------------------------------------------------------------
function getName(book)
	local name = string.sub(book.stats,10,string.len(book.stats))
	return name
end

function setRunebook()
	UO.ExMsg(UO.CharID,3,50,"Please Target a Runebook")
	UO.Macro(13,3)
	wait(750)
	while UO.TargCurs do
		wait(10)
	end
        local runebooks = item:scan():id(UO.LTargetID)
	if next(runebooks) ~= nil then
	   runebooks:property()
	   runebook = runebooks:pop()
	   msgL.ctrl.Caption = getName(runebook)
	   wait(1000)
        end
end

function navigate(position)
	if position == 0 then
		errorMsg("Failed to set location")
		return
	end
	circle = math.floor(position/2) + position%2
	local toUse = nil
	if defaultCB.ctrl.Checked then
		if runebook == nil then
			setRunebook()
		end
		toUse = runebook
	else
		toUse = GetSelectedItem(itemsLB,books)	
		if toUse == nil then
			return
		end		
	end
	toUse:use()
	wait(500)
	Click.Gump(circleXOffset[circle],circleYOffset)
	wait(500)
	if yOffset == 0 then
		errorMsg("Please select a travel spell")
		return
	end
	if position%2 == 1 then
		xOffset = leftOffset
	else
		xOffset = rightOffset
	end		
	if xOffset == 0 or yOffset == 0 then
	   errorMsg("Error setting offset")
           return
        end   
        Click.Gump(xOffset,yOffset)
end

---------------------------------------------------------
---------------------------GUI---------------------------
---------------------------------------------------------
runebookApp = menu:form(210,400,"Runebook Helper")

runebookB = runebookApp:button("runebook",40,10,120,20,"Set Default Runebook")

msgL = runebookApp:label("msg",10,40,60,20,"No Default Set")
defaultCB = runebookApp:checkbox("default",110,40,80,20,"Use Default")


recallRB = runebookApp:radiobutton("recall",10,70,70,20,"Recall")
gateRB = runebookApp:radiobutton("gate",70,70,50,20,"Gate")
sacredRB = runebookApp:radiobutton("sacred",120,70,70,20,"Sacred")
--Defauling travel spell to sacred journey
sacredRB.ctrl.Checked = true
yOffset = sacredOffset

---40 radio buttons
---row 1 70
---row 2 100
---defaults 130

oneB = runebookApp:button("one",5,100,20,20,"1")
twoB = runebookApp:button("two",30,100,20,20,"2")
threeB = runebookApp:button("three",55,100,20,20,"3")
fourB = runebookApp:button("four",80,100,20,20,"4")
fiveB = runebookApp:button("five",105,100,20,20,"5")
sixB = runebookApp:button("six",130,100,20,20,"6")
sevenB = runebookApp:button("seven",155,100,20,20,"7")
eightB = runebookApp:button("eight",180,100,20,20,"8")

nineB = runebookApp:button("nine",5,130,20,20,"9")
tenB = runebookApp:button("ten",30,130,20,20,"10")
elvenB = runebookApp:button("elven",55,130,20,20,"11")
twelveB = runebookApp:button("twelve",80,130,20,20,"12")
thirteenB = runebookApp:button("thirteen",105,130,20,20,"13")
fourteenB = runebookApp:button("fourteen",130,130,20,20,"14")
fifteenB = runebookApp:button("fifteen",155,130,20,20,"15")
sixteenB = runebookApp:button("sixteen",180,130,20,20,"16")

setB = runebookApp:button("set",40,160,120,20,"Load Runebook Listbox")
itemsLB = runebookApp:listbox("items",10,190,180,170)
itemsLB.ctrl.MultiSelect = false

runebookB:onclick(function() setRunebook() end)
recallRB:onclick(function() yOffset = recallOffset end)
gateRB:onclick(function() yOffset = gateOffset end)
sacredRB:onclick(function() yOffset = sacredOffset end)


oneB:onclick(function() navigate(1) end)
twoB:onclick(function() navigate(2) end)
threeB:onclick(function() navigate(3) end)
fourB:onclick(function() navigate(4) end)
fiveB:onclick(function() navigate(5) end)
sixB:onclick(function() navigate(6) end)
sevenB:onclick(function() navigate(7) end)
eightB:onclick(function() navigate(8) end)
nineB:onclick(function() navigate(9) end)
tenB:onclick(function() navigate(10) end)
elvenB:onclick(function() navigate(11) end)
twelveB:onclick(function() navigate(12) end)
thirteenB:onclick(function() navigate(13) end)
fourteenB:onclick(function() navigate(14) end)
fifteenB:onclick(function() navigate(15) end)
sixteenB:onclick(function() navigate(16) end)
setB:onclick(function() 
books = getRunebooks()
loadListBox(itemsLB,books) 
end)

runebookApp:show()
Obj.Loop()
runebookApp:free()
