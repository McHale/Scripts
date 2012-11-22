isRdy, counter, olRef, lines= false, false, 1, 1, 1
itemArray = {(2510), (5901), (2426), (2508), (3542), (5905), (2511), (2508), (5903), (5899)}
for i=0, UO.ScanItems(false)-1,1 do
    local id,typ,kind,contid,x,y,z,stack,rep,col = UO.GetItem(i)
    if (typ == 3520) then
       rPole = id
       UO.Macro(3,0,"Stop")
       UO.Macro(3,0,"Raise Anchor")
    end
end

for i=0, UO.ScanItems(false)-1,1 do
    local id,typ,kind,contid,x,y,z,stack,rep,col = UO.GetItem(i)
    if (typ == 15973) then
       fishStore = id
       isRdy = true
    end
end

if isRdy == false then
   UO.SysMessage("Cannot find a fishing pole.. Aborting")
   print("Cannot find a fishing pole.. Aborting")
   stop()
end

function offSet()
   return math.random(-2,2)
end

function findfish()
UO.LTargetID = 1
local locX=UO.CharPosX + offSet(rndX)
local locY=UO.CharPosY + offSet(rndY)
local tileData = UO.TileInit(false)
local tileCnt = UO.TileCnt(locX, locY)
      for i=0, (tileCnt-1) do
          local TType, ZZ, NName, FFlags = UO.TileGet(locX ,locY, tileCnt)
          if NName == "water" then
             return TType, ZZ, locX, locY
          end
      end
end

function fish()
      local noFish, nextFish = false, false
      UO.LTargetID, UO.LTargetZ, UO.LTargetX, UO.LTargetY = findfish()
      UO.LTargetKind = 2
      repeat
      UO.LObjectID = rPole
      for i=1,10 do
          if UO.LObjectID == rPole then
             break
          end
          wait(50)
      end
      UO.Macro(17,0)
      for i=0, 10 do
          if UO.TargCurs == true then
             break
          end
          wait(100)
      end
      UO.Macro(22, 0)
      local oldRef = 0
      for i=0, 500 do
      local jourRef, jourCnt = UO.ScanJournal(oldRef)
      if oldRef ~= jourRef then
         local lines, oldRef = UO.GetJournal(0), jourRef
      if string.match(lines, "biting here") ~= nil then
         local noFish, locA = true, UO.CharPosX..UO.CharPosY
         for x=1, 8 do
            UO.Macro(1,0,"One Forward")
            wait(1000)
         end
         if locA == UO.CharPosX..UO.CharPosY then
              UO.SysMessage("Captain, we are stuck.")
              print("Captain, we are stuck.")
              stop()
         end
         fish()
         break
      elseif string.match(lines, "You fish a while, but fail to catch anything.") ~= nil then
             break
      elseif string.match(lines, "You pull out an item") ~= nil then
             break
      elseif string.match(lines, "You need to be closer to") ~= nil then
             fish()
             break
      elseif string.match(lines, "sea serpent") ~= nil then
             kill()
             break
      end
      wait(50)
      end
   end
   weighter()
   until xxx == true
end

function weighter()
   if UO.Weight > UO.MaxWeight then
      for i=0, UO.ScanItems(false)-1,1 do
          id,typ,kind,contid,x,y,z,stack,rep,col = UO.GetItem(i)
             for ix=0, 11 do
                if typ == itemArray[ix] then
                  local weight = UO.Weight
                  UO.Drag(id,stack)
                  for i=1,10 do
                      if UO.LLiftedID == id then
                         break
                      end
                      wait(50)
                  end
                   wait(200)
                   UO.DropC(fishStore)
                   wait(200)
               end
             end
    end
   end
end

function kill()
while UO.Mana > 30 do

end

fish()

