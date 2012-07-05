dofile("../Lib/itemlib.lua")


bones = item:scan():ground(3):tp(3577)

for i=1,#bones do
    bone = bones:pop(i):drop(1082831575)
    wait(750)
end