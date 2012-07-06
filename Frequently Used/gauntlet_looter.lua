--==========================================================
-- Script Name: Gauntlet Looter
-- Author: McHale
-- Version: 1.0
-- OpenEUO version tested with: 0.91
-- Purpose: Just Loots Gold
--==========================================================

------------------------------------------------------------   
--------------------------IMPORTS---------------------------
------------------------------------------------------------   

dofile("../Lib/basiclib.lua")
dofile("../Lib/itemlib.lua")
dofile("../Lib/storagelib.lua")
dofile("../Lib/config.lua")


------------------------------------------------------------   
--------------------VARIABLES TO CHANGE---------------------
------------------------------------------------------------   
-- Master loot list
-- See Lib/Storagelib.lua for items types
-- Change variables in your Lib/config.lua
-- Currently Looting: Gold

toLoot = {3821)



------------------------------------------------------------   
---------------------LOOTING FUNCTION-----------------------
------------------------------------------------------------   

    function loot()      
    if UO.Weight > 420 then
       local gold = item:scan():cont(UO.BackpackID):tp(3821)
       gold:pop():drop(boh)
    end
    -- find corpses
    corpses = item:scan():ground(2):tp({8198})
    local next = next
    if next(corpses) == nil then
	return
    end


    -- search for gold + oints and loot them
    loots = item:scan():cont(corpses:getIDs()):tp(3821)--:property():name("Myrmidon Armor")
    
    for i = 1,#loots do
        if UO.Weight > weight then
             UO.ExMsg(UO.CharID,3,50, "Storing...please hold from using gumps for a few moments")
        end 
        looted = loots:pop(i)
        wait(100)
        looted:drop(bohID)   
    end

    -- claim them
    pop:say("[claim"):waitTarget()

    for i = 1,#corpses do
        corpses:pop(i):target():waitTarget()
    end
    UO.Key("ESC")
    end

    -----Loops constantly
    -----I cannot use hotkeys in linux
    ----so its not currently implemented.
    while true do
        loot()
        wait(1500)
    end
