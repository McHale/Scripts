dofile("../Lib/itemlib.lua")

function pickUpPlants()
house_items = item:scan():ground(10):property()
local next = next
if next(house_items) == nil then
   return
end
for i=1,#house_items do
    house_item = house_items:pop(i)
    if house_item.stats ~= "Locked Down" then
          UO.Macro(1,0,"I wish to secure this.")
          wait(1000)
          house_item:target()
    end
end
end

pickUpPlants()