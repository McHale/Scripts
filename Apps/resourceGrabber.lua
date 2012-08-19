--==========================================================
-- Script Name: Resource Grabber
-- Author: McHale
-- Version: 1.0
-- OpenEUO version tested with: 0.91
-- Purpose: Allows you to have a window open to quickly access and drop 
-- specifics resources, or just open the gump to view the items values.
--==========================================================

------------------------------------------------------------   
--------------------------IMPORTS---------------------------
------------------------------------------------------------   

dofile("../Lib/storagelib.lua")
dofile("../Lib/menulib.lua")
dofile("../Lib/config.lua")

------------------------------------------------------------   
-----------------------MENU OFFSETS-------------------------
------------------------------------------------------------

local window_x , window_y = 200 , 250
local window_title = "Grab"

myApp = menu:form( window_x , window_y , window_title)
mainPanel = myApp:panel("main",0,0,200,250)
spellPanel = myApp:panel("spell",0,0,200,250)

------------------------------------------------------------   
------------------------MAIN PANEL--------------------------
------------------------------------------------------------
--size of panel
local length , width = 200 , 250
--size of button
local btn_x , btn_y = 100  , 20
--initial element position on panel
local initial_x_pos , initial_y_pos = 50 , 10
--variables to change dynamically while added elements
local x_pos , y_pos = 50 , 10   
--offset for a button 
local col_x_offset = x_pos+btn_x+10
local col_y_offset = btn_y+5

function updateOffsets(row,col)
         if row then
            x_pos = x_pos + col_x_offset
         end
         if col then
            y_pos = y_pos + col_y_offset
         end
         return x_pos , y_pos
end


local buttons = {
{"Spell Caster Items","Ingots","Wood Worker Items", "Gems","Tailoring Items", "Tools","Runics Tools","Granite"}
}

for i = 1, #buttons do
    buttonColumn = buttons[i]
    for i = 1 , #buttonColumn do 
        mainPanel:button( buttonColumn[i] , x_pos , y_pos , 
                          btn_x , btn_y , buttonColumn[i]):onclick(function() spellPanel:front() end)
        x_pos , y_pos = updateOffsets(false,true) 
    end
    x_pos , y_pos = initial_x_pos , intial_y_pos
    x_pos , y_pos = updateOffsets(true,false)
end

------------------------------------------------------------   
-----------------------SPELL PANEL--------------------------
------------------------------------------------------------
--size of panel
local length , width = 200 , 250
--size of button
local btn_x , btn_y = 75  , 20
--initial element position on panel
local initial_x_pos , initial_y_pos = 10 , 10
--variables to change dynamically while added elements
local x_pos , y_pos = 10 , 10   
--offset for a button 
local col_x_offset = x_pos+btn_x+10
local col_y_offset = btn_y+5


buttons = {
{"Black Pearl", "Blood Moss","Garlic","Ginseng","MandrakeRoot","NightShade",
"Sulfurous Ash","Spider's Silk","Bat Wing","Grave Dust","Deamon Blood",
"Nox Crystal","Pig Iron", "Fertile Dirt","Zoogi Fungus","Trans. Powder"},
{"Bone","Daemon Bone","Potion Keg","Blank Scroll","Bottle","Sand","Key Ring",
"Bees Wax","Spring Water", "Petrafied Wood","Destroying Angel",
"Ethereal Powder","Recall Rune"}
}

-- @row -Boolean true updates the x offset, false disables update
-- @col -Boolean true updates the y offset, false disables updates
function updateOffsets(row,col)
         if row then
            x_pos = x_pos + col_x_offset
         end
         if col then
            y_pos = y_pos + col_y_offset
         end
         return x_pos , y_pos
end

for i = 1, #buttons do
    buttonColumn = buttons[i]
    for i = 1 , #buttonColumn do 
        spellPanel:button( buttonColumn[i] , x_pos , y_pos , 
                          btn_x , btn_y , buttonColumn[i]):onclick(function() spellPanel:front() end)
        x_pos , y_pos = updateOffsets(false,true) 
    end
    x_pos , y_pos = initial_x_pos , intial_y_pos
    x_pos , y_pos = updateOffsets(true,false)
end

mainPanel:front()
myApp:show()
Obj.Loop()
myApp:free()
