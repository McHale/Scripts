dofile("../Lib/itemlib.lua")

function removeTrap()
chests = item:scan():ground(3):tp({3649})

if next(chests)==nil then
   return
end

for i=1,#chests do
    local chest = chests:pop(i)
    UO.Macro(1,0,"[cs magictrap")
    wait(1000)
    chest:target()
    wait(500)
    UO.Macro(13,48)
    wait(500)
    chest:target()
    wait(11000)
end
end

while true do
      removeTrap()
end