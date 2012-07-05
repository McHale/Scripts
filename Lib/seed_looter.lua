    dofile("itemlib.lua")

    ---------Variables to change--------------

    --item id 3535: seed
    toLoot = {3535}


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
    	loots = item:scan():cont(corpses:getIDs()):tp(toLoot):property()
    
    	for i = 1,#loots do
        	looted = loots:pop(i)
        	wait(100)
        	if (looted.name ~= "Common Seed")
        	   looted:drop(UO.BackpackID)   
     	       end
    	end

    end

    -----Loops constantly
    -----I cannot use hotkeys in linux
    ----so its not currently implemented.
    while true do
        loot()
        wait(1500)
    end