dofile("../Lib/itemlib.lua")
while true do
arrows = item:scan():ground(4):tp({7163,3903})

for i=1,#arrows do
    arrows:pop(i):drop(UO.BackpackID)
end
wait(5000)
end