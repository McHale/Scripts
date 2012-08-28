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
        return getName(bodbook)
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
end

------------------------------------------------------------------------------------------------------------   
-------------------------------------------------GUI CODE---------------------------------------------------
------------------------------------------------------------------------------------------------------------   

---------------------------------------------------------
---------------------GUI VARIABLES-----------------------
---------------------------------------------------------
local app_title = "Bod App Suite"
local length , width = 500 , 300
local tab_strings = {"One Click","Price","Sort"}

        --More Complex Gui Variable Settings--

x_pos , y_pos = 20,50
btn_x , btn_y = 250,20
col_x_offset = x_pos+btn_x+10
col_y_offset = btn_y+5

elements = {}

        --Filter Global Variables--
filter = ""
tierFilter = {{},{},{},{}}
sizeFilter = {{},{},{},{}}
resourceFilter = {{},{},{},{}}
bookFilter = {{},{},{},{}}
craftFilter = {1,1,1,1}
crossFilter = {false,false,false,false}
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
        return {}
    end
    toReturn = {}
	for i =0, #items-1 do
		local bool = listbox.ctrl.GetSelected(i)
        if bool then 
           table.insert(toReturn,i+1)
        end
	end
    return toReturn
end

function setSelectedIndices(listbox, items)
    for i = 1, #items do
        listbox.ctrl.SetSelected(items[i]-1, true)
    end
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

    fillB:onclick(function() 
	    local newBod = bods:scan():pop()
	    if newBod then newBod:Do()
	    else errorMsg("There are no bulk order deeds in your main pack")
	    end
    end)

    rewardB:onclick(function()
	    local newBod = bods:scan():pop()
	    if newBod then newBod:ExMsgAll()
	    else errorMsg("There are no bulk order deeds in your main pack")
	    end
    end)

    referenceB:onclick(function()
	    local newBod = bods:scan():pop()
	    if newBod then newBod:ExCrossRef()
	    else errorMsg("There are no bulk order deeds in your main pack")
	    end
    end)

    elements = {fillB, rewardB, referenceB}
end

---------------------------------------------------------
--------------------------PRICE--------------------------
---------------------------------------------------------
function initPriceTab()
    x_pos , y_pos = 70,50
    btn_x , btn_y = 150,20
    col_x_offset, col_y_offset = 0, 30

    bodBookB = bodApp:button("bodbook",x_pos,y_pos,btn_x,btn_y,"Set Bulk Order Book")
    x_pos, y_pos = updateOffsets(false,true)
    msgE = bodApp:edit("msg",x_pos,y_pos,btn_x,btn_y,"No Bulk order book set.")
    msgE.ctrl.Enabled = false
    x_pos, y_pos = updateOffsets(false,true)
    priceE = bodApp:edit("input",x_pos,y_pos,btn_x,btn_y,"Enter the price here.")    
    x_pos, y_pos = updateOffsets(true,true)
    priceB = bodApp:button("run", x_pos,y_pos,btn_x,btn_y,"Price Bulk Order Deeds")

    bodBookB:onclick(function() msgE.ctrl.Text = setBodBook() end)
    priceB:onclick(function() price() end)
end

---------------------------------------------------------
---------------------------SORT--------------------------
---------------------------------------------------------
function loadProfFilter()
    items = {"Please Press a Filter Button Above"}
    filters = {1}


    filterID = getSelectedFilter()
    profID = craftFilter[filterID]
    setSelectedProfession(profID)

    books = bod_books:scan():book_names()
    loadListBox(bookLB, books)
    setSelectedIndices(bookLB, bookFilter[filterID])

    crossCB.ctrl.Checked = crossFilter[filterID]

    if filter == "tier" then
        filters = tierFilter[filterID]
        items = Reward[profID]
   elseif filter == "size" then
        filters = sizeFilter[filterID]
        items = BodSizes[profID]
   elseif filter == "resource" then
        filters = resourceFilter[filterID]
        items = BodResource[profID]
   elseif filter == "" then
        --do nothing set up top
   end

   loadListBox(filterLB, items)
   setSelectedIndices(filterLB, filters)
end

function initSortTab()
    x_pos , y_pos = 20,40
    btn_x , btn_y = 250,20
    col_x_offset = x_pos+btn_x+10
    col_y_offset = btn_y+5

    filterGB = bodApp:groupbox("filters",x_pos,y_pos,btn_x,btn_y*2,"Filters")
    local_x_pos = 5
    local_y_pos = 15
    oneRB = filterGB:radiobutton("one",local_x_pos,local_y_pos,btn_x/5,btn_y,"Filter 1")
    oneRB.ctrl.Checked = true
    local_x_pos =local_x_pos + btn_x/4
    twoRB = filterGB:radiobutton("two",local_x_pos,local_y_pos,btn_x/5,btn_y,"Filter 2")
    local_x_pos =local_x_pos + btn_x/4
    threeRB = filterGB:radiobutton("three",local_x_pos,local_y_pos,btn_x/5,btn_y,"Filter 3")
    local_x_pos =local_x_pos + btn_x/4
    fourRB = filterGB:radiobutton("four",local_x_pos,local_y_pos,btn_x/5,btn_y,"Filter 4")
    x_pos, y_pos = updateOffsets(false,true)
    col_y_offset = btn_y*2-20
    x_pos, y_pos = updateOffsets(false, true)
    col_y_offset = btn_y

    craftGB = bodApp:groupbox("craft",x_pos,y_pos,btn_x,btn_y*2,"Select A Crafting Type")
    local_x_pos = 5
    local_y_pos = 15
    bowyerRB = craftGB:radiobutton("bowyer",local_x_pos,local_y_pos,btn_x/5,btn_y,"Bow")
    bowyerRB:checked(true)
    local_x_pos = local_x_pos + btn_x/4
    smithRB = craftGB:radiobutton("smith",local_x_pos,local_y_pos,btn_x/5,btn_y,"Smith")
    local_x_pos = local_x_pos + btn_x/4
    carpRB = craftGB:radiobutton("carp",local_x_pos,local_y_pos,btn_x/5,btn_y,"Carp")
    local_x_pos = local_x_pos + btn_x/4
    tailorRB = craftGB:radiobutton("tailor",local_x_pos,local_y_pos,btn_x/5,btn_y,"Tailor")
    x_pos, y_pos = updateOffsets(false,true)
    col_y_offset = btn_y*2-15
    x_pos, y_pos = updateOffsets(false, true)
    col_y_offset = btn_y

    toPlaceGB = bodApp:groupbox("to_place",x_pos,y_pos,btn_x,btn_y*3,"Bulk Order Book Storage")
    local_x_pos = 5
    local_y_pos = 15
    bookLB = toPlaceGB:listbox("items",local_x_pos+btn_x/2.5,local_y_pos,btn_x/2,btn_y*2)
    bookLB.ctrl.MultiSelect = false
    books = bod_books:scan():book_names()
    loadListBox(bookLB, books)
    reloadB = toPlaceGB:button("reload",local_x_pos,local_y_pos,btn_x/3,btn_y,"Reload Books")
    reloadB:onclick(function() 
                               books = bod_books:scan():book_names()
                               loadListBox(bookLB, books)
                               end)
    col_y_offset = btn_y*3+5
    x_pos, y_pos = updateOffsets(false,true)
    col_y_offset = btn_y + 5

    criteriaGB = bodApp:groupbox("criteria", x_pos, y_pos, btn_x, btn_y*9,"Additional Criteria")
    local_x_pos = 5
    local_y_pos = 15
    crossCB = criteriaGB:checkbox("cross",local_x_pos,local_y_pos,btn_x-10,btn_y,"Include Small Fitting Bods")
    local_y_pos = local_y_pos + col_y_offset

    row_x_pos = 5
    tierB = criteriaGB:button("tier",row_x_pos,local_y_pos,btn_x/4,btn_y,"Tier")
    row_x_pos =row_x_pos + btn_x/3 + 3
    sizeB = criteriaGB:button("size",row_x_pos,local_y_pos,btn_x/4,btn_y,"Size")
    row_x_pos =row_x_pos + btn_x/3 + 3
    resourceB = criteriaGB:button("resource",row_x_pos,local_y_pos,btn_x/4,btn_y,"Resource")
    local_y_pos = local_y_pos + col_y_offset

    filterLB = criteriaGB:listbox("filters",local_x_pos,local_y_pos,btn_x-10,btn_y*5)
    filterLB.ctrl.MultiSelect = true
    loadProfFilter()
    col_y_offset = btn_y*9+5
    x_pos, y_pos = updateOffsets(false,true)
    col_y_offset = btn_y + 10  

    saveB = bodApp:button("save",x_pos,y_pos,btn_x,btn_y,"Save Filter") 

    oneRB:onclick(function() loadProfFilter() end)
    twoRB:onclick(function() loadProfFilter() end)
    threeRB:onclick(function() loadProfFilter() end)
    fourRB:onclick(function() loadProfFilter() end) 

    bowyerRB:onclick(function() 
        filterID = getSelectedFilter()
        craftFilter[filterID] = getSelectedProfession()
        end)
    smithRB:onclick(function()
        filterID = getSelectedFilter()
        craftFilter[filterID] = getSelectedProfession()
        end)
    carpRB:onclick(function()
        filterID = getSelectedFilter()
        craftFilter[filterID] = getSelectedProfession()
        end)
    tailorRB:onclick(function()
        filterID = getSelectedFilter()
        craftFilter[filterID] = getSelectedProfession()
        end)

    tierB:onclick(function()
            filter = "tier"
            loadProfFilter()
    end)


    sizeB:onclick(function()
            filter = "size"
            loadProfFilter()
    end)

    resourceB:onclick(function()
            filter = "resource"
            loadProfFilter()
    end)

    saveB:onclick(function()
            filterID = getSelectedFilter()
            craftFilter[filterID] = getSelectedProfession()
            bookFilter[filterID] = getSelectedIndices(bookLB, books)
            crossFilter[filterID] = crossCB.ctrl.Checked
            if filter == "tier" then 
                local selected = getSelectedIndices(filterLB, Reward[profID])
                tierFilter[filterID] = selected 
            elseif filter == "size" then
                local selected = getSelectedIndices(filterLB, BodSizes[profID])
                sizeFilter[filterID] = selected
            elseif filter == "resource" then
                local selected = getSelectedIndices(filterLB, BodResource[profID])
                resourceFilter[filterID] = selected
            end
    end)
end

function getSelectedProfession()
        if bowyerRB.ctrl.Checked then return 1
        elseif smithRB.ctrl.Checked then return 2
        elseif carpRB.ctrl.Checked then return 3
        end
        return 4
end

function getSelectedFilter()
        if oneRB.ctrl.Checked then return 1
        elseif twoRB.ctrl.Checked then return 2
        elseif threeRB.ctrl.Checked then return 3
        elseif fourRB.ctrl.Checked then return 4
        end
end

function setSelectedProfession(filterID)
        if filterID == 1 then bowyerRB:checked(true) 
        elseif filterID == 2 then smithRB:checked(true)
        elseif filterID == 3 then carpRB:checked(true)
        elseif filterID == 4 then tailorRB:checked(true) 
        end
end
---------------------------------------------------------
---------------------MAIN APP CODE-----------------------
---------------------------------------------------------
bodApp = menu:form(width,length,app_title)

tabs = bodApp:tabcontrol("tabs",10,10,width-width/10,length-length/10,tab_strings)
initOneClickTab()
exitB = bodApp:button("exit",220,430,50,20,"Exit"):onclick(function() Obj.Exit() end)
tabs:onchange(
function()

    hideCurrentElements()

    if tabs.ctrl.TabIndex == 0 then
        elements = { fillB , rewardB , referenceB }
    elseif tabs.ctrl.TabIndex == 1 then
        if not bodBookB then initPriceTab() end
        
        elements = { bodBookB , msgE , priceE , priceB }
    elseif tabs.ctrl.TabIndex == 2 then
        if not filterGB then initSortTab() end

        elements= { toPlaceGB, filterGB, craftGB, criteriaGB, saveB}
    elseif tabs.ctrl.TabIndex == 3 then
        print("not implemented: Fourth Tab")
    else
        print("Shouldn't get here")
    end

    showCurrentElements()
end)


bodApp:show()
Obj.Loop()
bodApp:free()
