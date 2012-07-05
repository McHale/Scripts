    dofile("../Lib/itemlib.lua")    
    dofile("../Lib/basiclib.lua")
    dofile("../Lib/storagelib.lua")
    dofile("../Lib/menulib.lua")


    ---------Variables to change--------------
    ---Master loot list
    ---Travesty keys 4110, 4111, 4112 NOT Included atm
    ---picks and knives not on this list
    ---only gems and spellcaster key objects on the list.
    ---Gold 3821
    ----You can view the types in the storagelib and change
    ----this list to whatever you would like looted.
    
    toLoot = {3535,3962,3963,3972,3973,3974,3976,3980,3981,3960,3983,
		3965,3982,3978,3969,9911,9912,3966,3968,3827,3854,5154,
	3620,2426,3615,7956,4586,6464,3821,3885,3878,3859,3865,3873,3862,
3856,7847,3861,3877,12693,12695,12697,12692,12696,12690,12691,12694}
    ----Weight variable - change to a little less than
    ---how much weight you can hold
    weight = 440

    ----Gold amt - set amount to send off in the Bag of sending
    goldAmt = 10000

    ------------------------------------------------------------
    -- how to find corpses nearby and loots stuff from them
    -- and claim them
    ------------------------------------------------------------

    function loot(trash)
    -- find corpses
    treasure = item:scan():ground(2):tp(3648)
    local next = next
    if next(treasure) == nil then
        UO.ExMsg(UO.CharID,3,33,"There are no treasure chests")
	return
    end
    chest = treasure:pop()

    -- search for gold + oints and loot them 
    loots = item:scan():cont(chest.id) 
    if not trash then 
       loots = loots:tp(toLoot)
    end
    for i = 1,#loots do
        if UO.Weight > weight then
             UO.ExMsg(UO.CharID,3,50, "Storing...please hold from using gumps for a few moments")
             wait(500)
             Storage.storeSpell()
             Storage.storeGems()
        ----Gold Amt to test should be changed
             ----to whatever you'd like
           if UO.Gold > goldAmt then
             Storage.storeGoldBOS()
           end
        end 
        looted = loots:pop(i)
        if trash then
           looted:drop(1094105672)
        else
            looted:drop(UO.BackpackID)
        end
        --wait(500)
        
   
    end

end
--------------------------GUI----------------------------------
treasureApp = menu:form(130,100,"Treasure Looter")

lootB = treasureApp:button("loot",10,10,100,20,"Loot Items")
trashB = treasureApp:button("trash",10,35,100,20,"Trash Items")

lootB:onclick(function() loot(false) end)
trashB:onclick(function() loot(true) end)

treasureApp:show()
Obj.Loop()
flowerApp:free()