--==========================================================
-- Script Name: Recall Miner
-- Author: Themadxcow
-- Version: 1.0 beta
-- OpenEUO version tested with: 0.91
--==========================================================
local jSacred=true --Set this to true to use sacred journey.
--local cleric=true	--Set to true for auto clerical heals as needed.
local mode=2       --1=Sort runebooks by filter (first filter we be used first, etc.)
                   --2=Sort runebooks psuedo-randomly
                        --Set of strings separated by commas.
local filter = {"Regular","Purple"}--Use runebooks that contain the string in their name. 
                        --Set local filter={} to disable filter.


-- Script start --
local mTool,bRune,mKey,sKey,mKey,forge={},{},{},{},{},{}
local smet={7133}
local tools={3907,3909,3911,3913,3915,3917,5995,8901}
local delay={u=250,o=500,c=100,t=1000}
local utime={250,8250}
local gump={{sx=452,sy=236, cx=137,cy=27},
                     {sx=505, sy=295,cx=365, cy=235, ox=290, oy=260},
                     {sx=505, sy=475, cx=205, cy=34,  ox=290, oy=425}}
--local col={1583467,7052469,526352,1099462,15193649}
local col={1583467,7052469,524288,1099462,15193649}
local storage = {3648, 3649, 3650, 3651, 3702, 3705, 3706, 3708, 3709, 3710, 2482, 
                 2448, 2473, 2474, 2475, 2717, 11759, 11762, 3701, 9435,
                 9431, 11764, 11761, 10257, 10258}
local next,timer=next,getticks()
local subtimer,cTool,gwt=timer,1,0
local oldRef=UO.ScanJournal(0)
local tileData = UO.TileInit(false)
local digmsg={"You put some ", "You found ", "fail to find any",
               "There's not enough wood", "That is too far away.",  
               "Target cannot be seen.", "can't use an axe on that",
               "You have worn out your tool!"} 
local baditem={"Holding", "Sending", "Trash", "Gem Pouch"}
local keys={"Wood Worker's Keys", "Spell Caster's Keys"}
local ign={"You must wait to perform another action"}
local runestat={"That location is blocked."}
UO.Macro(8,1)

function init()
if UO.Weight==0 then UO.Macro(8,2) end
local tmp={UO.BackpackID,UO.CharID}
killGump()
   if jSacred then jSacred=30
      else jSacred=0
   end
UO.TargCurs= false
UO.Macro(8,7)
--local _,inf=UO.Property(UO.BackpackID)
--gwt=math.abs(string.match(inf, "%d%d?", 3)-UO.Weight)
UO.SysMessage("Initializing item matrix, stand by...")
   for i,ii in pairs(scan(storage,tmp)) do
      if ii.cont==UO.BackpackID then
         openCont(ii.id)
         table.insert(tmp, ii.id) 
      end
   end
   for i,ii in pairs(scan(tools,tmp)) do
      if ii.tp == 8901 then
          if next(filter) then
            for f,ff in pairs(filter) do
               if string.match(string.lower(ii.info), string.lower(ff)) then 
                  table.insert(bRune, {id=ii.id, cont=ii.cont, val=f, name=string.sub(ii.info,10)})  
                  --UO.SysMessage("Runebook: "..string.sub(ii.info,10))
               end
            end
         else table.insert(bRune, {id=ii.id, cont=ii.cont})
         end
      elseif ii.tp == 5995 then
         for k,kk in pairs(keys) do
            if string.match(ii.name,kk) then mKey[k]={id=ii.id, cont=ii.cont} break end
         end
      --elseif ii.tp == 3634 then table.insert(forge, {id=ii.id, cont=ii.cont})
      elseif ii.cont==UO.CharID then 
         table.insert(mTool, {id=ii.id})
      end
   end
   local nma, inf = UO.Property(UO.BackpackID)
   gwt=math.abs(UO.Weight-tonumber(string.match(inf, "%d+", 3)))
   while true do
      if next(bRune) then UO.SysMessage("Runebooks: "..#bRune) else UO.SysMessage("Missing runebook.") break end
      if mode==1 then table.sort(bRune,function(a,b) return a.val<b.val end)
         elseif mode==2 then table.sort(bRune,function(a,b) return math.random(0,a.val)<math.random(0,b.val) end)
      end
      if not next(filter) then UO.SysMessage("No filters applied, all rune books will be used.") end
      if next(mKey) then UO.SysMessage("Using "..#mKey.." keys") else UO.SysMessage("Missing metal key.") break end
      --if next(forge) then UO.SysMessage("Mobile Forge: "..#forge) else UO.SysMessage("Missing forge.") break end
      if next(mTool) then UO.SysMessage("Tools: "..#mTool) else UO.SysMessage("Missing mining tool.") break end
      return
   end
stop()
end


function scan(tbl,var)
   if not var then var ={UO.BackpackID} end
local item = {}
   for i=0, UO.ScanItems(false)-1,1 do
      local bol=false
      local nid,typ,_,contid,_,_,_,stck = UO.GetItem(i)
      for c,d in pairs(var) do
         if contid==d then bol=true break end
      end
      if bol then
         for ii,iii in pairs(tbl) do
            if typ == iii then
               local bola=true
               local nma,inf = UO.Property(nid)
               for ni,msg in pairs(baditem) do
                  if string.match(nma, msg) then bola=false break end
               end
               if bola then
                  table.insert(item,{id=nid,tp=typ,stack=stck,name=nma,cont=contid, info=inf})
               else break
               end
            end
         end
      end
   end
return item
end


function journal(msg)
local adj=0
oldRef, jourCnt = UO.ScanJournal(oldRef)
   for i=jourCnt-1,0,-1 do
      local lines= UO.GetJournal(i)
      if string.match(lines, ign[1]) then adj=adj+2
      else adj=adj-1 end
      for ii,iii in pairs(msg) do
         if string.match(lines, iii) then return ii, adj end
      end             
   end  
return 0, adj
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


function bSuc(rune,int)
--if UO.ContSizeX~=gump[1].sx or UO.ContSizeX~=gump[1].sy
--or UO.GetPix(UO.ContPosX+gump[1].cx,UO.ContPosY+gump[1].cy)~=col[1] then return end
local curx,cury=UO.CharPosX,UO.CharPosY
local curp=UO.GetPix(UO.CliXRes/2,UO.CliYRes/2)
--local tmp=UO.GetPix(UO.CliXRes/2-200, UO.CliYRes/2-200)
--local cmp=UO.GetPix(UO.ContPosX+165, UO.ContPosY+25)
local clickX=UO.ContPosX+140+math.floor(((rune-1)+(rune%2))/2)*35+(math.floor((rune-1) / 8)) * 30
   --if not getCont(1,1) then print("failed") stop() end
         --print("CLICK")
      --timer=getticks()+delay.c
      timer=getticks()+delay.t
      local subtimer=getticks()+delay.c
      UO.Click(clickX ,UO.ContPosY+200, true, true, true, false)
      while timer>getticks() do
         if getCont(1,2) then break 
	 elseif subtimer<getticks() then UO.Click(clickX ,UO.ContPosY+200, true, true, true, false)
            subtimer=getticks()+delay.c
         end
      end
  -- end
   --while getCont(1,2)==true do
      --timer=getticks()+delay.o
      timer=getticks()+delay.t
      UO.Click(140+UO.ContPosX+((rune-1)%2)*160 ,150+UO.ContPosY+jSacred, true, true, true,false)
      subtimer=getticks()+delay.c
      while timer>getticks() do
            if string.match(UO.SysMsg, "^%d+.%s%d+.%u%p%s%d+.%s%d+.%u$") then  break
            elseif subtimer<getticks() then UO.Click(140+UO.ContPosX+((rune-1)%2)*160 ,150+UO.ContPosY+jSacred, true, true, true,false)
               subtimer=getticks()+delay.c
            end
      end
   --end
   UO.SysMessage(bRune[int].name..":Rune "..rune)
   timer=getticks()+delay.t*3
   while curx==UO.CharPosX and cury==UO.CharPosY do
   if UO.GetPix(UO.CliXRes/2,UO.CliYRes/2)~=curp and timer<getticks() then break end
    end
killGump()
   return 
end


function find()
local result={}
   for nx=-2,2,1 do
      for ny=2,-2,-1 do
         local out=true
         local tileCnt = UO.TileCnt(nx+UO.CharPosX, ny+UO.CharPosY)
	 for c=0,tileCnt do
         local TType, ZZ, NName= UO.TileGet(nx+UO.CharPosX ,ny+UO.CharPosY, c, UO.CursKind)
            if TType == tt or string.match(string.lower(NName), "tree") ~= nil then
               table.insert(result, {t=TType, z=ZZ, x=nx+UO.CharPosX, y=ny+UO.CharPosY, k=3, w=1}) 
            end
	end
      end
   end
return result
end


function gather(tbl)
local cnt=1
   for i,ii in pairs(tbl) do
      --if not findCont(mTool[cTool].cont) then openCont(mTool[cTool].cont) end
      while cnt==i do
         if cTool>#mTool then UO.SysMessage("No more shovels found..") stop() end
         UO.LTargetKind=ii.k
         UO.LTargetTile=ii.t
         UO.LTargetX=ii.x
         UO.LTargetY=ii.y
         UO.LTargetZ=ii.z
         local oldWgt = UO.Weight
         UO.LObjectID = mTool[cTool].id         
         local status=usePick(ii.w)
	 subtimer=getticks()+delay.t*2
         while true do
               if subtimer<=getticks() then subtimer=getticks()+delay.t*2 
                  status=usePick(ii.w) 
               end
	    if UO.TargCurs then UO.Macro(22,0) end
            if status==8 then cTool=cTool+1 break
               --elseif status==8 then UO.SysMessage("Demount and try again.") stop()
               elseif status==7 then UO.LTargetKind=cnt%4 cnt=cnt+1 break
               elseif status>=4 then cnt=cnt+3 break
               elseif status~=0 or oldWgt~=UO.Weight then break
            end
            status=journal(digmsg)
         end
         wTest(ii.k,ii.t,ii.x,ii.y,ii.z)
      end
   end
if UO.TargCurs then UO.TargCurs=false end
return
end


function usePick(var)
UO.LObjectID=mTool[cTool].id 
timer=getticks()+utime[var]
   UO.Macro(17,0)
   return journal(digmsg)
   --while timer>getticks() do
      --if UO.TargCurs then return true end
   --end
--return false
end


function wTest(kind, tile, ox, oy, oz)
if UO.Weight==0 then
   timer=getticks()+delay.c
   UO.Macro(8,2) 
   while timer>getticks() do
         if UO.Weight>0 then break end
   end
   UO.Macro(10,2)
end
--if math.min(365, UO.MaxWeight-25)<=UO.Weight-gwt then
if UO.Weight>=350 then
      UO.TargCurs = false
      findCont(UO.BackpackID)
      smelt()
      UO.LTargetKind=kind
      UO.LTargetTile=tile
      UO.LTargetX=ox
      UO.LTargetY=oy
      UO.LTargetZ=oz
     end
   return
end


function smelt()
local tmp={UO.BackpackID}
local ores,mets,stones,sands={},{},{},{}
reStore(scan(smet,tmp),1,2)
killGump()
return
end


function reDump(ore)
UO.TargCurs=false
local bol=false
UO.LTargetKind = 1
UO.LTargetID = forge[1].id
   for i,ii in pairs(ore) do 
      local wgt= UO.Weight
      UO.LObjectID = ii.id
      while not UO.TargCurs do
         timer=getticks()+delay.u
         UO.Macro(17,0)
         while timer>getticks() do 
            if UO.TargCurs then break end 
         end
      end
      UO.Macro(22,0)
      timer=getticks()+delay.u
      while timer>getticks() do
         local status=journal(smlog, 1)
         if status==1 then bol=true break
            elseif  status==2 and ii.stack>3 then reDump(ore)
         end
      end
   end
--UO.TargCurs=false
--killGump()
return
end


function reStore(tbl,int,var)
if #mKey<int then UO.SysMessage("Storage failure.  Make sure all needed keys are present.") stop() end
UO.LObjectID=mKey[int].id   
while timer>getticks() do end
--if UO.TargCurs then UO.TargCurs=false end
killGump()
   --while true do
   -- UO.GetPix(UO.ContPosX+gump[var].cx,UO.ContPosY+gump[var].cy)~=gump[var].c do
      if  not openItem(mKey[int].id,var,int+2) then print("fail 431") stop() end
      --if UO.ContSizeX==gump[var].sx and UO.ContSizeY== gump[var].sy 
      --and UO.GetPix(UO.ContPosX+gump[var].cx,UO.ContPosY+gump[var].cy)==gump[var].c then
         --break
      --end
   --end
   --while not UO.TargCurs do
         timer=getticks()+delay.c
         UO.Click(UO.ContPosX +gump[var].ox ,UO.ContPosY+gump[var].oy,true,true,true,false)
         while true do 
            if UO.TargCurs then break
            elseif timer<getticks() then
               UO.Click(UO.ContPosX +gump[var].ox ,UO.ContPosY+gump[var].oy,true,true,true,false)
               timer=getticks()+delay.c
            end 
         end
         --delay.c=delay.c+2
   -- end
   
   --timer=getticks()+delay.c
   --while timer>getticks() do end
for i,ii in pairs(tbl) do 
    --local wgt=UO.Weight
    UO.LTargetKind=1
    UO.LTargetID = ii.id
    --timer=getticks()+delay.c
    while not UO.TargCurs do
       --if timer<getticks() then break end
       --if timer<getticks() then 
          --UO.Click(UO.ContPosX +gump[var].ox ,UO.ContPosY+gump[var].oy,true,true,true,false)
          --timer=getticks()+delay.u
       --end
    end 
    --timer=getticks()+delay.u
    UO.Macro(22,0)
    --while timer>getticks() do
       --if wgt<UO.Weight then break end
    --end
end
--waitGump(var,int+2)
if UO.TargCurs then UO.TargCurs=false end
killGump()
timer=getticks()+delay.u
return
end       


function waitGump(int,var)
   local time=getticks()+delay.o
   while timer>getticks() do end
   while not getCont(int,var) do end
return
end

function killGump()
for i=0,9 do
      local x,y=findCont(false,gump[i%3+1].sx,gump[i%3+1].sy)
      if x then UO.Click(x+gump[i%3+1].sx/2, y+gump[i%3+1].sy/2, false, true, true, false)  end
end
return
end
 
 
function getCont(int, alt)
timer=timer+delay.o
while timer>getticks() do
   if UO.GetPix(UO.ContPosX+gump[int].cx, UO.ContPosY+gump[int].cy)==col[alt]                    
   and UO.ContSizeX==gump[int].sx and UO.ContSizeY==gump[int].sy then
      return true 
   end
end
return false
end


function openItem(id, int, var)
for i=0, 7 do
    UO.LObjectID=id
         timer=getticks()+delay.u
        UO.Macro(17,0)
        while timer>getticks() do
           if getCont(int,var) then return true
	   end
        end
end
return false
end


function openCont(id)
UO.LObjectID=id
for i=0, 7 do
         timer=getticks()+delay.u
        UO.Macro(17,0)
        while timer>getticks() do
           if UO.ContID==id then return 1 end
        end
end
return 0
end
 
function findCont(id,x,y)
   if not x then x=-1 end
   if not y then y=-1 end
   if not id then id=-1 end
   for i=0, 5 do
     local a,nx,ny,nsx,nsy,_,nid = UO.GetCont(i)
     if a==nil then return false
     elseif id==nid then return true
     elseif nsx==x and nsy==y then return nx, ny
     end
end
    return false
end


--function statbar()
--while UO.Weight == 0 do 
   
--end
--eturn false
--end


 function Main(bNext)
 local runCnt, rune=0,1
 UO.Macro(10,2)
 while bNext <= #bRune do
bNext, rune = bNext + 1, 1
 --openBook(bNext)
 openItem(bRune[bNext].id,1,1)
 runCnt = runeCount()
 UO.SysMessage("Runes: "..runCnt)
 while rune <= runCnt do
 if rune ~= 1 then
    --openBook(bNext)
    if bRune[bNext].cont~=UO.BackpackID then openCont(bRune[bNext].cont) end
    openItem(bRune[bNext].id,1,1)
 end
 bSuc(rune,bNext)
 gather(find())
 rune = rune+1
 end
 if bNext == #bRune then
    bNext = 0
 end            
 end
 end
 
 
init()
Main(0)