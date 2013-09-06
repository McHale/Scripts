local fn="Platinum"   --Filename for subcategory, Also your unfilled runebook name
local mt="Ore"     --Category name. ie Ore | Wood | Tram Dungeons
local remind=15     --Seconds between reminders on which rune # we are on.  Only used if automark is off.
local runeAmt=30       --Number of runes to grab from keys at a time.
local lastdel="ESC"    --Delete last rune.
local override="F12"   --Force save current location as rune.
local mark=false           --0 = Automark and transport to library
                       --1 = Check runes and save spot only.
--Name your library runebook as Home and default the rune.


local key,home=false,false
local rune,book={},{}
local oldRef=UO.ScanJournal(0)
local next=next
local timeout=getticks()
local timer=getticks()
local rtimer=getticks()
local gump={sx=505, sy=475, ox=290, oy=360}
                       

function init()
UO.Macro(8,7)
for i=0, UO.ScanItems(true)-1,1 do
    local nid,typ,kind,contid=UO.GetItem(i)
    if typ==7956 then
       local nma,inf=UO.Property(nid)
       if not inf then table.insert(rune,nid) end
    elseif typ==8901 then
       local nma,inf=UO.Property(nid)
       local name=string.sub(inf,10)
       if string.match(string.lower(name),"home") then home=nid
          UO.SysMessage("Using "..name.." as library home.")
       elseif string.match(string.lower(name),string.lower(fn)) then
          UO.SysMessage("Building with "..name.." as editable runebook.")
          table.insert(book,{id=nid, num=string.sub(inf,string.find(inf,"%d+"))}) 
       end
    elseif typ==5995 then
       local nma,inf=UO.Property(nid)
       if string.match(nma,"Spell Caster's Keys") then key=nid end
    end
end
table.sort(book,function(a,b) return a.num<b.num end)
return loader()
end



function record(tbl,mtbl)
for i, ii in pairs(tbl) do
    local diff=math.max(math.abs(UO.CursKind*UO.CharPosX-ii.x),math.abs(UO.CursKind*UO.CharPosY-ii.y))
      if diff<7 then
          UO.ExMsg(UO.CharID,3,34,"Duplicate: #"..i)
          return false
       --if ii==UO.CharPosX..UO.CharPosY then dupe=false UO.SysMessage("Duplicate: "..i)  end
       end
end
for i, ii in pairs(mtbl) do
    local diff=math.max(math.abs(UO.CursKind*UO.CharPosX-ii.x),math.abs(UO.CursKind*UO.CharPosY-ii.y))
      if diff<7 then
          UO.ExMsg(UO.CharID,3,153,"Duplicate in master log : #"..i)
          return false
       --if ii==UO.CharPosX..UO.CharPosY then dupe=false UO.SysMessage("Duplicate: "..i)  end
       end
end
return {x=UO.CharPosX, y=UO.CharPosY}                           
end

function trigger(data,mtr,e)
if e then UO.SysMessage("Database error: "..e) stop()
elseif not next(data) then UO.SysMessage("Creating new database: "..fn.." in "..mt.." database.")
else UO.SysMessage("Loaded "..#data.." "..fn.." entries.")
     UO.SysMessage("Loaded "..#mtr.." "..mt.." entries.")  
end
if remind>0 then rtimer=getticks()+remind*960 end
local cnt=#data
while true do
      if remind>0 and rtimer<getticks() then UO.ExMsg(UO.CharID,3,68,"Last rune: "..cnt)
         rtimer=getticks()+remind*960
      end
   local pox=UO.CharPosX..UO.CharPosY
   if string.match(UO.SysMsg, "^%d+.%s%d+.%u%p%s%d+.%s%d+.%u$") then
      while pox==UO.CharPosX..UO.CharPosY do end
      local timer=getticks()+250
      while timer>getticks() do end
      local val=record(data,mtr)
      if val then
         local curx,cury=UO.CharPosX,UO.CharPosY
         cnt=cnt+1
         store(curx*UO.CursKind, cury*UO.CursKind, cnt)
         table.insert(data, val)
         oldRef=UO.ScanJournal(oldRef)
         if mark then marker(getRune()) end
      end  
   elseif getkey(lastdel) and timeout<getticks() then 
      timeout=getticks()+2000
      print(cnt)
      cnt=cnt-del(cnt)
      print(cnt)
      UO.Key("F16")
   end
end
end


function getRune()
if next(rune) then return table.remove(rune) end
if key then
   local timer=getticks() 
   UO.LObjectID=key
   UO.Macro(17,0)
   while true do
      if UO.ContSizeX==gump.sx and UO.ContSizeY==gump.sy then break end
      if math.abs(getticks()-timer)%400>=200 then UO.Macro(17,0) end
   end
else return 0
end
if UO.ContSizeX==gump.sx and UO.ContSizeY==gump.sy then
   for i=1,runeAmt do
       while true do
          if UO.ContSizeX==gump.sx and UO.ContSizeY==gump.sy then
             UO.Click(UO.ContPosX+gump.ox,UO.ContPosY+gump.oy,true,true,true,false)
             wait(100)
             break
          end
       end
   end
else return 0 
end
for i=0, UO.ScanItems(true)-1,1 do
    local nid,typ,kind,contid=UO.GetItem(i)
    if typ==7956 then
       local nma,inf=UO.GetProperty(nid)
       if not inf then table.insert(rune,nid) end
    end
end
return table.remove(rune)
end
 
      
function marker(nid)
UO.LTargetKind=1
UO.LTargetID=nid
UO.LObjectID=nid
timer=getticks()+4000
UO.Macro(15,44)
while timer>getticks() do
      if UO.TargCurs then break end
end
if UO.TargCurs then UO.Macro(22,0) end
timer=getticks()+2000
while timer>getticks() do
      if string.match(UO.SysMsg, "not marked") then marker(nid)
      elseif string.match(UO.SysMsg,"Please") then break end
end
wait(200)
UO.Msg(fn.." "..cnt..string.char(13)) 
wait(200)
UO.Drag(UO.LObjectID)
wait(200)
UO.DropC(book[math.ceil(cnt/16)].id)
wait(500)
UO.LTargetID=home
UO.Macro(15,210)
while timer>getticks() do
      if UO.TargCurs then break end
end
if UO.TargCurs then UO.Macro(22,0) return end
end


function del(int)
local clog,mlog={},{}
local f,e = openfile(fn..".db","rb")
if f then
   print("loading first")
    while true do
       local lx=f:read("*n")
       local ly=f:read("*n")
       if ly then table.insert(clog, {x=lx,y=ly})
       else table.remove(clog) break
       end
    end
    f:close()
else UO.SysMessage("Data parse subfail: "..e) stop() end
local m,e = openfile(mt..".db","rb")
if m then
    while true do
       local lx=m:read("*n")
       local ly=m:read("*n")
       if ly then table.insert(mlog, {x=lx,y=ly})
       else table.remove(mlog) break
       end
    end
    m:close()
else UO.SysMessage("Data parse master fail: "..e) stop() end
if next(clog) and next(mlog) then
   UO.SysMessage("Removing rune "..int.." from "..fn)
   f,e = openfile(fn..".db","w")
   if f then
      for i,ii in pairs(clog) do
          f:write(ii.x," ",ii.y,"\n")
      end
      f:close()
   else UO.SysMessage("Data write subfail: "..e) stop() end
   UO.SysMessage("Removing rune "..int.." from "..mt)
   m,e = openfile(mt..".db","w")
   if m then
      for i,ii in pairs(mlog) do
          m:write(ii.x," ",ii.y,"\n")
      end
      m:close()
      return 1
   else UO.SysMessage("Data write master fail: "..e) stop() end
end
print("err") stop()
return 0
end


function store(lval,rval,int)
local m,e = openfile(mt..".db","a+b")
if m then                             --anything other than nil/false evaluates to true
   m:write(lval," ",rval,"\n")
   m:close()
else error(e,2)
end
local f,e = openfile(fn..".db","a+b")
if f then                             --anything other than nil/false evaluates to true
   f:write(lval," ",rval,"\n")
   f:close()
   UO.ExMsg(UO.CharID,3,68,"Saved: "..int..". "..UO.CursKind*UO.CharPosX.."x"..UO.CursKind*UO.CharPosY)
   --UO.ExMsg(UO.CharID, 3, 68, "Number "..int.." saved: "..UO.CursKind*UO.CharPosX.."x"..UO.CursKind*UO.CharPosY)
   return 1
else
    error(e,2) 
end
end


function loader()
local tbl,mtbl={},{}
local f,e = openfile(fn..".db","rb")         --r means read-only (default)
  if f then 
     while true do                           --anything other than nil/false evaluates to true
        local cx = f:read("*n")
        local cy = f:read("*n")
        if cy then table.insert(tbl, {x=cx, y=cy})
        else f:close() break
        end
     end
else 
     f,e = openfile(fn..".db","w")
     if f then
     f:write("")
     f:close()                              --if openfile fails it returns nil plus an error message
     end               
end     
local m,e = openfile(mt..".db","rb")         --r means read-only (default)
  if m then 
     while true do                           --anything other than nil/false evaluates to true
        local cx = m:read("*n")
        local cy = m:read("*n")
        if cy then table.insert(mtbl, {x=cx, y=cy})
        else m:close() return tbl,mtbl
        end
     end
else 
     m,e = openfile(mt..".db","w")
     if m then
     m:write("")
     m:close()                              --if openfile fails it returns nil plus an error message
     return tbl,mtbl
     end               
end 
return tbl,mtbl,e          --stack level 2, error should be reported 
end

trigger(init())