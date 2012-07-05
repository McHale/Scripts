dofile("../lib/itemlib.lua")
dofile("../lib/menulib.lua")

------------------------------
--DEFAULT FLOWER INFORMATION--
------------------------------
--Flower openUO TYPES
local flower_types = 
{3203,3206,3208,3220,3211,3237,3239,3223,3231,3238,3328,3377,3332,3241,3372,3366,3367}

local BOWLS = {["5634"]="Bowl Stage 1",["5632"]="Bowl Stage 2"}
--5634 (bowl of potatoes)

---Will have to fix the names of the plants as I go
local PLANTS ={["3203"]="Campion", ["3206"]="Poppies", ["3208"]="Snowdrops", ["3220"]="Bulrushes", ["3211"]="Lilies", ["3237"]="Pampas Grass", ["3239"]="Rushes", ["3223"]= "Elephant Ear Plant", ["3231"]="Fern", ["3238"]="Ponytail Palm", ["3328"]= "Small Palm", ["3377"]="Century Plant", ["3332"]="Water Plant", ["3241"]="Snake Plant", ["3372"]="Prickly Pear Cactus", ["3366"]="Barrel Cactus", ["3367"]="Tribarrel Cactus"}

local COLORS = {"Plain","Red","Bright Red","Blue","Bright Blue","Yellow","Bright Yellow", "Green","Bright Green","Purple","Bright Purple","Orange","Bright Orange"}

local COLOR_CROSSBREED = {
{0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1},
{0,2,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1},
{0,2,2,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1},
{0,9,9,4,-1,-1,-1,-1,-1,-1,-1,-1,-1},
{0,9,9,4,4,-1,-1,-1,-1,-1,-1,-1,-1},
{0,11,11,7,7,6,-1,-1,-1,-1,-1,-1,-1},
{0,11,11,7,7,6,6,-1,-1,-1,-1,-1,-1},
{0,1,1,3,3,5,5,8,-1,-1,-1,-1,-1},
{0,1,1,3,3,5,5,8,8,-1,-1,-1,-1},
{0,1,1,3,3,5,5,3,3,10,-1,-1,-1},
{0,1,1,3,3,5,5,3,3,10,10,-1,-1},
{0,1,1,3,3,5,5,5,5,1,1,12,-1},
{0,1,1,3,3,5,5,5,5,1,1,12,12}
}

local BEE_FRIENDLY = {1,2,3,5}

------------------------------
-------HELPER FUNCTIONS-------
------------------------------
function getColor(color_id)
	return COLORS[color_id+1]
end

function getColorID(color)
	for i=1, #COLORS do
		if COLORS[i] == color then
			return i
		end
	end
	return -1
end	

function findColorID(plant)
	for j=1, #COLORS, 2 do           
		s,e = string.find(plant.name, COLORS[j])
		if s ~= nil then
			return j-1
		end
	end
	for i=1, #COLORS do
		s,e = string.find(plant.name, COLORS[i])
		if s ~= nil then
			return i-1
		end
	end
	return -1
end

function getPlant(plant_type)
         plant_type = plant_type..""
	return PLANTS[plant_type]	
end

function getPlantID(plant_type)
        plant_num = tonumber(plant_type)   
	for i=1, #flower_types do
		if flower_types[i] == plant_num then
			return i
		end
	end
	return -1
end

function getPlantType(plant_id)
         return flower_types[plant_id]
end
         

function findPlantType(plant)
	for k,v in pairs(PLANTS) do 
		s,e = string.find(plant.name, v)
		if s ~= nil then
			return k
		end
	end
	return "error"
end

function isBeeFriendly(plant_id)
	for i=1, #BEE_FRIENDLY do
		if BEE_FRIENDLY[i] == plant_id then
			return true 
		end
	end
	return false
end

function beeString(beeFriendly)
	if beeFriendly then
		return "Bee Friendly"
	else
		return ""
	end
end

function getChildColor(a, b)
	color = COLOR_CROSSBREED[a.color_id+1][b.color_id+1]
	if color < 0 then
		color = COLOR_CROSSBREED[b.color_id+1][a.color_id+1]
                return COLORS[color+1]
	end
	return COLORS[color+1]
end

function getChildID(a, b)
         a = a.plant_id
         b = b.plant_id
	plant = (a+b)/2
	if plant/1 == plant then
		return plant
	elseif (b == a+1) or (b==a-1) then
		return -1
	else
		return math.floor(plant)
	end
end

function targetItem(msg, color)
	color = color or 16
	UO.ExMsg(UO.CharID,3,color,msg)
        UO.Macro(13,14)
        wait(750)
        while UO.TargCurs do
		wait(100)
        end
        return UO.LTargetID
end
          	

------------------------------
----------FUNCTIONS-----------
------------------------------
flower = {}
flower_meta = {__index = flower}

function flower:scanPlant()
	plant_id = targetItem("Please target a plant for crossbreeding")
	local plant = item:scan():id(plant_id):property():pop()
	if PLANTS[tostring(plant.tp)] == nil and BOWLS[tostring(plant.tp)] == nil then
   		UO.ExMsg(UO.CharID,3, 20,"Targeted object is not a plant.")
		return
	end
        if PLANTS[tostring(plant.tp)] == nil then
           plant["mature"] = false
        else
            plant["mature"] = true
        end
        
	plant["color_id"] = findColorID(plant)
	plant["color"] = getColor(plant.color_id)
	plant["plant_tp"] = findPlantType(plant)
	plant["plant_id"] = getPlantID(plant.plant_tp)
	plant["plant"] = getPlant(plant.plant_tp)
        plant["bee_friendly"] = isBeeFriendly(plant.plant_id)
        return plant
end
	
function plantInfoString(plant)
         return {"Plant Name: "..plant.plant, 
         "Color: "..plant.color,
        "Mature: "..tostring(plant.mature),
        beeString(plant.bee_friendly)}
end


function crossPollinate()
	UO.ExMsg(UO.CharID,3,11,"You will cross-pollinate same type plants of the stack you are standing on.")
	wait(500)
	UO.ExMsg(UO.CharID,3,20,"This is meant to pollinate same bright colors, or plains for mutations.")
	local flowers = item:scan():ground(0):z_axis(0,20):tp(flower_types):property()
	local next = next
	if next(flowers) == nil then	
		UO.ExMsg(UO.CharID,3,18,"You are not near any flowers.")
		return
	end
	local donor = flowers:pop()
        donor:use():waitContSize(263,231):wait(1000)
        Click.Gump(75, 75)
	for i=1,#flowers do
	    local flower =flowers:pop(i)
	    wait(250)
	    if flower.tp == donor.tp and flower.id ~= donor.id then
		Click.Gump(75,170)
		wait(500)
		flower:target()
		wait(500)
   	     end
	     if i == #flowers then
                 Click.CloseGump()
                 wait(500)
	   	 flower:use():waitContSize(263,231):wait(1000)
		 Click.Gump(75,75)
		 wait(500)
		 Click.Gump(75,170)
		 wait(500)
		 donor:target()
		 wait(500)
	     end
	end
	UO.ExMsg(UO.CharID,3,15,"Finished Pollinating")
	Click.CloseGump()
end


-------------------------------
----------GUI FUNCTIONS--------
-------------------------------
--loads a listbox with items (list of strings)
function loadListBox(listbox,items)
	listbox.ctrl.Clear()
	for i = 1, #items do
		listbox.ctrl.Items.Add(items[i])
        end
end


---------------------------------------------------------
---------------------------GUI---------------------------
---------------------------------------------------------
crossApp = menu:form(380,300,"Cross Pollination Helper")

---Parent A Gui Stuff---
parentA = nil
parentB = nil
scanAB = crossApp:button("scanA",10,10,150,20,"Scan Parent A")
parentAL = crossApp:label("parentAL",50,40,60,20,"Parent A Info")
plantALB = crossApp:listbox("plantA",10,60,150,60)
plantALB.ctrl.MultiSelect = false

scanAB:onclick(function()    
parentA = flower:scanPlant() 
if parentB == nil or parentA.id ~= parentB.id then
   plantAInfo = plantInfoString(parentA)
   loadListBox(plantALB,plantAInfo) 
end
end)

---Parent B Gui Stuff---
scanBB = crossApp:button("scanB",210,10,150,20,"Scan Parent B")
parentBL = crossApp:label("parentBL",250,40,60,20,"Parent B Info")
plantBLB = crossApp:listbox("plantB",210,60,150,60)
plantBLB.ctrl.MultiSelect = false

scanBB:onclick(function() 
parentB = flower:scanPlant() 
if parentA == nil or parentA.id ~= parentB.id then
   plantBInfo = plantInfoString(parentB)
   loadListBox(plantBLB,plantBInfo) 
else
    UO.ExMsg(UO.CharID,3,33, "Self Pollination will not result in mutations or different plants.")
end
end)

---Cross Gui stuff---
childrenL = crossApp:label("childrenL",100,140,100,20,"Possible Children From Cross Pollinating")
childrenLB = crossApp:listbox("children",30,160,310,60)
crossB = crossApp:button("cross",175,80,20,20,"X")

function formatChild(name,color,bee)
   return name.."    |    "..color.."    |    "..beeString(bee)
end       

function loadList(theLoad, toLoad)
   for i=1, #theLoad do
       table.insert(toLoad, theLoad[i])
       table.insert(toLoad, "-------")
   end     
   return toLoad
end                            
crossB:onclick(function()
if parentA ~= nil and parentB ~= nil then
   color = getChildColor(parentA, parentB)
   plant_id = getChildID(parentA, parentB)
   plant_type = getPlantType(plant_id)
   plant_name = getPlant(plant_type)
   bee_friendly = isBeeFriendly(plant_id)
   
   toLoad = {}
   if plant_id < -1 then
      childAStr = formatChild(parentA.plant_name,parentA.color,parentA.bee_friendly)
      childWAStr = formatChild(parentA.plant_name, "White (rare)",parentA.bee_friendly)
      childBAStr =  formatChild(parentA.plant_name,"Black (rare)",parentA.bee_friendly)
      childBStr = formatChild(parentB.plant_name,parentB.color,parentB.bee_friendly)
      childWBStr = formatChild(parentB.plant_name, "White (rare)",parentB.bee_friendly)
      childBBStr =  formatChild(parentB.plant_name,"Black (rare)",parentB.bee_friendly)  
      theLoad = {childAStr, childWAStr, childBAStr, childBStr, childWBStr, childBBStr}
      toLoad = loadList(theLoad, toLoad)                                                                 
   else
       childStr = formatChild(plant_name,color,bee_friendly)
       childWStr = formatChild(plant_name,"White (rare)",bee_friendly)
       childBStr = formatChild(plant_name,"Black (rare)",bee_friendly)
       theLoad = {childStr, childWStr, childBStr}
       toLoad = loadList(theLoad, toLoad)
   end
   loadListBox(childrenLB, toLoad)
else
    UO.ExMsg(UO.CharID,3,33,"You need to select to different plants.")
end
end)

--allCB = crossApp:checkbox("all",110,40,80,20,"Cross All")

crossApp:show()
Obj.Loop()
crossApp:free()
