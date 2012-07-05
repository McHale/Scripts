
    dofile("../Lib/basiclib.lua")
    dofile("../Lib/itemlib.lua")
    dofile("../Lib/storagelib.lua")

    ---------Variables to change--------------
    ---Master loot list
    ---Travesty keys 4110, 4111, 4112
    ---Gold 3821
    ----You can view the types in the storagelib and change
    ----this list to whatever you would like looted.
    toLoot = {5110,3718,3821}



        local bohID = 1076683851
    ------------------------------------------------------------
    -- how to find corpses nearby and loots stuff from them
    -- and claim them
    ------------------------------------------------------------

    function loot()

    -- find corpses
    corpses = item:scan():ground(2):tp(8198):property():name({"A Gargoyle Corpse","A Charred Corpse"})
    local next = next
    if next(corpses) == nil then
	return
    end
 
    --corpse = corpses:pop()
    loots = item:scan():cont(corpses:getIDs()):tp(toLoot)
    for i = 1,#loots do

        looted = loots:pop(i)
        wait(100)
        if looted.tp == 3821 then
           looted:drop(bohID)
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

    while true do
        loot()
        wait(1500)
    end