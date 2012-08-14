--==========================================================================================================
-- Script Name: Bod Suite Application
-- Author: McHale
-- Version: 1.0
-- OpenEUO version tested with: 0.91
-- Purpose: 
-- TODO A LOT OF DIFFERENT PROGRAMS WILL BE INCORPORATED INTO THIS
--==========================================================================================================

------------------------------------------------------------   
--------------------------IMPORTS---------------------------
------------------------------------------------------------   

dofile("../Lib/menulib.lua")
dofile("../Lib/bodlibv2.lua")
dofile("../Lib/functions.lua")
dofile("../Lib/basiclib.lua")


------------------------------------------------------------------------------------------------------------   
------------------------------------------------FUNCTIONS---------------------------------------------------
------------------------------------------------------------------------------------------------------------
        --Price Variable Settings--
priceStr = nil
bodbook = nil

function getName(book)
	s,e,name = string.find(book.stats,"Book Name: (.+)")
	if name ~= nil then
           return name
	end
	return "Bod Book Set"
end

function setBodBook()
	UO.ExMsg(UO.CharID,3,50,"Please select a Bulk Order Book to price.")
	UO.Macro(13,3)
	wait(750)
	while UO.TargCurs do
		wait(10)
	end
        local bodbooks = item:scan():id(UO.LTargetID)
	if next(bodbooks) == nil then
	   return -1
        end
        if next(bodbooks:tp(8793)) == nil then
           return -1
        end
 
        bodbooks:property()
        bodbook = bodbooks:pop()
        msgL.ctrl.Caption = getName(bodbook)
end

function setPrice()
	for char in priceStr:gmatch"." do
	    UO.Key(char)
	end
	UO.Key("ENTER")                                            
end

function waitGumpClose(x,y)
         while UO.ContSizeX == x and UO.ContSizeY == y do 
               wait(10)
         end
         wait(500)
end

function waitGumpOpen(x,y)
         while UO.ContSizeX ~= x or UO.ContSizeY ~= y do
               wait(10)
         end
end

function pricePage()	
	local page_end = false
	local count = 0
	local i = UO.ContPosY
	while not page_end do
		if i == UO.ContPosY + UO.ContSizeY then
			page_end = true
			print("Number of Bods Priced")
			print(count)
		        print("Page Completed")
		        print("==============")
			break;
		elseif UO.ContSizeY == 454 and UO.ContSizeX == 615 then
		       local pix = UO.GetPix(UO.ContPosX+585,i)
		       if pix == 15707540 then
		          Click.Gump(585,i-UO.ContPosY)
		          waitGumpClose(615,454)
		          --setTime = getticks()
		          setPrice()
		          waitGumpOpen(615,454)
		          count = count + 1 
		          i = i + 20
                       else
                          i = i+1
                       end
                 else
                     --timeout value?
                 end
	end
	return count
end

function price()
        if bodbook == -1 then
           return
        end
        bodbook:use():waitContSize(531,454)
        s,e,num_deeds = string.find(bodbook.stats,"Deeds In Book: (%d+)")
        local count = 0
        while count < tonumber(num_deeds) do
       	      toAdd = pricePage()			
              count = count + toAdd
              Click.Gump(240, 425)
              wait(1000)
        end
        print("Total Bods Priced:")
        print(count)
end

function run()
	priceStr = priceE.ctrl.Text
	print(priceStr)
	priceInt = tonumber(priceStr)
	if bodbook == nil then
	   errorMsg("Please select a Bod Book")
	elseif priceStr == "" then
	   errorMsg("Please enter a Price")
	elseif priceInt == nil then 
	   errorMsg("Please enter a number for the price")
	elseif priceInt%1 ~= 0 then
	   errorMsg("Please enter an integer for the price")
	else
	    --Everything is okay run the pricing script
	    price() 
        end
end

------------------------------------------------------------------------------------------------------------   
-------------------------------------------------GUI CODE---------------------------------------------------
------------------------------------------------------------------------------------------------------------   

---------------------------------------------------------
---------------------GUI VARIABLES-----------------------
---------------------------------------------------------
local app_title = "Bod App Suite"
local length , width = 500 , 300
local tab_strings = {"One Click","Price","Macros","Sort"}

        --More Complex Gui Variable Settings--
--local tab_dict = {"One Click":{fillB,,"Price":{bodBookB,msgL,priceE,priceL,priceB},"Macros","Sort"}

x_pos , y_pos = 20,50
btn_x , btn_y = 250,20
col_x_offset = x_pos+btn_x+10
col_y_offset = btn_y+5

elements = {}

---------------------------------------------------------
-----------------GENERAL GUI FUNCTIONS-------------------
---------------------------------------------------------
function updateOffsets(row,col)
    if row then
        x_pos = x_pos + col_x_offset
    end
    if col then
        y_pos = y_pos + col_y_offset
    end
    return x_pos , y_pos
end

function hideCurrentElements()
    for i = 1, #elements do
        element = elements[i]
        element.ctrl.Visible = false
    end
end

function showCurrentElements()
    for i = 1, #elements do
        element = elements[i]
        element.ctrl.Visible = true
    end
end

--loads a listbox with items (list of strings)
function loadListBox(listbox, items)
	listbox.ctrl.Clear()
	for i = 1, #items do
		listbox.ctrl.Items.Add(items[i])
        end
end

--Returns Select index from the listbox, which starts at 0
--instead of the usual 1, and gets the corresponding index in
--the items objects list returned by Jack Penny's itemlib
function getSelectedIndices(listbox, items) 
        if next(items) == nil then
           return -1
        end
        toReturn = {}
	for i =0, #items-1 do
		local bool = listbox.ctrl.GetSelected(i)
                if bool then 
                   table.insert(toReturn,i)
                end
	end
        return toReturn
end

---------------------------------------------------------
--------------------------PRICE--------------------------
---------------------------------------------------------
function initPriceTab()
    x_pos , y_pos = 80,50
    btn_x , btn_y = 60,20
    col_x_offset, col_y_offset = 0, 30

    bodBookB = bodApp:button("bodbook",x_pos,y_pos,btn_x*2,btn_y,"Set Bulk Order Book")
    x_pos, y_pos = updateOffsets(false,true)
    msgL = bodApp:label("msg",x_pos,y_pos,btn_x,btn_y,"No Bulk Order Book Set")
    x_pos, y_pos = updateOffsets(false,true)
    priceL = bodApp:label("price",x_pos,y_pos,btn_x,btn_y,"Bod Price: ")
    col_y_offset = 5
    col_x_offset = 45
    x_pos, y_pos = updateOffsets(false,true)
    priceE = bodApp:edit("input",x_pos,y_pos,btn_x,btn_y,"")
    col_y_offset = 20
    x_pos, y_pos = updateOffsets(false,true)
    priceB = bodApp:button("run", x_pos,y_pos,btn_x*2,btn_y,"Price Bulk Order Deeds")

    bodBookB:onclick(function() setBodBook() end)
    priceB:onclick(function() run() end)

    elements = {bodBookB,msgL,priceE,priceL,priceB}
end

---------------------------------------------------------
------------------------ONE CLICK------------------------
---------------------------------------------------------

function initOneClickTab()
    x_pos , y_pos = 20,50
    btn_x , btn_y = 250,20
    col_x_offset = x_pos+btn_x+10
    col_y_offset = btn_y+5
    
    fillB = bodApp:button("fill",x_pos,y_pos,btn_x,btn_y,"Fill Bod") 
    x_pos, y_pos = updateOffsets(false,true)
    rewardB = bodApp:button("reward",x_pos,y_pos,btn_x,btn_y,"Bod Reward")
    x_pos, y_pos = updateOffsets(false,true)
    referenceB = bodApp:button("reference",x_pos,y_pos,btn_x,btn_y,"Cross-Reference Bod")
    x_pos, y_pos = updateOffsets(false,true)

    elements = {fillB, rewardB, referenceB}
end

---------------------------------------------------------
---------------------------BLOB--------------------------
---------------------------------------------------------
function initBlobTab()
    x_pos , y_pos = 20,50
    btn_x , btn_y = 250,20
    col_x_offset = x_pos+btn_x+10
    col_y_offset = btn_y+5

    bookLB = bodApp:listbox("items",x_pos,y_pos,btn_x,btn_y*3)
    bookLB.ctrl.MultiSelect = false
    books = bod_books:scan():book_names()
    loadListBox(bookLB, books)
    col_y_offset = btn_y*3+10
    x_pos, y_pos = updateOffsets(false,true)
    col_y_offset = btn_y + 10

    emptyB = bodApp:button("empty",x_pos,y_pos,btn_x,btn_y,"Empty Bod Book")
    x_pos, y_pos = updateOffsets(false,true)
    typeB = bodApp:button("type",x_pos,y_pos,btn_x/4,btn_y,"Type")

    sort_x_pos = x_pos
    bowyerRB = bodApp:radiobutton("bowyer",sort_x_pos,y_pos,btn_x/4,btn_y,"Bowyer")
    bowyerRB.ctrl.Checked = true
    sort_x_pos =sort_x_pos + btn_x/4
    smithRB = bodApp:radiobutton("smith",sort_x_pos,y_pos,btn_x/4,btn_y,"Smith")
    sort_x_pos =sort_x_pos + btn_x/4
    carpRB = bodApp:radiobutton("carp",sort_x_pos,y_pos,btn_x/4,btn_y,"Carp")
    sort_x_pos =sort_x_pos + btn_x/4
    tailorRB = bodApp:radiobutton("tailor",sort_x_pos,y_pos,btn_x/4,btn_y,"Tailor")
    x_pos, y_pos = updateOffsets(false,true)

    crossCB = bodApp:checkbox("cross",15,y_pos,btn_x,btn_y,"Include Small Fitting Bods in Reward Tier Bods")
    x_pos, y_pos = updateOffsets(false,true)

    sort_x_pos = 7   
    tierB = bodApp:button("tier",sort_x_pos,y_pos,btn_x/3,btn_y,"Tier")
    sort_x_pos =sort_x_pos + btn_x/3 + 5
    sizeB = bodApp:button("size",sort_x_pos,y_pos,btn_x/3,btn_y,"Size")
    sort_x_pos =sort_x_pos + btn_x/3 + 5
    resourceB = bodApp:button("resource",sort_x_pos,y_pos,btn_x/3,btn_y,"Resource")
    x_pos, y_pos = updateOffsets(false,true)

    filterLB = bodApp:listbox("filters",x_pos,y_pos,btn_x,btn_y*3)
    filterLB.ctrl.MultiSelect = true
    col_y_offset = btn_y*3+10
    x_pos, y_pos = updateOffsets(false,true)
    col_y_offset = btn_y + 10

    print(length-200)
    print(y_pos)
    filterGB.ctrl.Height = length-200
end

function getSelectedProfession()
        if bowyerRB.ctrl.Checked then return 1
        elseif smithRB.ctrl.Checked then return 2
        elseif carpRB.ctrl.Checked then return 3
        end
        return 4
end

---------------------------------------------------------
---------------------MAIN APP CODE-----------------------
---------------------------------------------------------
bodApp = menu:form(width,length,app_title)

tabs = bodApp:tabcontrol("tabs",10,10,width-width/10,length-length/10,tab_strings)
initOneClickTab()

tabs:onchange(
function()

    hideCurrentElements()

    if tabs.ctrl.TabIndex == 0 then
        elements = {fillB, rewardB, referenceB}
    elseif tabs.ctrl.TabIndex == 1 then
        if not bodBookB then initPriceTab()
        else elements = {bodBookB,msgL,priceE,priceL,priceB} end
    elseif tabs.ctrl.TabIndex == 2 then
        initBlobTab()
    elseif tabs.ctrl.TabIndex == 3 then
        print("Clicked Sort")
    else
        print("Shouldn't get here")
    end

    showCurrentElements()
end)


bodApp:show()
Obj.Loop()
bodApp:free()
