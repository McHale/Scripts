local booktxt="Copper"
local copytxt="aaa"
local offset=13

local glotime=getticks()
local key,book,frun=false,false,true
local runeAmt,bknum,nmbook=16,1,1
local runtbl,copy={},{}
local col=7052469
local oldRef=UO.ScanJournal(0)
local next=next
local timeout=getticks()
local timer=getticks()
local rtimer=getticks()
local gump={{sx=452, sy=236, cx=137, cy=27},
           {sx=505, sy=475, ox=290, oy=360}}
                       

function init()
for i=0, UO.ScanItems(true)-1,1 do
    local nid,typ,kind,contid=UO.GetItem(i)
    if typ==7956 and contid==UO.BackpackID then
       local nma,inf=UO.Property(nid)
       if string.len(inf)==0 then table.insert(runtbl,nid) end
    elseif typ==8901 and contid==UO.BackpackID then
       local nma,inf=UO.Property(nid)
       local name=string.sub(inf,10)
       if string.match(string.lower(name),string.lower(booktxt)) then book=nid
          nmbook=tonumber(string.sub(inf,string.find(inf,"%d+")))
          bknum=16*(nmbook-1)
          UO.SysMessage("Copying from "..name)
       elseif string.match(string.lower(name),string.lower(copytxt)) then
          --local int=tonumber(string.sub(inf,string.find(inf,"%d+")))
          UO.SysMessage("Copying to "..name)
          table.insert(copy,nid)
       end
    elseif typ==5995 and contid==UO.BackpackID then
       local nma,inf=UO.Property(nid)
       if string.match(nma,"Spell Caster's Keys") then key=nid end
    end
    if key and book and copy then break end 
end
return
end


function openBook()
UO.LObjectID=book
while true do
   if UO.ContSizeX==gump[1].sx and UO.ContSizeY==gump[1].sy then break
   elseif timer<getticks() then UO.Macro(17,0) timer=getticks()+500 end
end
if UO.ContSizeX==gump[1].sx and UO.ContSizeY==gump[1].sy then return true
else return false end
end


function runeCount()
   for i=16, 1, -1 do
      local rx = math.floor((i-1) / 8) * 160 + UO.ContPosX +146
      local ry = ((i-1) % 8) * 15 + UO.ContPosY + 74
      if UO.GetPix(rx,ry) == 524288 then
         for ii=0, 9,1 do
            if UO.GetPix(rx+1, (ry-ii)) ~= 524288 or UO.GetPix(rx, (ry-ii)) ~= 524288 then
               return i
            end
         end
      else
         return i
      end
   end
end


function bSuc(int)
local clickX=UO.ContPosX+140+math.floor(((int-1)+(int%2))/2)*35+(math.floor((int-1) / 8)) * 30
   timer=getticks()+200
   UO.Click(clickX ,UO.ContPosY+200, true, true, true, false)
   while timer>getticks() do
         if UO.ContSizeX==gump[1].sx and UO.ContSizeY==gump[1].sy
            and UO.GetPix(UO.ContPosX+gump[1].cx,UO.ContPosY+gump[1].cy)==col then break
	 elseif timer<getticks() then UO.Click(clickX ,UO.ContPosY+200, true, true, true, false)
            timer=getticks()+200
         end
      end
      timer=getticks()+200
      UO.Click(165+UO.ContPosX+((int-1)%2)*140 ,UO.ContPosY+25, true, true, true,false)
      while true do
            if string.match(UO.SysMsg, "default") then break
            elseif timer<getticks() then UO.Click(165+UO.ContPosX+((int-1)%2)*140 ,UO.ContPosY+25, true, true, true,false)
               timer=getticks()+200
            end
      end
      wait(500)
      if UO.ContSizeX==gump[1].sx and UO.ContSizeY==gump[1].sy then
         UO.Click(UO.ContPosX+UO.ContSizeX/2,UO.ContPosY+UO.ContSizeY/2,false,true,true,false)
      end
   return 
end


function getRune()
if next(runtbl) then return table.remove(runtbl) end
if key then
   local timer=getticks() 
   UO.LObjectID=key
   UO.Macro(17,0)
   while true do
      if UO.ContSizeX==gump[2].sx and UO.ContSizeY==gump[2].sy then break end
      if math.abs(getticks()-timer)%400>=200 then UO.Macro(17,0) end
   end
else return 0
end
if UO.ContSizeX==gump[2].sx and UO.ContSizeY==gump[2].sy then
   for i=1,runeAmt do
       while true do
          if UO.ContSizeX==gump[2].sx and UO.ContSizeY==gump[2].sy then
             UO.Click(UO.ContPosX+gump[2].ox,UO.ContPosY+gump[2].oy,true,true,true,false)
             wait(100)
             break
          end
       end
   end
else return 0 
end
for i=0, UO.ScanItems(true)-1,1 do
    local nid,typ,kind,contid=UO.GetItem(i)
    if typ==7956 and contid==UO.BackpackID then
       local nma,inf=UO.Property(nid)
       if string.len(inf)==0 then table.insert(runtbl,nid) end
    end
end
if UO.ContSizeX==gump[2].sx and UO.ContSizeY==gump[2].sy then
         UO.Click(UO.ContPosX+UO.ContSizeX/2,UO.ContPosY+UO.ContSizeY/2,false,true,true,false)
      end
return table.remove(runtbl)
end
 
      
function marker(nid,cid,int)
UO.LTargetKind=1
UO.LTargetID=nid
UO.LObjectID=nid
timer=getticks()+4000
local time=getticks()+500
UO.Macro(15,44)
while timer>getticks() do
      if UO.TargCurs then break
      elseif time<getticks() and string.match(UO.SysMsg, "have not yet recovered") then
         UO.Macro(15,44)
         time=getticks()+500
      end 
end
if UO.TargCurs then UO.Macro(22,0) end
timer=getticks()+1250
local time=getticks()+500
UO.Macro(17,0)
while timer>getticks() do
      if string.match(UO.SysMsg, "That rune is not yet marked.") then marker(nid)
      elseif string.match(UO.SysMsg,"enter a description for this marked object") then break
      elseif time<getticks() then UO.Macro(17,0) time=getticks()+500
      end
end
wait(200)
UO.Msg(booktxt.." "..int..string.char(13)) 
wait(200)
UO.Drag(UO.LObjectID)
wait(200)
UO.DropC(cid)
wait(500)
return
end

function recover()
local curx,cury,curf=UO.CharPosX,UO.CharPosY,UO.CursKind
UO.LTargetKind=1
UO.LTargetID=book
timer=getticks()+4000
local time=getticks()+500
UO.Macro(15,210)
while timer>getticks() do
      if UO.TargCurs then break
      elseif time<getticks() and string.match(UO.SysMsg, "have not recovered") then
         UO.Macro(15,210)
         time=getticks()+500
      end 
end
local tmp=UO.Mana
if UO.TargCurs then UO.Macro(22,0) end
timer=getticks()+300
while UO.CharPosX==curx and UO.CharPosY==cury do 
      if UO.CursKind~=curf then break
      elseif UO.Mana<tmp then
           while timer>getticks() do end
           break
      end 
end
wait(200)
if UO.ContSizeX==gump[1].sx and UO.ContSizeY==gump[1].sy then
         UO.Click(UO.ContPosX+UO.ContSizeX/2,UO.ContPosY+UO.ContSizeY/2,false,true,true,false)
      end
return
end


function main()
init()
openBook()
local cnt=runeCount()
for i=1,cnt do
    bSuc(i+offset)
    recover()
    for t,tt in pairs(copy) do
        marker(getRune(),tt,i+offset+bknum)
    end
    if i+offset<cnt then
       openBook()
    else UO.ExMsg(UO.CharID,3,38,booktxt.." copied successfully") break
    end
end
for i,ii in pairs(copy) do
    UO.LObjectID=ii
    while true do
          if UO.ContSizeX==gump[1].sx and UO.ContSizeY==gump[1].sy then break
          elseif timer<getticks() then UO.Macro(17,0) timer=getticks()+500 end
    end
    if UO.ContSizeX==gump[1].sx and UO.ContSizeY==gump[1].sy then
       UO.Click(UO.ContPosX+135, UO.ContPosY+25, true,true,true,false)
       while true do
          if string.match(UO.SysMsg, "Please enter a title") then break end
       end
       wait(200)
       UO.Msg(booktxt.." "..nmbook..string.char(13)) 
    end
wait(960)
if UO.ContSizeX==gump[1].sx and UO.ContSizeY==gump[1].sy then
   UO.Click(UO.ContPosX+UO.ContSizeX/2,UO.ContPosY+UO.ContSizeY/2,false,true,true,false)
end
end    
end


main()