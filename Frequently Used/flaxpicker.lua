dofile("../Lib/itemlib.lua")
dofile("../Lib/config.lua")

--wait time between attempts to harvest a plant 
-- currently set to 1 second
local harvest_wait = 1000

---^^^^^^^^^^^^^^^^^^^^^^^^^---
------VARIABLES TO CHANGE------	
-------------------------------

function move()
         local resources = item:scan():cont(UO.BackpackID):tp({6812})
         if next(resources) ~= nil then
            for i = 1, #resources do
                local resource = resources:pop(i)
                resource:drop(bohID)
                wait(250)
            end
         end
 end

function remove(list, element)
	for i = 1, #list do
		if list[i].id == element.id then
			table.remove(list,i)
			return list
		end
	end
	return list
end	

function zero(element)
	 local x = math.abs(UO.CharPosX-element.x)
	 local y = math.abs(UO.CharPosY-element.y)
         if x < 2 and y < 2 then
            return true
         end
         return false
end

function collectAll()
         local flax_plants = item:scan():z_axis(-1,20):tp({6809,6810,6811})
         while next(flax_plants) ~= nil do 
               local flax = flax_plants:nearest()
	       UO.Pathfind(flax.x,flax.y,flax.z)
	
               while not zero(flax) do
	             wait(10)
               end
               harvest(flax)
               --move()

	       flax_plants = remove(flax_plants, flax)
	
               if #flax_plants < 1 then
	          return
               end
        
               flax = flax_plants:nearest()
        end
end

function harvest(flax)
         while true do
               flax:use()
               wait(harvest_wait)
               if UO.ContSizeX == 178 and UO.ContSizeY == 108 then
                  local x = UO.ContPosX + 125
                  local y = UO.ContPosY + 85
                  UO.Click(x,y,true,true,true,false)
                  return
               end
         end
end

collectAll()
	
