-------------------------------------------------------------------
-----------------BULK ORDER DEED LIBRARY---------------------------
-------------------------------------------------------------------
-------------------------------------------------------------------
-------BODS ARE IDENTIFIED AS DEEDS IN YOUR BACKPACK
-------------------------------------------------------------------
-------------------------------------------------------------------
-------BOD IDENTIFYING FUNCTIONS
----
----bod:Caliber()  returns a string "Normal" or "Exceptional"
----
----bod:Resource(bod_type) returns a string containing resource type
--or an Error String If one was failed to be found.
----
----bod:Base() returns a number/string of 10,15,or 20 or error string
----
----bod:Item(deed) returns a list of item name - either {name} if its a small
--bod or {name1,name2..nameN} if its a large bulk order deed
----
----bod:Size(bod_type) returns a string denoting bod size
----
----bod:RewardValue(resource,base,size,caliber,bod_type) returns calculated reward value
----
----bod:RewardTier(value,bod_type) returns the tier/ranking of the reward to be returned
----
----bod:Reward(tier,bod_type) returns string listing bod reward
----
-------------------------------------------------------------------
-------------------------------------------------------------------
-------------------------------------------------------------------

dofile("itemlib.lua")
dofile("basiclib.lua")
dofile("craftlib.lua")

------Index represents Bodtype in all values listed
BOD_TYPES = {"Bowcraft","Blacksmith","Carpentry","Tailoring"}

--------------------------STATIC INFORMATION----------------
------------------------------------------------------------
-------------CRAFT GUMP LOCATIONS--------------------------
Craft_Gump = {
-------Bowcraft item Category & Index Values in craft gump
{
[3]={"Bow","Crossbow","Heavy Crossbow","Composite Bow",
"Repeating Crossbow","Yumi"}
},
-------Blacksmith item Category & Index Values in craft gump 
{
[1]={"Ringmail Gloves","Ringmail Leggings","Ringmail Sleeves","Ringmail Tunic"},
[2]={"Chainmail  Coif","Chainmail Leggings","Chainmail Tunic"},
[3]={"Platemail Arms","Platemail Gloves","Platemail Gorget","Platemail Legs","Platemail Tunic",
"Female Plate"},
[4]={"Bascinet","Close Helmet","Helmet","Norse Helm","Plate Helm"},
[6]={"Buckler ","Bronze Shield","Heater Shield","Metal Shield",
"Metal Kite Shield","Tear Kite Shield"},
[7]={"Bone Harvester","Broadsword","Crescent Blade","Cutlass","Dagger","Katana",
"Kryss","Longsword","Scimitar","Viking Sword"},
[9]={"Axe","Battle Axe","Double Axe","Executioner's Axe","Large Battle Axe",
"Two Handed Axe","War Axe"},
[10]={"Bardiche","Bladed Staff","Double Bladed Staff","Halberd","Lance","Pike",
"Short Spear","Scythe","Spear","War Fork"},
[11]={"Hammer Pick","Mace","Maul","Scepter","War Mace","War Hammer"}
},
-------Carpentry item Category & Index Values in craft gump
{
[3]={"Wooden Box","Small Crate","Crate","Large Crate","Wooden Chest","Wooden Shelf","Armoire [red]","Armoire","Plain Wooden Chest"},
[4]={"Shepherd's Crook","Quarter Staff","Gnarled Staff","Bokuto","Fukiya","Tetsubo"},
[5]={"Wooden Shield"},
[6]={"Lap Harp","Standing Harp","Drum","Lute","Tambourine","Tambourine [tassel]"}
},
-------Tailoring item Category & Index Values in craft gump
{
[1]={"Skullcap","Bandana","Floppy Hat","Cap","Wide-Brim Hat","Straw Hat",
"Tall Straw Hat","Wizard's Hat","Bonnet","Feathered Hat","Tricorne Hat",
"Jester Hat"},
[2]={"Doublet","Shirt","Fancy Shirt","Tunic","Surcoat","Plain Dress","Fancy Dress",
"Cloak","Robe","Jester Suit"},
[3]={"Short Pants","Long Pants","Kilt","Skirt"},
[4]={"Body Sash","Half Apron","Full Apron"},
[5]={"Elven Boots","Fur Boots","Ninja Tabi","Waraji and Tabi",
"Sandals","Shoes","Boots","Thigh Boots"},
[6]={"Spell Woven Britches","Song Woven Mantle","Stitcher's Mittens",
"Leather Gorget","Leather Cap","Leather Gloves","Leather Sleeves",
"Leather Leggings","Leather Tunic"},
[8]={"Studded Gorget","Studded Gloves","Studded Sleeves","Studded Leggings",
"Studded Tunic"},
[9]={"Leather Shorts","Leather Skirt","Leather Bustier","Studded Bustier",
"Female Leather Armor","Studded Armor"},
[10]={"Bone Helmet","Bone Gloves","Bone Arms","Bone Leggings","Bone Armor"}
}
}
-----------------------------------------------------------
-------------EXCEPTIONAL LISTS-----------------------------
Exceptional = {
-------Bowcraft exceptional values -- Exceptional[1]
{["Exceptional"]=200,["Normal"]=0},
-------Blacksmith exceptional values -- Exceptional[2]
{["Exceptional"]=200,["Normal"]=0},
-------Carpentry exceptional values -- Exceptional[3]
{["Exceptional"]=200,["Normal"]=0},
-------Tailoring exceptional values -- Exceptional[4]
{["Exceptional"]=100,["Normal"]=0}
}

-----------------------------------------------------------
-------------BASE LIST------------------------------------
Base = {["10"]=10,["15"]=25,["20"]=50}
-----------------------------------------------------------
-------------SIZE LISTS------------------------------------
Size = {
-------Bowcraft sizes -- Size[1]
{["Small Bod"]=0, ["3-piece"]=200,["6-piece"]=400},
-------Blacksmith sizes -- Size[2]
{["Small Bod"]=0,["Chainmail"]=300,["Ringmail"]=200,["Platemail"]=400},
-------Carpentry sizes -- Size[3]
{["Small Bod"]=0,["2-piece"]=50, ["3-piece"]=100,["4-piece"]=200,["5-piece"]=300,["6-piece"]=400},
-------Tailoring sizes -- Size[4]
{["Small Bod"]=0,["4-piece"]=300,["5-piece"]=400,["6-piece"]=500}
}

------------RESOURCE LISTS---------------------------------
Resource = {
-------Bowcraft resources -- Resource[1]
{["Natural Wood"]=0,["Pine Wood"]=200,
["Ash Wood"]=250,["Mohogany Wood"]=300,["Yew Wood"]=350,
["Oak Wood"]=400,["Zircote Wood"]=450,["Ebony Wood"]=500,
["Bamboo Wood"]=550,["Purple Heart"]=600,["Redwood Wood"]=650,
["Petrified Wood"]=700},
-------Blacksmith resources --Resource[2]
{["Iron Ingots"]=0,["Dull Copper"]=200,
["Shadow Iron"]=250,["Copper Ingots"]=300,["Bronze Ingots"]=350,
["Gold Ingots"]=400,["Agapite Ingots"]=450,["Verite Ingots"]=500,
["Valorite Ingots"]=550,["Blaze Ingots"]=600,["Ice Ingots"]=650,
["Toxic Ingots"]=700,["Electrum Ingots"]=750,["Platinum Ingots"]=800},
-------Carpentry resources --Resource[3]
{["Natural Wood"]=0,["Pine Wood"]=200,
["Ash Wood"]=250,["Mohogany Wood"]=300,["Yew Wood"]=350,
["Oak Wood"]=400,["Zircote Wood"]=450,["Ebony Wood"]=500,
["Bamboo Wood"]=550,["Purple Heart"]=600,["Redwood Wood"]=650,
["Petrified Wood"]=700},
-------Tailoring resources --Resource[4]
{["Cloth/Leather"]=0,["Spined Leather"]=50,
["Horned Leather"]=100,["Barbed Leather"]=150,["Polar Leather"]=200,
["Synthetic Leather"]=250,["Blaze Leather"]=300,["Daemonic Leather"]=350,
["Shadow Leather"]=400,["Frost Leather"]=450,["Ethereal Leather"]=500}
}

-------------Reward LIST-----------------------------------
Reward = { 
-------Bowcraft rewards --Reward[1]
{"Value < 50 : Undocumented Reward", "Sturdy Axe / Boards", "Garg Axe / Crafting Ar +1", "Prospector's Axe / Crafting Ar +1", "Stain of Durability / Crafting Ar +1", "Pine Runic / Deco Item", "Pine Runic / Deco Item", "Ash Runic / Deco Item", "Ash Runic / 5-use Dip Tub", "Mohogany Runic / 5-use Dip Tub", "Mohogany Runic / 120 Bowcraft PS", "Yew Runic / 120 LJ PS / Crafting Ar +3", "Yew Runic / +10 Hammer / Crafting Ar +3", "Oak Runic / +10 Hammer / Crafting Ar +3", "Oak Runic / +20 Hammer / 25-use Dip Tub", "Ebony Runic / +20 Hammer / 25-use Dip Tub", "Bamboo Runic / +30 Hammer", "Purple Heart Runic / +30 Hammer", "Redwood Runic / +40 Hammer", "Petrified Runic / +40 Hammer", "50-use Dip Tub / Crafting Ar +5"},
-------Blacksmith rewards --Reward[2]
{ "Sturdy Shovel / Sturdy Smith Hammer", "Sturdy Pickaxe / Sturdy Smith Hammer", "Sturdy Shovel / Crafting Ar +1", "Sturdy Pickaxe / Crafting Ar +1", "Prospector's Tool / Crafting Ar +1", "Fort Powder / Garg Pick / Deco Item", "Dull Copper Runic / Garg Pick / Deco Item", "Dull Copper Runic / Shadow Iron Runic", "Shadow Iron Runic / Colored Forge Deed", "Shadow Iron Runic / Colored Anvil Deed", "Copper Runic / Deco Item", "Copper Runic / Colored Anvil Deed", "Bronze Runic / Deco Item", "Hammer +10 / Crafting Ar +3", "arg Pick / Crafting Ar +3", "Hammer +15 / Crafting Ar +3/Gold Runic", "Gold Runic / Charged Dye Tub", "Hammer +30 / Charged Dye Tub", "Agapite Runic / Smither's Protector", "Hammer +60 / Smither's Protector", "Verite Runic / Crafting Ar +5", "Valorite Runic / Crafting Ar +5", "Blaze Runic / Crafting Ar +5", "Ice Runic / Bag of Resources", "Toxic Runic / Bag of Resources", "Electrum Runic / Sharpening Blade", "Platinum Runic / Sharpening Blade" },
------Carpentry rewards --Reward[3]
{"Value < 50 : Undocumented Reward", "Sturdy Axe / Boards", "Garg Axe / Crafting Ar +1", "Prospector's Axe / Crafting Ar +1", "Stain of Durability / Crafting Ar +1", "Pine Runic / Deco Item", "Pine Runic / Deco Item", "Ash Runic / Deco Item", "Ash Runic / Nails(?)", "Mohogany Runic / Nails(?)", "Mohogany Runic / 120 Carpentry PS", "Yew Runic / 120 LJ PS / Crafting Ar +3", "Yew Runic / +10 Hammer / Crafting Ar +3", "Oak Runic / Evil Deco Item / Crafting Ar +3", "Zircote Runic / +20 Hammer / Nails(?)", "Ebony Runic Saw / Evil Deco Item / Nails(?)", "Bamboo Runic / +30 Hammer", "Purple Heart Runic / Evil Deco Item", "Redwood Runic / +40 Hammer", "Petrified Runic / Evil Deco Item", "Bag of Resources / Crafting Ar +5" },
------Tailoring rewards --Reward[4]
{ "Cloth 1 / Colored Loom", "Cloth 2 / Colored Loom", "Cloth 3 / Leather", "Cloth 4 / Leather / Crafting Ar +1", "Cloth 5 / Leather / Crafting Ar +1", "Stretched Hide / Colored Scissors / Crafting Ar +1", "Spined Runic / Colored Scissors ", "Tapestry / Colored Scissors / Sturdy Sewing Kit", "Bear Rug / Sturdy Sewing Kit", "Deco Item / Master's Knife", "Clothing Bless Deed / Deco Item / Master's Knife", "Horned Runic / Master's Knife", "Horned Runic / Crafting Ar +3", "Barbed Runic / Crafting Ar +3", "Barbed Runic / Crafting Ar +3 / Garg Knife", "Polar Runic / Charged Dye Tub / Garg Knife", "Polar Runic / Charged Dye Tub", "Synthetic Runic / Crafting Ar +5", "Blaze Runic / Crafting Ar +5", "Daemonic Runic / Tailor's Protector / Crafting Ar +5", "Shadow Runic / Tailor's Protector", "Frost Runic / Bag of Resources", "Ethereal Runic / Bag of Resources" }
 }
------------Reward Range LIST------------------------------
Reward_Range = {
------Bowcraft rewards range --Reward_Range[1]
{0, 50, 200, 400, 450, 500, 550,600, 650, 700, 750, 800, 850, 900, 950, 1000, 1050, 1100, 1150, 1200, 1250},
------Blacksmith rewards range --Reward_Range[2]
{0, 25, 50, 200, 400, 450, 500, 550, 600, 625, 650, 675, 700, 750, 800, 850, 925, 1000, 1050, 1100, 1150, 1200, 1250, 1300, 1350, 1400, 1450},
------Carpentry rewards range --Reward_Range[3]
{0, 50, 200, 400, 450, 500, 550, 600, 650, 700, 750, 800, 850, 900, 950, 1000, 1050, 1100, 1150, 1200, 1250},
------Tailoring rewards range --Reward_Range[4]
{0, 50, 100, 150, 200, 300, 350, 400, 450, 500, 550, 600, 650, 700, 750, 800, 850, 900, 950, 1000, 1050, 1100, 1150}
}
------------------------------------------------------------
-------------SOLUTION TO DYNAMICALLY FINDING BOD TYPE-------
------------------------------------------------------------
Bowcraft_Items ={"Bow","Crossbow","Composite Bow","Heavy Crossbow","Repeating Crossbow","Yumi"}
Carpentry_Items = {'Wooden Chest' ,'Tetsubo' ,'Crate' ,'Drum' ,'Wooden Box' ,'Small Crate' ,'Bokuto',
'Wooden Shield',"Plain Wooden Chest",'Standing Harp' ,'Tambourine' ,'Lap Harp' ,'Lute' ,'Quarter Staff' , 'Gnarled Staff' }
Blacksmith_Items = {"Heater Shield","Platemail Arms" ,"Platemail Legs" ,"Plate Helm" ,"Platemail Gorget" ,"Platemail Gloves" ,
"Female Plate","Platemail Tunic" ,"Longsword" ,"Mace" ,"War Fork" ,"Battle Axe" ,"War Mace" ,"Maul" ,"Helmet" ,"Norse Helm" ,
"Bronze Shield" ,"Broadsword" ,"Bascinet" ,"Double Axe" ,"War Axe" ,"Katana" ,"Viking Sword" , "Short Spear" ,"Bardiche" ,
 "Close Helmet","Two Handed Axe" ,"Spear" ,"Executioner's Axe" ,"Hammer Pick" ,"Axe" ,"Metal Kite Shield" ,"Cutlass" ,
 "Halberd" ,"Scimitar" ,"Kryss" ,"Buckler " ,"Large Battle Axe" ,"Chainmail  Coif" ,"Chainmail Leggings" ,"Chainmail Tunic" ,
 "Ringmail Gloves" ,"Ringmail Tunic" ,"Ringmail Sleeves" , "Ringmail Leggings","War Hammer","Metal Shield"}

------------------------------------------------------------
----------------ITEMS IN LARGE BODS-------------------------
LgItems={
------Bowcraft items that fit into large bods --LgItems[1]
{{"Bow","Crossbow","Composite Bow","Heavy Crossbow","Repeating Crossbow","Yumi"},
{"Bow","Yumi","Composite Bow"},
{"Heavy Crossbow","Repeating Crossbow","Crossbow"}},
------Blacksmith items that fit into large bods --LgItems[2]
{{"Chainmail  Coif","Chainmail Leggings","Chainmail Tunic"},
{"Ringmail Gloves","Ringmail Tunic","Ringmail Sleeves","Ringmail Leggings"},
{"Platemail Arms","Plate Helm","Platemail Legs","Platemail Gorget","Platemail Gloves","Platemail Tunic"}},
------Carptentry items that fit into large bods --LgItems[3]
{{"Wooden Shield","Bokuto","Tetsubo"},
{"Drum","Tambourine","Tambourine[Tassel]"},
{"Lap Harp","Standing Harp","Drum","Lute","Tambourine","Tambourine[Tassel]"},
{"Quarter Staff","Gnarled Staff"},
{"Wooden Box","Small Crate","Medium Crate","Crate","Wooden Chest","Plain Wooden Chest"}},
------Tailoring items that fit into large bods --LgItems[4]
{{"Bone Helmet","Bone Gloves","Bone Arms","Bone Leggings","Bone Armor"},
{"Straw Hat","Tunic","Long Pants","Boots"},
{"Leather Skirt","Leather Bustier","Leather Shorts","Female Leather Armor","Studded Armor","Studded Bustier"},
{"Floppy Hat", "Full Apron","Plain Dress" , "Sandals"},
{"Bandana","Shirt","Skirt","Thigh Boots"}, 
{"Tricorne Hat", "Cap","Wide Brim Hat","Tall Straw Hat"},
{"Jester Hat","Jester Suit","Cloak","Shoes"},
{"Bonnet","Half Apron","Fancy Dress","Sandals"},
{"Leather Gorget","Leather Cap","Leather Gloves","Leather Sleeves","Leather Leggings","Leather Tunic"},
{"Studded Gorget","Studded Gloves","Studded Sleeves","Studded Leggings","Studded Tunic"},
{"Boots","Thigh Boots","Shoes","Sandals"},
{"Skullcap","Doublet","Kilt","Shoes"},
{"Feathered Hat","Surcoat","Fancy Shirt","Short Pants","Thigh Boots"},
{"Wizard's Hat","Body Sash","Robe","Boots"}}
}

BodSizes = {
{"Small Bod","3-Piece","6-Piece"},
{"Small Bod","Chainmail","Ringmail","Platemail"},
{"Small Bod","2-Piece","3-Piece","6-Piece"},
{"Small Bod","4-Piece","5-Piece","6-Piece"}
}

BodResource = {
-------Bowcraft resources -- Resource1]
{"Natural Wood","Pine Wood",
"Ash Wood","Mohogany Wood","Yew Wood",
"Oak Wood","Zircote Wood","Ebony Wood",
"Bamboo Wood","Purple Heart","Redwood Wood",
"Petrified Wood"},
-------Blacksmith resources --Resource2
{"Iron Ingots","Dull Copper",
"Shadow Iron","Copper Ingots","Bronze Ingots",
"Gold Ingots","Agapite Ingots","Verite Ingots",
"Valorite Ingots","Blaze Ingots","Ice Ingots",
"Toxic Ingots","Electrum Ingots","Platinum Ingots"},
-------Carpentry resources --Resource3
{"Natural Wood","Pine Wood",
"Ash Wood","Mohogany Wood","Yew Wood",
"Oak Wood","Zircote Wood","Ebony Wood",
"Bamboo Wood","Purple Heart","Redwood Wood",
"Petrified Wood"},
-------Tailoring resources --Resource4
{"Cloth/Leather","Spined Leather",
"Horned Leather","Barbed Leather","Polar Leather",
"Synthetic Leather","Blaze Leather","Daemonic Leather",
"Shadow Leather","Frost Leather","Ethereal Leather"}
}

------------------------------------------------------------
------------------------------------------------------------
------------------------------------------------------------	
bods = {}
bods_meta = {__index = bods}

bod = {}
bod_meta = {__index = bod}

bod_books = {}
bod_books_meta = {__index = bod_books}

function bods:scan()
    local bods = item:scan():cont(UO.BackpackID):tp(8792):property():name("A Bulk Order Deed")
    setmetatable(bods,bods_meta)
    if next(bods) ~= nil then
	return bods
    end
    return false
end

function bods:pop(i)
  	i = i or 1
    local b = self[i]
    setmetatable(b,bod_meta)
	b["bod_type"] = b:BodType()
	b["items"] = b:Items()
	b["size"] = b:Size()
	b["caliber"] = b:Caliber()
	b["base"] = b:Base()
	b["resource"] = b:Resource()
	b["largeFits"] = b:LargeFitting()
	b["value"] = b:RewardValue()
	b["tier"] = b:RewardTier()
	b["reward"] =  b:Reward()
    return b
end

function bod:scan(bod_index,book_name,scan)
    bod_index = bod_index or 0
    book_name = book_name or ""
    local bods = item:scan():cont(UO.BackpackID):tp(8792):property():name("A Bulk Order Deed")
    if next(bods) ~= nil then
	local b = bods:pop(i)
	b["bod_index"] = bod_index
	b["book_name"] = book_name	
	setmetatable(b,bod_meta)	
	--b:ExMsgAll()
	--wait(2000)
	--b:ExCrossRef()
    	return b
    end
    return false
end

---Does a bod
function bod:Do()
	if self.size ~= "Small Bod" then
		errorMsg("This is not a small bod.")
   		return false
	end
        if self:Complete() then
	   errorMsg("This Bod was already completed")
	   return false
         end
	local resource_index = 0
	for k,v in pairs(Resource[self.bod_type]) do 
    		if k == self.resource then
       			local myVal = v
       			for k,v in pairs(Resource[self.bod_type]) do
           			if k ~= self.resource and myVal > v then
              				resource_index = resource_index + 1
           			end
       			end
    		end
	end
	resource_index = resource_index + 1   

	local index = self:craftIndex()
	local category = self:craftCategory()

	if index == nil or category == nil then
   		errorMsg("Error setting item index for crafting gump")
	   	return false
	end         

	local profession = self:getProfession()

	if self.caliber == "Exceptional" then
   		Craft.MakeExc(profession,category,index,resource_index,self.base)
	else
    		Craft.Make(profession,category,index,resource_index,self.base)
	end

	local toAdd = item:scan():cont(UO.BackpackID):tp(Craft.LastItemType)
	if next(toAdd) == nil then
   		errorMsg("Failed to add items/Missing Materials")
	   	return false
	end


	UO.LObjectID = self.id
	UO.Macro(17,0)
	wait(750)
	Click.Gump(105,200)
	wait(1000)

	for i = 1, #toAdd do
    		toAdd:pop(i):target()
    		wait(1500)
	end
	Click.CloseGump()
	return self
end




----Crafting Related functions 
function bod:craftCategory()
	for k,v in pairs(Craft_Gump[self.bod_type]) do
		for i = 1, #v do
			if v[i] == self.items[1] then
				return k
			end
		end
	end
end

function bod:craftIndex()
	for k,v in pairs(Craft_Gump[self.bod_type]) do
		for i = 1, #v do
			if v[i] == self.items[1] then
				return i
			end
		end
	end
end

function bod:getProfession()
	if self.bod_type == 1 then return "bowyer"
	elseif self.bod_type == 2 then return "smith"
	elseif self.bod_type == 3 then return "carpenter"
	else return "tailor" end
end

function bod:BodType()
	local items = self:Items()
	local next = next
	if next(items) == nil then 
		UO.ExMsg(UO.CharID,3,33,"Could not get type- stopping script")
		stop()
	end
	local toCheck = items[1] --only need to find one item
	for i=1,#Bowcraft_Items do
		if toCheck == Bowcraft_Items[i] then
			return 1
		end
	end
	for i=1,#Blacksmith_Items do
		if toCheck == Blacksmith_Items[i] then
			return 2
		end
	end
	for i=1,#Carpentry_Items do
		if toCheck == Carpentry_Items[i] then
			return 3
		end
	end
	return 4
end
	

function bod:Caliber()
	s,e = string.find(self.stats,"All Items Must Be Exceptional")
	if s == nil then
		return "Normal"
	else
		return "Exceptional"
	end
end

function bod:Resource()
	s,e,resource = string.find(self.stats,"All Items Must Be Crafted With (%a+%s?%a+)")
	if resource == nil then	
		if self.bod_type == 2 then return "Iron Ingots" 
		elseif self.bod_type ==1 or self.bod_type == 3 then
			return "Natural Wood"
		elseif self.bod_type==4 then
			return "Cloth/Leather"
		end
	end
	return resource
end

function bod:Items()
	smDeeds = {}
	for piece,amt in string.gmatch(self.stats,"(%a+%p?%a*%s*%a*%s?%a*): (%d+)") do
     		if piece ~= "Amount To Make" then
       			table.insert(smDeeds, piece)	
    		end
	end
	return smDeeds
end

function bod:ItemsValues()
	values = {}
	for piece,amt in string.gmatch(self.stats,"(%a+%p?%a*%s*%a*%s?%a*): (%d+)") do
     		if piece ~= "Amount To Make" then
       			table.insert(values, amt)	
    		end
	end
	return values
end

function bod:Update()
	self["complete"] = self:Complete()
end

function bod:Complete()
	smDeeds = {}
	for piece,amt in string.gmatch(self.stats,"(%a+%p?%a*%s*%a*%s?%a*): (%d+)") do
     		if piece ~= "Amount To Make" then
       			if amt ~= self.base then return false end
    		end
	end
	return true
end

function bod:Base()
	s,e,base = string.find(self.stats,"Amount To %a+: (%d+)")
	if base == nil then
		UO.ExMsg(UO.CharID,3,33,"Couldn't Grab Base")
		return "Error - didn't get a base number"
	end
	return base
end

function bod:Size()
	count = 0
	for piece,amt in string.gmatch(self.stats,"(%a+%p?%a*%s*%a*%s?%a*): (%d+)") do
     		if piece ~= "Amount To Make" then
       			count = count + 1
    		end
	end
	if count == 1 then
   		return "Small Bod"
	else
		if self.bod_type ~= 2 then
   			return string.format("%d-piece",count)
		else
			if count == 6 then return "Platemail" 
			elseif count == 4 then return "Ringmail"
			else return "Chainmail" end
		end					
	end
end

function bod:LargeFitting()
	local lgItems = LgItems[self.bod_type]
	if #self.items > 1 or self.size ~= "Small Bod" then
		return true
	end
	local a = {}
	for i=1,#lgItems do
		lgBod = lgItems[i]
		for i=1,#lgBod do
			---must be small only 1 item
			if self.items[1] == lgBod[i] then
				table.insert(a,lgBod)
			end
		end
	end
	if next(a) ~= nil then
		return a
	end
	return false
end

function bod:ExMsgBod()
	size = self.size
	base = self.base
	resource = self.resource
	caliber = self.caliber
	if not self.largeFits then
		standAlone = "--Stands Alone"
	else
		standAlone = ""
	end
--	UO.Macro(1,0,string.format("%s: %s %s [%s]%s",size,resource,base,caliber,standAlone))
	UO.ExMsg(UO.CharID, 3, 40,string.format("%s: %s %s [%s]%s",size,resource,base,caliber,standAlone))
end

function bod:ExCrossRef()
	if self.size == "Small Bod" and self.largeFits then
		UO.ExMsg(UO.CharID,3,65,"Cross-Referencing....")
		for i = 1, #self.largeFits do
			if self.bod_type ~= 2 then
				local a = {}
				setmetatable(a,bod_meta)
				a["base"] = self.base
				a["size"] = string.format("%d-piece",#self.largeFits[i])
				a["bod_type"] = self.bod_type
				a["largeFits"] = true
				a["caliber"] = self.caliber
				a["resource"] = self.resource
				a["value"] = a:RewardValue()
				a["tier"] = a:RewardTier()
				a["reward"] = a:Reward()
				a:ExMsgAll()
				wait(3000)
				UO.ExMsg(UO.CharID,3,65,"--------------------")
			elseif self.bod_type == 2 then
				local a = {}
				setmetatable(a,bod_meta)
				a["base"] = self.base
				armor_type = ""
				if #self.largeFits[i] == 3 then armor_type = "Chainmail"
				elseif #self.largeFits[i] == 4 then armor_type = "Ringmail"
				else armor_type = "Platemail" end
				if armor_type == "" then 
					UO.ExMsg(UO.CharID,3,33,"Error cross referencing")
					return
				end
				a["size"] = armor_type
				a["bod_type"] = self.bod_type
				a["largeFits"] = true
				a["caliber"] = self.caliber
				a["resource"] = self.resource
				a["value"] = a:RewardValue()
				a["tier"] = a:RewardTier()
				a["reward"] = a:Reward()
				a:ExMsgAll()
				wait(3000)
				UO.ExMsg(UO.CharID,3,65,"--------------------")
			end
	end
	end
end
	

function bod:RewardValue()
	local baseVal = Base[self.base]
	local sizeVal = Size[self.bod_type][self.size]
	local exceptionalVal = Exceptional[self.bod_type][self.caliber]
	local resourceVal = Resource[self.bod_type][self.resource]
	return baseVal + sizeVal + exceptionalVal + resourceVal
end

function bod:RewardTier()
	toReturn = -1
	local b_tp = self.bod_type
	reward_range = Reward_Range[b_tp]
	for i = 1, #reward_range do
		if i == #reward_range then return i end
		if self.value >= reward_range[i] and self.value < reward_range[i+1] then
			return i
		end
	end
	return toReturn
end

function bod:Reward()
	return Reward[self.bod_type][self.tier]
end

function bod:ExMsgReward()
--	UO.Macro(1,0,string.format("%d - %s",self.value, self.reward))
	UO.ExMsg(UO.CharID, 3, 50,string.format("%d - %s",self.value, self.reward))
end

function bod:ExMsgAll()
	self:ExMsgBod()
	self:ExMsgReward()
end

function bod:compare(otherBod)
	nameA, nameB = self.name, otherBod.name
	baseA, baseB = self.base, otherBod.base
	expA, expB = self.caliber, otherBod.caliber
	resourceA, resourceB = self.resource, otherBod.resource
	if nameA == nameB and baseA == baseB and expA == expB and resourceA == resourceB then 
		return true
	end
	return false
end

function bod:SubBod(smBod)
	if self.size == "Small Bod" or smBod.size ~= "Small Bod" then
		return false
	end
	if self.base == smBod.base and self.resource == smBod.resource then
		if self.caliber == "Normal" or self.caliber == smBod.caliber then
			return true
		end
	end
end

--------------------------------------------------------------
-----------------------BOD BOOK FUNCTIONS---------------------
function bod_books:scan()
    local books = item:scan():cont(UO.BackpackID):tp(8793):property():name("Bulk Order Book")
    setmetatable(books,bod_books_meta)
    if next(books) == nil then
	    UO.ExMsg(UO.CharID,3,33,"There are no BOD books in your main pack.")
        return books
    end
    return books
end

function bod_books:book_names()
    a = {}
    for i = 1, #self do
        s,e,name = string.find(self[i].stats,"Book Name: (%a+%s?%a+)")
	    if name ~= nil then 
            self[i].book_name = name
	    else 
            self[i].book_name = "Unnamed"
        end
        table.insert(a,self[i].book_name)
    end
    return a
end


function bod_books:scanBooks()
    local bod_books = item:scan():cont(UO.BackpackID):tp(8793):property():name("Bulk Order Book")
    local next = next
    if next(bod_books) == nil then
	UO.ExMsg(UO.CharID,3,33,"There are no BOD books in your main pack.")
    end
    local deeds = {}	
    for i = 1,#bod_books do 
	book = bod_books:pop(i)
	s,e,count = string.find(book.stats,"Deeds In Book: (%d+)")
	if count == 0 then
		UO.ExMsg(UO.CharID,3,33,"There are no deeds in your book of small bods")
		stop()
	end
	s,e,name = string.find(book.stats,"Book Name: (%a+%s?%a+)")
	if name ~= nil then
		book["book_name"] = name
	end
	for i=1, count do
		book:use():waitContSize(615,454)
		Click.Gump(40,105)
		wait(1000)
		b = bod:scanBod(i,name)
		table.insert(deeds, b)
		if not b.standAlone then
    			UO.Drag(b.id,b.stack)
    			UO.DropC(book.id)
			wait(1000)
		end
	end
    end
    setmetatable(deeds,bod_books_meta)
    return deeds
end

function bods:tier(nTier)
    local a = {} 
    if type(nTier) ~= "table" then
        nTier = {nTier}
    end
    
    for i = 1,#self do
        for j = 1,#nTier do
            if self[i].tier == nTier[j] then
                table.insert(a,self[i])
    
            end
        end
    end
    
    setmetatable(a,bods_meta)

    return a
end

function bods:size(nSize,keep)
    keep = keep or true
    local a = {} 
    if type(nSize) ~= "table" then
        nSize = {nSize}
    end   
    for i = 1,#self do
	if keep then
		if contains(nSize, self[i].size) then
			table.insert(a,self[i])
		end
	else
		if not contains(nSize, self[i].size) then
                	table.insert(a,self[i])
       	 	end
	end
    end
    
    setmetatable(a,bod_books_meta)
    return a
end

function bods:bod_tp(nType)
    local a = {}
    
    if type(nType) ~= "table" then
        nType = {nType}
    end
    
    for i = 1,#self do
        for j = 1,#nType do
            if self[i].tp == nType[j] then
                table.insert(a,self[i])
            end
        end
    end
    
    setmetatable(a,bod_books_meta)
    return a
end

function bods_setmetatable(theList)
	setmetatable(theList,bod_books_meta)
end

function contains(theList, theItem)
	local next = next
	if next(theList) == nil then
		return false
		--empty list
	end
	for i=1, #theList do
		if type(theList[i]) == "table" then
			 return theList[i]:compare(theItem)
		else
			return theList[i] == them
		end
	end
	return false
end
