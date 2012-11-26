--==========================================================
-- Script Name: Elemental Looter Application
-- Author: McHale
-- Version: 1.0
-- OpenEUO version tested with: 0.91
-- Purpose: Automate looting and storing of runics and resources
--==========================================================

    dofile("../Lib/itemlib.lua")
    dofile("../Lib/storagelib.lua")
    dofile("../Lib/menulib.lua")
    dofile("../Lig/config.lua")

    ---------Variables to change--------------
    toLoot = {3535,7864,3968,5091,6585,3821,3625,8765,4130,7133,3821}
    weight = 400

    local bohBOOL = true

    local lobid = 1076417933
    local bohID = 1076683851

    function move()
	if bohBOOL then
    		local resources = item:scan():cont(UO.BackpackID):tp({7133,6585})
    		if next(resources) ~= nil then
       			for i = 1, #resources do
        	  		local resource = resources:pop(i)
  		  		resource:drop(bohID)
  		  		wait(250)
      			 end
    		end
	end
    end
    ------------------------------------------------------------
    -- how to find corpses nearby and loots stuff from them
    -- and claim them
    ------------------------------------------------------------
    function loot()
	move()
    	-- find corpses
    	corpses = item:scan():ground(2):tp(8198)
    	local next = next
    		if next(corpses) == nil then
		return
    	end

	 loots = item:scan():cont(corpses:getIDs()):tp(toLoot)

    	for i = 1,#loots do
        	looted = loots:pop(i)
        	if looted.tp == 7133 or looted.tp == 6585 then
           		looted:drop(bohID)
        	else
            		looted:drop(UO.BackpackID)
        	end
        	wait(150)
    	end

    	-- claim them
    	pop:say("[claim"):waitTarget()
	for i = 1,#corpses do
		corpses:pop(i):target():waitTarget()
    	end
    	UO.Key("ESC")
    end

function setObject(msg)
	UO.ExMsg(UO.CharID,3,50,msg)
	UO.Macro(13,3)
	wait(750)
	while UO.TargCurs do
		wait(10)
	end
        local objects = item:scan():id(UO.LTargetID)
	if next(runebooks) ~= nil then
	   objects:property()
	   object = runebooks:pop()
	   msgL.ctrl.Caption = getName(runebook)
	   wait(1000)
        end
end
-----------------------------------------------------------
--------------------------THE GUI--------------------------
eleApp = menu:form(200,200,"Ele Looter")

lootB = eleApp:button("loot",10,10,100,20,"Loot Elementals")
moveB = eleApp:button("resource",10,35,100,20,"Move Resource")
storeB = eleApp:button("runic",10,60,100,20,"Store Runics")
smeltB = eleApp:button("smelt",10,85,100,20,"Smelt Ore")

lootB:onclick(function() loot() end)
moveB:onclick(function() move() end)
storeB:on
(function() Storage.storeRunics() end)
smeltB:onclick(function() errorMsg("Not implemented")  end)

eleApp:show()
Obj.Loop()
eleApp:free()
