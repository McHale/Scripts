    dofile("../Lib/basiclib.lua")
    dofile("../Lib/itemlib.lua")
    dofile("../Lib/storagelib.lua")

    ---------Variables to change--------------
    ---Master loot list
    ---Travesty keys 4110, 4111, 4112 NOT Included atm
    ---picks and knives not on this list
    ---only gems and spellcaster key objects on the list.
    ---Gold 3821
    ----You can view the types in the storagelib and change
    ----this list to whatever you would like looted.
    
    toLoot = {
    --Travesty keys
    4110,4111,4112,
    --cell key
    4115,
    3535,3962,3963,3972,3973,3974,3976,3980,3981,3960,3983,
		3965,3982,3978,3969,9911,9912,3966,3968,3827,3854,5154,
	3620,2426,3615,7956,4586,6464,3821,3885,3878,3859,3865,3873,3862,
3856,7847,3861,3877,12693,12695,12697,12692,12696,12690,12691,12694}
    ----Weight variable - change to a little less than
    ---how much weight you can hold
    weight = 440

    ----Gold amt - set amount to send off in the Bag of sending
    goldAmt = 10000
    
    --
    boh = 1076683851 


    ------------------------------------------------------------
    -- how to find corpses nearby and loots stuff from them
    -- and claim them
    ------------------------------------------------------------

    function loot()
    -- find corpses
    corpses = item:scan():ground(2):tp(8198)
    local next = next
    if next(corpses) == nil then
	return
    end


    -- search for gold + oints and loot them
    loots = item:scan():cont(corpses:getIDs()):tp(toLoot)
    
    for i = 1,#loots do
        if UO.Weight > weight then
             UO.ExMsg(UO.CharID,3,50, "Storing...please hold from using gumps for a few moments")
             wait(500)
             Storage.storeSpell()
             Storage.storeGems()
        end 
        looted = loots:pop(i)
        wait(100)
        if looted.tp == 3821 then
           looted:drop(1076683851)
        else
            looted:drop(UO.BackpackID)   
        end
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