
do
loom, wheel, lCnt, wCnt, swCnt, loCnt, sCnt,endIt = {}, {}, 0, 0, 0, 0, 0, false
for i=0, UO.ScanItems(false)-1,1 do
    id,typ,kind,contid,x,y,z,stack,rep,col = UO.GetItem(i)
    disX = math.abs(UO.CharPosX - x)
    disY = math.abs(UO.CharPosY - y)
    disT = math.abs(disX + disY)
    for ii=0, (wCnt + lCnt) do
        if id == loom[ii] then
           ignoreIt = true
        elseif id == wheel[ii] then
           ignoreIt = true
        else
            ignoreIt = false
        end
    end
    if disT <= 5 then
       if typ == 4192 then
          loom[lCnt] = id
          lCnt = lCnt + 1
       elseif typ == 4117 then
          wheel[wCnt] = id
          wCnt = wCnt + 1
       end
    end
end

if wCnt == 0 then
   UO.SysMessage("There is no spinning wheel nearby.")
   stop()
end
if lCnt == 0 then
   UO.SysMessage("There is no loom nearby.")
   stop()
end
    UO.SysMessage("Looms: "..lCnt)
    UO.SysMessage("Spinning wheels: "..wCnt)

repeat
endIt = true
for i=0, UO.ScanItems(false)-1,1 do
    spinNow = false
    id,typ,kind,contid,x,y,z,stack,rep,col = UO.GetItem(i)
    if typ == 3576 and contid == UO.BackpackID then
       spinNow = true
    elseif typ == 6812 and contid == UO.BackpackID then
       spinNow = true
    end
    if spinNow == true then
       endIt = false
    for stck=0, stack do
        print(stck)
       UO.LObjectID = id
       wait(100)
       UO.Macro(17,0)
       UO.LTargetKind = 1
       UO.LTargetID = wheel[sCnt]
       wait(100)
       sCnt = sCnt + 1
       for waitX=0, 10 do
             if UO.TargCurs == true then
                break
             end
             wait(100)
       end
       UO.Macro(22,0)
       wait(500)
       if sCnt == wCnt then
          wait(1000)
          sCnt = 0
       end
    end
    end
end
until endIt == true

repeat
endIt = true
for i=0, UO.ScanItems(false)-1,1 do
    spinNow = false
    id,typ,kind,contid,x,y,z,stack,rep,col = UO.GetItem(i)
    if typ == 4000 and contid == UO.BackpackID then
       spinNow = true
    elseif typ == 3613 and contid == UO.BackpackID then
       spinNow = true
    end
    if spinNow == true then
       endIt = false
    for stck=0, stack do
       UO.LObjectID = id
       wait(100)
       UO.Macro(17,0)
       UO.LTargetKind = 1
       UO.LTargetID = loom[sCnt]
       wait(100)
       sCnt = sCnt + 1
       for waitX=0, 10 do
             if UO.TargCurs == true then
                break
             end
             wait(100)
       end
       UO.Macro(22,0)
       wait(200)
       if sCnt == lCnt then
          sCnt = 0
       end
    end
    end
end
until endIt == true
UO.SysMessage("Out of material.")
end
