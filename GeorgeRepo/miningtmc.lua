--==========================================================
-- Script Name: Recall Miner
-- Author: Themadxcow
-- Version: 1.8.fire
-- OpenEUO version tested with: 0.91
--==========================================================
local jSacred=true --Set this to true to use sacred journey.
--local cleric=true	--Set to true for auto clerical heals as needed.
local getSand=false--Set to true for sand.
                   --0 = Sort runebooks by order found
local mode=2       --1=Sort runebooks by filter (first filter we be used first, etc.)
                   --2=Sort runebooks psuedo-randomly
                        --Set of strings separated by commas.
local filter = {"Dull Copper"}--Use runebooks that contain the string in their name. 
                        --Set local filter={} to disable filter.


-- Script start --
local mTool,bRune,mKey,sKey,mKey,forge={},{},{},{},{},{}
local smet={6585,6009,4586,7154}
local tools={8901, 5995, 3634, 3897, 3718}
local delay={u=250,o=500,c=100,t=1000}
local utime={250,8250}
local gump={{sx=452,sy=236, cx=137,cy=27},
                     {sx=505, sy=270,cx=162, cy=61, ox=290, oy=235},
                     {sx=505, sy=475, cx=205, cy=34,  ox=290, oy=425}}
local col={1583467,7052469,526352,1099462,15193649}
local mineabletiles={220,221,222,223,224,225,226,227,228,229,230,231,236,237,238,239,
                     240,241,242,243,244,245,246,247,252,253,254,255,256,257,258,259,
                     260,261,262,263,268,269,270,271,272,273,274,275,276,277,278,279,
                     286,287,288,289,290,291,292,293,294,296,296,297,321,322,323,324,467,
                     468,469,470,471,472,473,474,476,477,478,479,480,481,482,483,484,485,
                     486,487,492,493,494,495,543,544,545,546,547,548,549,550,551,552,553,
                     554,555,556,557,558,559,560,561,562,563,564,565,566,567,568,569,570,
                     571,572,573,574,575,576,577,578,579,581,582,583,584,585,586,587,588,
                     589,590,591,592,593,594,595,596,597,598,599,600,601,610,611,612,613,
                     1010,1741,1742,1743,1744,1745,1746,1747,1748,1749,1750,1751,1752,1753,
                     1754,1755,1756,1757,1771,1772,1773,1774,1775,1776,1777,1778,1779,1780,
                     1781,1782,1783,1784,1785,1786,1787,1788,1789,1790,1801,1802,1803,1804,
                     1805,1806,1807,1808,1809,1811,1812,1813,1814,1815,1816,1817,1818,1819,
                     1820,1821,1822,1823,1824,1831,1832,1833,1834,1835,1836,1837,1838,1839,
                     1840,1841,1842,1843,1844,1845,1846,1847,1848,1849,1850,1851,1852,1853,
                     1854,1861,1862,1863,1864,1865,1866,1867,1868,1869,1870,1871,1872,1873,
                     1874,1875,1876,1877,1878,1879,1880,1881,1882,1883,1884,1981,1982,1983,
                     1984,1985,1986,1987,1988,1989,1990,1991,1992,1993,1994,1995,1996,1997,
                     1998,1999,2000,2001,2002,2003,2004,2028,2029,2030,2031,2032,2033,2100,
                     2101,2102,2103,2104,2105,1339,1340,1341,1342,1343,1344,1345,1346,1347,
                     1348,1349,1350,1351,1352,1353,1354,1355,1356,1357,1358,1359}
local cavetiles = {2,475,430,2028}
local sandtiles = {22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,
                   45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,68,69,70,71,72,
                   73,74,75,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,
                   301,402,424,425,426,427,441,442,443,444,445,446,447,448,449,450,451,
                   452,453,454,455,456,457,458,459,460,461,462,463,464,465,642,643,644,
                   645,650,651,652,653,654,655,656,657,821,822,823,824,825,826,827,828,
                   833,834,835,836,845,846,847,848,849,850,851,852,857,858,859,860,951,
                   952,953,954,955,956,957,958,967,968,969,970,1447,1448,1449,1450,1451,
                   1452,1453,1454,1455,1456,1457,1458,1611,1612,1613,1614,1615,1616,1617,
                   1618,1623,1624,1625,1626,1635,1636,1637,1638,1639,1640,1641,1642,1647,
                   1648,1649,1650,0x16,0x3A,0x44,0x4B,0x11E,0x121,0x126,0x12D,0x192,0x192,
                   0x1A8,0x1AB,0x1B9,0x1D1,0x282,0x285,0x28A,0x291,0x335,0x33C,0x341,0x344,
                   0x34D,0x354,0x359,0x35C,0x3B7,0x3BE,0x3C7,0x3CA,0x5A7,0x5B2,0x64B,0x652,
                   0x657,0x65A,0x663,0x66A,0x66F,0x672,0x7BD,0x7D0}
local storage = {3648, 3649, 3650, 3651, 3702, 3705, 3706, 3708, 3709, 3710, 2482, 
                 2448, 2473, 2474, 2475, 2717, 11759, 11762, 3701, 9435,
                 9431, 11764, 11761, 10257, 10258}
local next,timer=next,getticks()
local subtimer,cTool,gwt=timer,1,0
local oldRef=UO.ScanJournal(0)
local tileData = UO.TileInit(false)
local digmsg={"You put some ", "You carefully", "fail to find any",
               "There is no", "That is too far away.",  
               "Target cannot be seen.", "can't mine that", "You can't mine while riding",
               "You have worn out your tool!"} 
local smlog={"You smelt the ore ", "You burn away the impurities "}
local baditem={"Holding", "Sending", "Trash", "Gem Pouch"}
local keys={"Metal Worker's Keys", "Stone Worker's Keys", "Spell Caster's Keys"}
local ign={"You must wait to perform another action"}
local runestat={"That location is blocked."}


function init()
if UO.Weight==0 then UO.Macro(8,2) end
local tmp={UO.BackpackID}
killGump()
   if jSacred then jSacred=30
      else jSacred=0
   end
UO.TargCurs= false
UO.Macro(8,7)
local _,inf=UO.Property(UO.BackpackID)
gwt=math.abs(string.find(inf, "%d%d?", 3)-UO.Weight)
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
      elseif ii.tp == 3634 then table.insert(forge, {id=ii.id, cont=ii.cont})
      elseif ii.tp == 3897 or ii.tp == 3718 then
             if ii.id~=1075646371 then  
         table.insert(mTool, {id=ii.id, cont=ii.cont})
         end
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
      if next(forge) then UO.SysMessage("Mobile Forge: "..#forge) else UO.SysMessage("Missing forge.") break end
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
                  table.insert(item, {id = nid, tp = typ, stack = stck, name = nma, cont=contid, info=inf})
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
   while curx==UO.CharPosX and cury==UO.CharPosY do end
killGump()
   return 
end


function find()
local result={}
   for nx=-2,2,1 do
      for ny=2,-2,-1 do
         local out=true
         local tileCnt = UO.TileCnt(nx+UO.CharPosX, ny+UO.CharPosY)
	 for c=1,tileCnt do
         local TType, ZZ, NName= UO.TileGet(nx+UO.CharPosX ,ny+UO.CharPosY, tileCnt, UO.CursKind)
         for t,tt in pairs(cavetiles) do
            if TType == tt or string.match(NName, "cave") ~= nil then
               table.insert(result, {t=TType, z=ZZ, x=nx+UO.CharPosX, y=ny+UO.CharPosY, k=3, w=1})
               out=false break 
            end
         end
         if out then
            for v,vv in pairs(mineabletiles) do
               if TType == vv then 
                  table.insert(result, {t=TType, z=ZZ, x=nx+UO.CharPosX, y=ny+UO.CharPosY, k=2, w=1})
                  out=false  break
               end
            end
         end
         if out and getSand then
            for s,ss in pairs(sandtiles) do
               if TType == ss then 
                  table.insert(result, {t=TType, z=ZZ, x=nx+UO.CharPosX, y=ny+UO.CharPosY, k=2, w=true, w=2})
                  break
               end
            end
         end   
	end
      end
   end
return result
end


function gather(tbl)
local cnt=1
   for i,ii in pairs(tbl) do
      if not findCont(mTool[cTool].cont) then openCont(mTool[cTool].cont) end
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
	 subtimer=getticks()+delay.o
         while true do
            if subtimer<=getticks() and timer<=getticks() then
		UO.LTargetKind=ii.k
		UO.LTargetTile=ii.t
		UO.LTargetX=ii.x
		UO.LTargetY=ii.y
		UO.LTargetZ=ii.z
	       status=usePick(ii.w) end
	    if UO.TargCurs then UO.Macro(22,0) end
            if status==9 then cTool=cTool+1
               elseif status==8 then UO.SysMessage("Demount and try again.") stop()
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
   for i, ii in pairs(scan(smet,tmp)) do
      if ii.tp==smet[1] then table.insert(ores, {id = ii.id, stack = ii.stack})
         elseif ii.tp==smet[2] then table.insert(stones, {id = ii.id, stack = ii.stack})
         elseif ii.tp==smet[3] then table.insert(sands, {id = ii.id, stack = ii.stack})
         elseif ii.tp==smet[4] then table.insert(mets, {id = ii.id, stack = ii.stack})
      end
   end
   --if not next(ores) and not next(mets) and not next(s) not next(ores)  then
      --UO.SysMessage("You weigh too much; I can't smelt anything;  Goodbye.") stop()
   --end
   if next(ores) then 
      reDump(ores)
      for i, ii in pairs(scan(smet,tmp)) do
         if ii.tp == smet[4] then table.insert(mets, {id = ii.id, stack = ii.stack}) end
      end
   end
   if next(mets) then reStore(mets,1,2) end
--timer=getticks()+delay.t
 --  while UO.ContSizeX ~= 505 and UO.ContSizeY ~= 270 and UO.GetPix(UO.ContPosX+246,UO.ContPosY+34)~=15193649 do
 --     if UO.ContSizeX==505 or UO.ContSizeY==270 or UO.GetPix(UO.ContPosX+246,UO.ContPosY+34)==15193649 then break
 --     elseif timer<getticks() then break end
--end
--killGump()
   if next(stones) then  reStore(stones,2,2) end
--timer=getticks()+delay.t
 --  while UO.ContSizeX ~= 505 and UO.ContSizeY ~= 270 and UO.GetPix(UO.ContPosX+246,UO.ContPosY+34)~=15193649 do
 --     if UO.ContSizeX==505 or UO.ContSizeY==270 or UO.GetPix(UO.ContPosX+246,UO.ContPosY+34)==15193649 then break
 --     elseif timer<getticks() then break end
 --  end
   if next(sands) then reStore(sands,3,3) end
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
      if  not openItem(mKey[int].id,var,int+2) then print("fail 431") end --stop() end
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