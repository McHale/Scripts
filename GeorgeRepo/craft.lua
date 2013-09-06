

function craft()
while true do
local amt=scan()
while amt==0 do
      UO.Macro(8,1)
      amt=scan()
      UO.Macro(10,1)
end
print(amt)
while UO.ContSizeX==530 do --280   --410         --285  415
   UO.Click(UO.ContPosX+285, UO.ContPosY+415, true,true,true,false)       --stop() end
   if UO.Weight>=UO.MaxWeight or amt>120 then UO.ExMsg(UO.CharID, 3, 68, "flip tape over.") stop() end--cut(item) end
end
end
end

function scan()
local result=0
 for i=0, UO.ScanItems(true)-1,1 do
       local bol=true
     local nid,typ,kind,contid,_,_,_,stck=UO.GetItem(i)
     if nid==UO.BackpackID then 
        local _,inf=UO.Property(nid)
        result=string.match(inf, "^%d%d?")
        break
     end
 end  
 return result
end
--[[
function smelt(tbl)
local nma,inf="",""
--while true do
for i=0, UO.ScanItems(true)-1,1 do
     local nid,typ,kind,contid,xu,yu,zu,stck = UO.GetItem(i)
     --if typ==5092 then UO.LObjectID =nid UO.Macro(17,0) stop() end
     --if xu==UO.CharPosX and yu==UO.CharPosY then UO.Drag(nid) UO.DropC(UO.BackpackID) end
     --if typ==3854 or type==5995 then
    --    nma,inf=UO.Property(nid) end
     if contid==UO.BackpackID then
     for ii, iii in pairs(tbl) do
     --print(typ.." "..iii.." "..kind)
     if typ==iii then
     print(1)
        --if iii==3854 and not string.match(nma, "Empty") then break
        --elseif iii==5995 and not string.mactch(nma, "KeyRing") then break end
        UO.LTargetKind=1
        UO.LTargetID=nid
        while UO.ContSizeX~=530 do end
        UO.Click(UO.ContPosX+28, UO.ContPosY+352, true, true,true, false)
        while not UO.TargCurs do end
        while UO.TargCurs do
        UO.Macro(22,0)
        end
        break
     end
     end
     end      
--end
end
end

function cut(tbl)
local nma,inf="",""
--while true do
for i=0, UO.ScanItems(true)-1,1 do
     local nid,typ,kind,contid,xu,yu,zu,stck = UO.GetItem(i)
     --if typ==5092 then UO.LObjectID =nid UO.Macro(17,0) stop() end
     --if xu==UO.CharPosX and yu==UO.CharPosY then UO.Drag(nid) UO.DropC(UO.BackpackID) end
     --if typ==3854 or type==5995 then
    --    nma,inf=UO.Property(nid) end
     if contid==UO.BackpackID then
     for ii, iii in pairs(tbl) do
     --print(typ.." "..iii.." "..kind)
     if typ==iii then
        --if iii==3854 and not string.match(nma, "Empty") then break
        --elseif iii==5995 and not string.mactch(nma, "KeyRing") then break end
        UO.LTargetKind=1
        UO.LTargetID=nid
        while not UO.TargCurs do UO.Macro(17,0) wait(100) end
        while UO.TargCurs do
        UO.Macro(22,0)
        end
        break
     end
     end
     end      
--end
end
end

--smelt({5051,5055,5092,5100,5102,5128,5132,5134,5136,5137,5139,5141,5182,
      -- 7030,9918,10112})
--cut({5433,3989})    ]]--
craft()