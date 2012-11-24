--==================================
-- Script Name: Storage Library
-- Author: McHale
-- Version: 1.0
-- OpenEUO version tested with: 0.91
-- Purpose: Common Functions to Store Items
--==================================

dofile("../Lib/itemlib.lua")
dofile("../Lib/functions.lua")

-------------------------TODO--------------------------
-- Finish adding tailoring types
-- Add bag of holding to list of storage names[dont have one]
-- Amend searching backpack to recursively check all containers
-- Perhaps add grab resources functionality?
-- Only checks main backpack

---------------------Storage Library--------------------

Storage = {}
local S = Storage
local next = next

--------------------------------------------------------
-------------------Gump Variables-----------------------
--Gump Sizes
local sizeX = 505
local sizeY = {475,270,440,270,295,325,365}
---Runic house has just gotta be different
local rSizeX,rSizeY = 725,370
local rAddX,rAddY = 555,315
--Adding Items offset from gump
local addOffsetX = 290
local addOffsetY = {435,235,410,235,260,290,340}
--TO DO - offsets for grabbing resources

--------------------------------------------------------
----------Storage Container Key Name List---------------

---The Index corresponds with the gump variables
S.storage_names = {"Spell Caster's Keys","Metal Worker's Keys",
	"Tailor's Keys","Stone Worker's Keys","Wood Worker's Keys",
	"Gem Pouch","Tool House", "Runic House","A Bag Of Sending","Huge Bag Of Holding"}

local container_types = {5995,3705,3702,8900,2482}

--------------------------------------------------------
-----------------Master Storage Type Lists--------------
----Spell Caster Item Types
local sc_types = {3962,3963,3972,3973,3974,3976,3980,3981,3960,3983,
	3965,3982,3978,3969,9911,9912,3966,3968,3827,3854,5154,
	3620,2426,3615,7956,4586,6464,5995}
----Metal Worker Item Types
local mw_types = {7154}
----Stone Worker Item Types
local sw_types = {6009}
----Wood Worker Item Types
-------3903, 7163 are arrows and bolts secondary list to not include those 2
local ww_types = {7127,7121,7133,3903,7163,7124}
local ww2_types = {7127, 7121, 7133, 7124}
----still need to include tailor keys items!!!!
local tk_types = {4225,9908,3576}
----Gem Item Types
local gem_types = {3885,3878,3859,3865,3873,3862,3856,7847,
	3861,3877,12693,12695,12697,12692,12696,12690,12691,12694}
----Tool House Item Types
----taming brush, glassblowing, taxidermy kit
local tool_types = {3997, 3739, 4031, 4787, 4148, 4326, 4325, 4327,4136,
4130, 7864, 4027, 5092, 3897, 3718, 4020, 3908, 3907, 2431, 3909, 5110}
----Runic Item Types
local runic_types = {7864, 5091, 3997, 4130, 4148}


--------------------------------------------------------
-------------------FUNCTIONS TO USE---------------------
------------------STORING BY CONTAINER------------------
function S.storeSpell()
	store(1, {3962,3963,3972,3973,3974,3976,3980,3981,3960,3983,
		3965,3982,3978,3969,9911,9912,3966,3968,3827,3854,5154,
		3620,2426,3615,7956,4586,6464})
end

function S.storeMetal()
	store(2, mw_types)
end

function S.storeTailor()
	store(3,tk_types)
end

function S.storeStone()
	store(4, sw_types)
end

function S.storeWood()
	store(5,ww2_types)
end

function S.storeGems()
	store(6,gem_types)
end

function S.storeTools()
	store(7,tool_types)
end

function S.storeRunics()
	store(8,runic_types)
end

function S.storeAll()
	S.storeRunics()
	S.storeTools()
	S.storeGems()
	S.storeWood()
	S.storeStone()
	S.storeTailor()
	s.storeMetal()
	s.storeSpell()
end
---------------------------------------------------------
-----------------STORING GOLD----------------------------
--Store Gold in Bank with Bag of Sending
function S.storeGoldBOS()
	local bos = S.getStorageContainer(9)
	local gold_targets = S.getStorageTargets(3821)
	local next = next
	if next(gold_targets) == nil then
		return
	end
	---retrieving the first element[usually only the only element]
	local gold = gold_targets:pop()
	UO.LObjectID = bos.id
	bos:use():waitTarget():target(gold.id)
end

---bag of holding store gold functions etc...
function S.storeGoldBOH()
	local next = next
	--BOH info tends to be delayed by server, so scan for it using backwards bp type
	---This will only work if you don't have your trashbag in the mainpack
	---As it also has a backwards bp type as well
	local boh = item:scan():cont(UO.BackpackID):tp(2482)
	if next(boh) == nil then
		UO.ExMsg(UO.CharID,3,33,"You don't have a BOH")
		return
	end
	boh = boh:pop()
	---3821 is target type for gold
	local gold_targets = S.getStorageTargets(3821)
	if next(gold_targets) == nil then
		return
	end
	---Penny's lib always returns lists - so just
	---get the first element
	local gold = gold_targets:pop()
	---this is in jack penny's item library.
	gold:drop(boh.id)
end


------------------------------------------------------------------
--------------Grabbing Storage & Target IDs-----------------------
-----Currently Assumes Everything is being held in main pack------

function S.getStorageContainer(storage_index)
    local container = S.storage_names[storage_index]
    local my_containers = item:scan():cont(UO.BackpackID):tp(container_types):property():name(container)
    if next(my_containers) == nil then
	UO.ExMsg(UO.CharID,3,33,string.format("You do not have %s",container))
	return {}
    end
    return my_containers:pop()
end

function S.getStorageTargets(nTargets)
    local a = {}
    a = item:scan():cont(UO.BackpackID):tp(nTargets)
    return a
end

--------------------------------------------------------------
-------------------Storing in Containers----------------------
function store(storage_index, target_types)
	local storage = S.getStorageContainer(storage_index)
	local next = next
	if next(storage) == nil then
		return
	end
	local valid_targets = S.getStorageTargets(target_types)
	if next(valid_targets) == nil then
		UO.ExMsg(UO.CharID,3,33,string.format("Nothing to Store in %s",storage.name))
		return
	end
	---Runic House doesn't play nice so set here for all types
	local x = sizeX
	local y = sizeY[storage_index]
	local addX = addOffsetX
	local addY = addOffsetY[storage_index]
	---Resetting to Runic House offets
	if storage_index == 8 then
		x, y = rSizeX,rSizeY
		addX, addY = rAddX, rAddY
	end
	local successful = false
	storage:use():waitContSize(x,y)
	for i = 1,#valid_targets do
		if not successful then
		Click.Gump(addX, addY)
		pop:waitTarget()
		end
		storage:target(valid_targets:pop(i).id):waitContSize(x,y)
		successful = UO.TargCurs
		wait(500)
	end
	wait(500)
	UO.Key("ESC")
	Click.CloseGump()
end

