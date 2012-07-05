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
    --Scales 9908, leather 4225, hides 4217
    4217,4225,9908,3576,
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
    weight = 400

    ----Gold amt - set amount to send off in the Bag of sending
    goldAmt = 10000

    my_bp = item:scan():cont(UO.BackpackID)
    for i=1,#my_bp do
	my_item = my_bp:pop(i)
	if my_item.tp == 5049 then
		skin = my_item
	end
    end

    local bohID = 1076683851

    ------------------------------------------------------------
    -- how to find corpses nearby and loots stuff from them
    -- and claim them
    ------------------------------------------------------------

    function loot()
    -- find corpses
    corpses = item:scan():ground(10):tp(8198)
    local next = next
    if next(corpses) == nil then
	return
    end

    UO.Key("ESC")
    wait(500)
    local corpse = corpses:nearest()
    UO.Pathfind(corpse.x,corpse.y,corpse.z)
    wait(1000)
    skin:use():waitTarget():target(corpse.id)
    wait(1000)
    
    -- search for gold + oints and loot them
    loots = item:scan():cont(corpse.id):tp(toLoot)
    
    for i = 1,#loots do
	
        if UO.Weight > weight then
             UO.ExMsg(UO.CharID,3,50, "Storing...please hold from using gumps for a few moments")
             wait(500)
	     Storage.storeTailor()
             Storage.storeSpell()
             Storage.storeGems()
        ----Gold Amt to test should be changed
             ----to whatever you'd like
           if UO.Gold > goldAmt then
             Storage.storeGoldBOH()
           end
        end 
        local looted = loots:pop(i)
        if looted.tp == 4217 or looted.tp==3821 then
           looted:drop(bohID) 
        else 
           looted:drop(UO.BackpackID)
        end  
    end

    -- claim them
    pop:say("[claim"):waitTarget():target(corpse.id)
    wait(150)

    UO.Key("ESC")
end

    -----Loops constantly
    -----I cannot use hotkeys in linux
    ----so its not currently implemented.
    while true do
        loot()
        wait(1500)
    end