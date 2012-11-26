--==========================================================================================================
-- Script Name: Stig's Weapon Planner
-- Author: McHale
-- Version: 1.0
-- OpenEUO version tested with: 0.91
-- Purpose:
-- Ported Version of Stig's Weapon Planner to OpenEUO
--==========================================================================================================

------------------------------------------------------------
--------------------------IMPORTS---------------------------
------------------------------------------------------------

dofile("../Lib/menulib.lua")
dofile("../Lib/bodlibv2.lua")
--dofile("../Lib/functions.lua")  Not used

------------------------------------------------------------------------------------------------------------
------------------------------------------------FUNCTIONS---------------------------------------------------
------------------------------------------------------------------------------------------------------------

---------------------------------------------------------
---------------------GUI VARIABLES-----------------------
---------------------------------------------------------
local app_title = "Stig's Weapon Planner in OpenEUO"
local length , width = 500 , 300
local tab_strings = {"Init","Melee","Magic","Resists","Stats","Hits","Misc"}

        --More Complex Gui Variable Settings--

x_pos , y_pos = 20,50
btn_x , btn_y = 250,20
col_x_offset = x_pos+btn_x+10
col_y_offset = btn_y+5

--Max Value, Starting Value, Current Value, Spending Point Cost
local attributes = {
["dci"]={50,0,0,3},
["hci"]={50,0,0,3},
["di"]={50,0,0,4},
["ssi"]={40,0,0,4},
["rpd"]={15,0,0,4},
["sdi"]={20,0,0,2},
["fcr"]={6,0,0,5},
["fc"]={1,0,0,50},
["lmc"]={10,0,0,5},
["lrc"]={20,0,0,5},
["pots"]={25,0,0,2},
["sc"]={1,0,0,150},
["mw"]={1,0,0,1},
["hitsRegen"]={6,0,0,2},
["stamRegen"]={10,0,0,1},
["manaRegen"]={6,0,0,6},
["strBonus"]={8,0,0,4},
["dexBonus"]={8,0,0,4},
["intBonus"]={8,0,0,4},
["hits"] = {8,0,0,3},
["stam"] = {8,0,0,3},
["mana"] = {8,0,0,3},
["lsr"] = {100,0,0,2},
["physicalResist"] = {20,0,0,5},
["fireResist"] = {20,0,0,5},
["coldResist"] = {20,0,0,5},
["poisonResist"] = {20,0,0,5},
["energyResist"] = {20,0,0,5},
["hll"] = {60,0,0,3},
["hsl"] = {60,0,0,3},
["hml"] = {60,0,0,3},
["hla"] = {60,0,0,3},
["hld"] = {60,0,0,3},
["magicArrow"] = {60,0,0,4},
["harm"] = {60,0,0,4},
["fireball"] = {60,0,0,4},
["lightning"] = {60,0,0,4},
["dispel"] = {60,0,0,4},
["coldArea"] = {60,0,0,4},
["fireArea"] = {60,0,0,4},
["poisonArea"] = {60,0,0,4},
["energyArea"] = {60,0,0,4},
["physicalArea"] = {60,0,0,4},
["luck"] = {150,0,0,3},
["nightsight"] = {1,0,0,10},
["selfRepair"] = {5,0,0,12},
["bestWeapon"] = {1,0,0,50},
["durability"] = {255,0,0, 1},
}

elements = {normalRB, artifactRB, lootedRB}

elements2D = {
--init tab components
{normalRB, artifactRB, lootedRB},
--melee tab components
{dciCB, hciCB, diCB, ssiCB, rpdCB},
--magic tab components
{sdiCB, fcrCB, fcCB, lmcCB, lrcCB, potsCB, scCB, mwCB},
--stats tab components
{regenHitsCB, regenManaCB, strCB, dexCB, intCB, hitsCB, stamCB, manaCB, lsrCB},
--resists tab components
{physicalCB,fireCB,coldCB,poisonCB,energyCB},
--hits tab components
{hllCB, hslCB, hmlCB, hlaCB, hldCB, arrowCB, harmCB, fireCB, lightCB, dispelCB,
coldAreaCB, fireAreaCB, poisonAreaCB, physicalAreaCB},
--misc tab components
{luckCB, nightCB, repairCB, bestCB, durabilityCB}
}

function init(index)
    if index == 0 then initZero()
    elseif index == 1 then initOne()
    elseif index == 2 then initTwo()
    else initThree() end
end

---------------------------------------------------------
--------------------------Init---------------------------
---------------------------------------------------------
function initZero()
    x_pos , y_pos = 20,50
    btn_x , btn_y = 60,20
    col_x_offset = x_pos+btn_x+5
    col_y_offset = btn_y+5

    normalRB = weapApp:radiobutton( "Normal" , x_pos , y_pos , btn_x , btn_y , "Normal" )
    x_pos, y_pos = updateOffsets(true,false)
    artifactRB = weapApp:radiobutton( "Artifact" , x_pos , y_pos , btn_x , btn_y , "Artifact" )
    x_pos, y_pos = updateOffsets(true,false)
    lootedRB = weapApp:radiobutton( "Looted" , x_pos , y_pos , btn_x , btn_y , "Looted" )
end

---------------------------------------------------------
--------------------------MELEE--------------------------
---------------------------------------------------------
function initOne()
    x_pos , y_pos = 70,50
    btn_x , btn_y = 150,20
    col_x_offset, col_y_offset = 0, 30

    local fifty = numberList(50)
    dciCB = weapApp:combobox("dci",x_pos,y_pos,btn_x,btn_y,fifty)
    x_pos, y_pos = updateOffsets(false, true)
    hciCB = weapApp:combobox("dci",x_pos,y_pos,btn_x,btn_y,fifty)
    x_pos, y_pos = updateOffsets(false, true)
    diCB = weapApp:combobox("di",x_pos,y_pos,btn_x,btn_y,fifty)
    x_pos, y_pos = updateOffsets(false, true)
    local forty = numberList(40)
    ssiCB = weapApp:combobox("ssi",x_pos,y_pos,btn_x,btn_y,forty)
    x_pos, y_pos = updateOffsets(false, true)
    local fifteen = numberList(15)
    rpdCB = weapApp:combobox("rpd",x_pos,y_pos,btn_x,btn_y,fifteen)
end

---------------------------------------------------------
---------------------------BLOB--------------------------
---------------------------------------------------------
function initTwo()
    x_pos , y_pos = 20,50
    btn_x , btn_y = 250,20
    col_x_offset = x_pos+btn_x+10
    col_y_offset = btn_y+5

    bookLB = weapApp:listbox("items",x_pos+btn_x/2,y_pos,btn_x/2,btn_y*3)
    bookLB.ctrl.MultiSelect = false
    books = bod_books:scan():book_names()
    loadListBox(bookLB, books)
    col_y_offset = btn_y*3+10
    x_pos, y_pos = updateOffsets(false,true)
    col_y_offset = btn_y + 10

    sort_x_pos = x_pos
    bowyerRB = weapApp:radiobutton("bowyer",sort_x_pos,y_pos,btn_x/4,btn_y,"Bowyer")
    bowyerRB.ctrl.Checked = true
    sort_x_pos =sort_x_pos + btn_x/4
    smithRB = weapApp:radiobutton("smith",sort_x_pos,y_pos,btn_x/4,btn_y,"Smith")
    sort_x_pos =sort_x_pos + btn_x/4
    carpRB = weapApp:radiobutton("carp",sort_x_pos,y_pos,btn_x/4,btn_y,"Carp")
    sort_x_pos =sort_x_pos + btn_x/4
    tailorRB = weapApp:radiobutton("tailor",sort_x_pos,y_pos,btn_x/4,btn_y,"Tailor")
    x_pos, y_pos = updateOffsets(false,true)

    crossCB = weapApp:checkbox("cross",x_pos,y_pos,btn_x,btn_y,"Include Small Fitting Bods in Reward Tier Bods")
    x_pos, y_pos = updateOffsets(false,true)

    sort_x_pos = 15
    tierB = weapApp:button("tier",sort_x_pos,y_pos,btn_x/3,btn_y,"Tier")
    sort_x_pos =sort_x_pos + btn_x/3 + 5
    sizeB = weapApp:button("size",sort_x_pos,y_pos,btn_x/3,btn_y,"Size")
    sort_x_pos =sort_x_pos + btn_x/3 + 5
    resourceB = weapApp:button("resource",sort_x_pos,y_pos,btn_x/3,btn_y,"Resource")
    x_pos, y_pos = updateOffsets(false,true)

    filterLB = weapApp:listbox("filters",x_pos,y_pos,btn_x,btn_y*5)
    filterLB.ctrl.MultiSelect = true
    col_y_offset = btn_y*5+10
    x_pos, y_pos = updateOffsets(false,true)
    col_y_offset = btn_y + 10
end

function getSelectedProfession()
        if bowyerRB.ctrl.Checked then return 1
        elseif smithRB.ctrl.Checked then return 2
        elseif carpRB.ctrl.Checked then return 3
        end
        return 4
end

elements = {normalRB, artifactRB, lootedRB}

elements2D = {
--init tab components
{normalRB, artifactRB, lootedRB},
--melee tab components
{dciCB, hciCB, diCB, ssiCB, rpdCB},
--magic tab components
{sdiCB, fcrCB, fcCB, lmcCB, lrcCB, potsCB, scCB, mwCB},
--stats tab components
{regenHitsCB, regenManaCB, strCB, dexCB, intCB, hitsCB, stamCB, manaCB, lsrCB},
--resists tab components
{physicalCB,fireCB,coldCB,poisonCB,energyCB},
--hits tab components
{hllCB, hslCB, hmlCB, hlaCB, hldCB, arrowCB, harmCB, fireCB, lightCB, dispelCB,
coldAreaCB, fireAreaCB, poisonAreaCB, physicalAreaCB},
--misc tab components
{luckCB, nightCB, repairCB, bestCB, durabilityCB}
}

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


function goBack(tabs)
    index = tabs.ctrl.TabIndex
    if index > 0 then
        hideElements(elements)
        elements = elements2D[index]
        tabs.ctrl.TabIndex = index - 1
        showElements(elements)
    end
end

function goForward(tabs)
    index = tabs.ctrl.TabIndex
    if index < #tab_strings then
        hideElements(elements)
        elements = elements2D[index+1]
        tabs.ctrl.TabIndex = index + 1
        if elements[index] then
            showElements(elements)
        else
            init(index)
        end
    end
end

function showElements(elements)
    for i = 1, #elements do
        element = elements[i]
        element.ctrl.Visible = true
    end
end

function hideElements(elements)
    for i = 1, #elements do
        element = elements[i]
        element.ctrl.Visible = false
    end
end

function numberList(num)
    local a = {}
    for i = 0, num do
        table.insert(a, tostring(i))
    end
    return a
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
---------------------MAIN APP CODE-----------------------
---------------------------------------------------------
weapApp = menu:form(width,length,app_title)

tabs = weapApp:tabcontrol("tabs",10,10,width-width/10,length-length/10,tab_strings)
init(0)
elements = {normalRB, artifactRB, lootedRB}

--exitB = bodApp:button("exit",220,430,50,20,"Exit"):onclick(function() Obj.Exit() end)
backB = weapApp:button("back",25,430,50,20,"< Back"):onclick(function() goBack(tabs) end)
nextB = weapApp:button("next",220,430,50,20,"Next >"):onclick(function() goForward(tabs) end)


--local tab_strings = {"Init","Melee","Magic","Stats","Resists","Hits","Misc"}
tabs:onchange(
function()

    hideElements(elements)

    index = tabs.ctrl.TabIndex
    elements = elements2D[index+1]

    if not elements[1] then init(index) end

    showElements(elements)
end)

weapApp:show()
Obj.Loop()
weapApp:free()
