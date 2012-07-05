dofile("../Lib/itemlib.lua")

local bohID = 1076683851

local gold_piles = item:scan():cont(boh):tp(3812)

if next(gold_piles) == nil then
   UO.ExMsg(UO.CharID,3,25,"There is no gold to give")
   stop()
end

local beggars = {}

while next(beggars) == nil do
      beggars = item:scan():ground(2):tp(400)
      wait(2000)
end

UO.Drag(gold_piles:pop(), 1000)
UO.DropC(beggars:nearest())
