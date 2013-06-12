
------Index represents Bodtype in all values listed
BOD_TYPES = {"Bowcraft","Blacksmith","Carpentry","Tailoring"}

--------------------------STATIC INFORMATION----------------
------------------------------------------------------------
-------------CRAFT GUMP LOCATIONS--------------------------
CRAFT_GUMP = {
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
{"Bods value is less than 50 : not documented on wiki", "[75/25] Sturdy Axe / Boards", "[75/25] Garg Axe / Crafting Armor +1", "[66/33] Prospector's Axe / Crafting Armor +1", "[50/50] Stain of Durability / Crafting Armor +1", "[75/25] Pine Runic / Deco Item", "[66/33] Pine Runic / Deco Item", "[50/50] Ash Runic / Deco Item", "[66/33] Ash Runic / 5-use Dip Tub", "[50/50] Mohogany Runic / 5-use Dip Tub", "[50/50] Mohogany Runic / 120 Bowcraft PS", "[33/33/33] Yew Runic / 120 LJ PS / Crafting Armor +3", "[33/33/33] Yew Runic / +10 Ancient Hammer / Crafting Armor +3", "[33/33/33] Oak Runic / +10 Ancient Hammer / Crafting Armor +3", "[33/33/33] Oak Runic / +20 Ancient Hammer / 25-use Dip Tub", "[33/33/33] Ebony Runic / +20 Ancient Hammer / 25-use Dip Tub", "[50/50] Bamboo Runic / +30 Ancient Hammer", "[50/50] Purple Heart Runic / +30 Ancient Hamer", "[50/50] Redwood Runic / +40 Ancient Hammer", "[50/50] Petrified Runic / +40 Ancient Hammer", "[50/50] 50-use Dip Tub / Crafting Armor +5"},
-------Blacksmith rewards --Reward[2]
{ "[50/50] Sturdy Shovel / Sturdy Smith Hammer", "[50/50] Sturdy Pickaxe / Sturdy Smith Hammer", "[90/10] Sturdy Shovel / Crafting Armor +1", "[90/10] Sturdy Pickaxe / Crafting Armor +1", "[90/10] Prospector's Tool / Crafting Armor +1", "[50/25/25] Fort Powder / Garg Pick / Deco Item", "[33/33/33] Dull Copper Runic / Garg Pick / Deco Item", "[60/40] Dull Copper Runic / Shadow Iron Runic", "[50/50] Shadow Iron Runic / Colored Forge Deed", "[75/25] Shadow Iron Runic / Colored Anvil Deed", "[50/50] Copper Runic / Deco Item", "[75/25] Copper Runic / Colored Anvil Deed", "[50/50] Bronze Runic / Deco Item", "[50/50] Ancient Smithy Hammer +10 / Crafting Armor +3", "[50/50] Garg Pick / Crafting Armor +3", "[?] Ancient Smithy Hammer +15 / Crafting Armor +3/Gold Runic", "[50/50] Gold Runic / Charged Dye Tub", "[50/50] Ancient Smithy Hammer +30 / Charged Dye Tub", "[50/50] Agapite Runic / Smither's Protector", "[50/50] Ancient Smith Hammer +60 / Smither's Protector", "[50/50] Verite Runic / Crafting Armor +5", "[50/50] Valorite Runic / Crafting Armor +5", "[50/50] Blaze Runic / Crafting Armor +5", "[50/50] Ice Runic / Bag of Resources", "[50/50] Toxic Runic / Bag of Resources", "[50/50] Electrum Runic / Sharpening Blade", "[50/50] Platinum Runic / Sharpening Blade" },
------Carpentry rewards --Reward[3]
{ "Bod value is less than 50 : not documented on wiki", "[75/25] Sturdy Axe / Boards", "[75/25] Garg Axe / Crafting Armor +1", "[66/33] Prospector's Axe / Crafting Armor +1", "[50/50] Stain of Durability / Crafting Armor +1", "[75/25] Pine Runic / Deco Item", "[66/33] Pine Runic / Deco Item", "[50/50] Ash Runic / Deco Item", "[66/33] Ash Runic / Nails(?)", "[50/50] Mohogany Runic / Nails(?)", "[50/50] Mohogany Runic / 120 Carpentry PS", "[33/33/33] Yew Runic / 120 LJ PS / Crafting Armor +3", "[33/33/33] Yew Runic / +10 Ancient Hammer / Crafting Armor +3", "[33/33/33] Oak Runic / Evil Deco Item / Crafting Armor +3", "[33/33/33] Zircote Runic / +20 Ancient Hammer / Nails(?)", "[33/33/33] Ebony Runic Saw / Evil Deco Item / Nails(?)", "[50/50] Bamboo Runic / +30 Ancient Hammer", "[50/50] Purple Heart Runic / Evil Deco Item", "[50/50] Redwood Runic / +40 Ancient Hammer", "[50/50] Petrified Runic / Evil Deco Item", "[50/50] Bag of Resources / Crafting Armor +5" },
------Tailoring rewards --Reward[4]
{ "[50/50] Cloth 1 / Colored Loom", "[50/50] Cloth 2 / Colored Loom", "[50/50] Cloth 3 / Leather", "[60/30/10] Cloth 4 / Leather / Crafting Armor +1", "[40/40/20] Cloth 5 / Leather / Crafting Armor +1", "[33/33/33] Stretched Hide / Colored Scissors / Crafting Armor +1", "[50/50] Spined Runic / Colored Scissors ", "[60/20/20] Tapestry / Colored Scissors / Sturdy Sewing Kit", "[50/50] Bear Rug / Sturdy Sewing Kit", "[50/50] Deco Item / Master's Knife", "[33/33/33] Clothing Bless Deed / Deco Item / Master's Knife", "[50/50] Horned Runic / Master's Knife", "[50/50] Horned Runic / Crafting Armor +3", "[50/50] Barbed Runic / Crafting Armor +3", "[33/33/33] Barbed Runic / Crafting Armor +3 / Garg Knife", "[33/33/33] Polar Runic / Charged Dye Tub / Garg Knife", "[50/50] Polar Runic / Charged Dye Tub", "[50/50] Synthetic Runic / Crafting Armor +5", "[50/50] Blaze Runic / Crafting Armor +5", "[33/33/33] Daemonic Runic / Tailor's Protector / Crafting Armor +5", "[50/50] Shadow Runic / Tailor's Protector", "[50/50] Frost Runic / Bag of Resources", "[50/50] Ethereal Runic / Bag of Resources" }
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
Crafting_Items = {
------Bowcraft Crafting Items --Crafting_Items[1]
{"Bow","Crossbow","Composite Bow","Heavy Crossbow","Repeating Crossbow","Yumi"},
------Blacksmith Crafting Items --Crafting_Items[2]
{"Heater Shield","Platemail Arms" ,"Platemail Legs" ,"Plate Helm" ,"Platemail Gorget" ,"Platemail Gloves" ,
"Female Plate","Platemail Tunic" ,"Longsword" ,"Mace" ,"War Fork" ,"Battle Axe" ,"War Mace" ,"Maul" ,"Helmet" ,"Norse Helm" ,
"Bronze Shield" ,"Broadsword" ,"Bascinet" ,"Double Axe" ,"War Axe" ,"Katana" ,"Viking Sword" , "Short Spear" ,"Bardiche" ,
 "Close Helmet","Two Handed Axe" ,"Spear" ,"Executioner's Axe" ,"Hammer Pick" ,"Axe" ,"Metal Kite Shield" ,"Cutlass" ,
 "Halberd" ,"Scimitar" ,"Kryss" ,"Buckler " ,"Large Battle Axe" ,"Chainmail  Coif" ,"Chainmail Leggings" ,"Chainmail Tunic" ,
 "Ringmail Gloves" ,"Ringmail Tunic" ,"Ringmail Sleeves" , "Ringmail Leggings","War Hammer","Metal Shield"},
 ------Carpentry Crafting Items --Crafting_Items[3]
 {'Wooden Chest' ,'Tetsubo' ,'Crate' ,'Drum' ,'Wooden Box' ,'Small Crate' ,'Bokuto',
'Wooden Shield',"Plain Wooden Chest",'Standing Harp' ,'Tambourine' ,'Lap Harp' ,'Lute' ,'Quarter Staff' , 'Gnarled Staff' }
}
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