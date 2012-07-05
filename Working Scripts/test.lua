dofile("../Lib/storagelib.lua")
dofile("../Lib/itemlib.lua")

	flowers = item:scan():ground(0):tp({3203,3211,3208,3206}):property()
	local next = next
	if next(flowers) == nil then	
		UO.ExMsg(UO.CharID,3,33,"You are not near any flowers.")
		return
	end
        for i = 1, #flowers do
            local flower = flowers:pop(i)
            flower:use()
            wait(1000)
        end