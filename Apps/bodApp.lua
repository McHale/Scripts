--==========================================================
-- Script Name: Bod Application
-- Author: McHale
-- Version: 1.0
-- OpenEUO version tested with: 0.91
-- Purpose: Return Bod Rewards and Complete Bods
--==========================================================

dofile("../Lib/menulib.lua")
dofile("../Lib/bodlibv2.lua")
dofile("../Lib/functions.lua")

function labelHeaderFormat(label)
    label.ctrl.Font.Size = 10
    label.ctrl.Font.Style = 4
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

function getSelectedProfession()
        if bowyerRB.ctrl.Checked then return 1
        elseif smithRB.ctrl.Checked then return 2
        elseif carpRB.ctrl.Checked then return 3
        end
        return 4
end

------------------------_________GUI CODE_________---------------------

local app_title = "Bod App Suite"
local length , width = 500 , 300
--size of button
local btn_x , btn_y = 270 , 20
--initial element position on panel
local initial_x_pos , initial_y_pos = 10 , 30
--variables to change dynamically while added elements
local x_pos , y_pos = 10 , 30   
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

bodApp = menu:form(width,length,app_title)
reviewGB = bodApp:groupbox("review",5,10,width-20,0,"Filling and Reviewing Bods")                            
fillB = bodApp:button("fill",x_pos,y_pos,btn_x,btn_y,"Fill Bod") 
x_pos, y_pos = updateOffsets(false,true)
rewardB = bodApp:button("reward",x_pos,y_pos,btn_x,btn_y,"Bod Reward")
x_pos, y_pos = updateOffsets(false,true)
referenceB = bodApp:button("reference",x_pos,y_pos,btn_x,btn_y,"Cross-Reference Bod")
reviewGB.ctrl.Height = y_pos+20 
--SORTING SECTION
--UPDATE REFERENCES FOR SORTING SECTION
col_y_offset = btn_y+20
x_pos, y_pos = updateOffsets(false,true)
col_y_offset = btn_y+5
filterGB = bodApp:groupbox("review",5,y_pos,width-15,0,"Filling and Reviewing Bods")
x_pos, y_pos = updateOffsets(false,true)

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
--VARIABLES FOR
typeB:onclick(function()
        loadListBox(filterLB, BOD_TYPES)
end)
                         

tierB:onclick(function()
        profID = getSelectedProfession()
        loadListBox(filterLB, Reward[profID])
end)

sizeB:onclick(function()
        profID = getSelectedProfession()
        loadListBox(filterLB,BodSizes[profID])
end)

resourceB:onclick(function()
        profID = getSelectedProfession()
        loadListBox(filterLB,BodResource[profID])
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

fillB:onclick(function() 
	local newBod = bods:scan():pop()
	if newBod then newBod:Do()
	else errorMsg("There are no bulk order deeds in your main pack")
	end
end)



bodApp:show()
Obj.Loop()
bodApp:free()