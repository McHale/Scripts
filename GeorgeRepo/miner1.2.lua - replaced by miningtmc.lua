--==========================================================
-- Script Name: Recall Miner
-- Author: Themadxcow
-- Version: 1.4
-- OpenEUO version tested with: 0.91
--==========================================================
local jSacred=true -- set this to true to use sacred journey.
                   --0 = Sort runebooks by order found
local mode=2       --1 = Sort runebooks by filter (first filter we be used first, etc.)
                   --2 = Sort runebooks psuedo-randomly
local filter = {"lectrum","oxic","Ice","laze"}
-- Set of strings separated by commas, CASE SENSITIVE.  
 --This filter forces the script to ONLY 
--use runebooks that contain the string in their name.
--Set local filter={} to disable filter.
-- Script start --
local next=next
local mTool,bRune,mKey,sKey,forge={},{},{},{},{}
local smet = {6585,6009,7154}
local tools = {8901, 5995, 3634, 3897, 3718}
local mineabletiles = {
         220,221,222,223,224,225,226,227,228,229,230,231,236,237,238,239,240,241,242,243
	,244,245,246,247,252,253,254,255,256,257,258,259,260,261,262,263,268,269,270,271
	,272,273,274,275,276,277,278,279,286,287,288,289,290,291,292,293,294,296,296,297
	,321,322,323,324,467,468,469,470,471,472,473,474,476,477,478,479,480,481,482,483
	,484,485,486,487,492,493,494,495,543,544,545,546,547,548,549,550,551,552,553,554
	,555,556,557,558,559,560,561,562,563,564,565,566,567,568,569,570,571,572,573,574
	,575,576,577,578,579,581,582,583,584,585,586,587,588,589,590,591,592,593,594,595
	,596,597,598,599,600,601,610,611,612,613,1010,1741,1742,1743,1744,1745,1746,1747
	,1748,1749,1750,1751,1752,1753,1754,1755,1756,1757,1771,1772,1773,1774,1775,1776
	,1777,1778,1779,1780,1781,1782,1783,1784,1785,1786,1787,1788,1789,1790,1801,1802
	,1803,1804,1805,1806,1807,1808,1809,1811,1812,1813,1814,1815,1816,1817,1818,1819
	,1820,1821,1822,1823,1824,1831,1832,1833,1834,1835,1836,1837,1838,1839,1840,1841
	,1842,1843,1844,1845,1846,1847,1848,1849,1850,1851,1852,1853,1854,1861,1862,1863
	,1864,1865,1866,1867,1868,1869,1870,1871,1872,1873,1874,1875,1876,1877,1878,1879
	,1880,1881,1882,1883,1884,1981,1982,1983,1984,1985,1986,1987,1988,1989,1990,1991
	,1992,1993,1994,1995,1996,1997,1998,1999,2000,2001,2002,2003,2004,2028,2029,2030
	,2031,2032,2033,2100,2101,2102,2103,2104,2105,1339,1340,1341,1342,1343,1344,1345
	,1346,1347,1348,1349,1350,1351,1352,1353,1354,1355,1356,1357,1358,1359}
local cavetiles = {2,475,430,2028}
local storage = {3648, 3649, 3650, 3651, 3702, 3705, 3706, 3708, 3709, 3710, 2482, 
                 2448, 2473, 2474, 2475, 2717, 11759, 11762, 3701, 9435,
                 9431, 11764, 11761, 10257, 10258}
local cTool=1
local timer=getticks()
local oldRef=UO.ScanJournal(0)
local tileData = UO.TileInit(false)
local digmsg={"You put some ", "You carefully", "You loosen some rocks",
               "no metal", "That is too far away.",  
               "Target cannot be seen.", "can't mine that", "while riding.",
               "You have worn out your tool!"} 
local smlog={"You smelt the ore ", "You burn away the impurities "}
local baditem={"Holding", "Sending", "Trash", "Gem Pouch"}
local ign={"You must wait"}

function init()
UO.Macro(8,2)
local tmp={UO.BackpackID}
killGump()
if jSacred then jSacred=30
else jSacred=0
end
UO.TargCurs= false
UO.Macro(8,7)
UO.SysMessage("Initializing item matrix, stand by...")
for i,ii in pairs(scan(storage,tmp)) do
    if ii.cont==UO.BackpackID then
       openCont(ii.id)
       table.insert(tmp, ii.id) 
    end
end
                                  --3712
for i,ii in pairs(scan(tools,tmp)) do
       if ii.tp == 8901 then
          if next(filter) then
             for f,ff in pairs(filter) do
                 if string.match(ii.info, ff) then 
                    table.insert(bRune, {id=ii.id, cont=ii.cont, val=f, name=string.sub(ii.info,10)})  
                    print(string.sub(ii.info,10))
                    UO.SysMessage("Runebook: "..string.sub(ii.info,10))
                 end
             end
          else table.insert(bRune, {id=ii.id, cont=ii.cont})
          end
       elseif ii.tp == 5995 then
           if ii.name == "Metal Worker's Keys" then
              table.insert(mKey, {id=ii.id, cont=ii.cont})
           elseif ii.name == "Stone Worker's Keys" then
               table.insert(sKey, {id=ii.id, cont=ii.cont})
           end
       elseif ii.tp == 3634 then table.insert(forge, {id=ii.id, cont=ii.cont})
       elseif ii.tp == 3897 or ii.tp == 3718 then 
              table.insert(mTool, {id=ii.id, cont=ii.cont})
       end
end
while true do

if next(bRune) then UO.SysMessage("Runebooks: "..#bRune) else UO.SysMessage("Missing runebook.") break end
   if mode==1 then table.sort(bRune,function(a,b) return a.val<b.val end)
   elseif mode==2 then table.sort(bRune,function(a,b) return math.random(0,a.val)<math.random(0,b.val)end)
   end
if not next(filter) then UO.SysMessage("No filters applied, all rune books will be used.") end
if next(mKey) then UO.SysMessage("Metal Key: "..#mKey) else UO.SysMessage("Missing metal key.") break end
if next(sKey) then UO.SysMessage("Stone Key: "..#sKey) else UO.SysMessage("Missing stone key") break end
if next(forge) then UO.SysMessage("Mobile Forge: "..#forge) else UO.SysMessage("Missing forge.") break end
if next(mTool) then UO.SysMessage("Tools: "..#mTool) else UO.SysMessage("Missing mining tool.") break end
return
end
stop()
end

function openCont(id)
UO.LObjectID=id
for i=0, 7 do
         timer=getticks()+250
        UO.Macro(17,0)
        while timer>getticks() do
        if UO.ContID==id then return 1 end
        end
end
return 0
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
              --if typ == 5995 then
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


function runeCount() -- courtesy of KALocr (Kal In Ex)
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


function openBook(book)
if not findCont(bRune[book].cont) then openCont(bRune[book].cont) end
UO.LObjectID = bRune[book].id
while true do
      timer=getticks()+250
      UO.Macro(17,0)
      while timer>getticks() do
            local cmp = UO.GetPix(UO.ContPosX+165, UO.ContPosY+25)
            if UO.ContName=="generic gump" 
             and UO.ContSizeX==452 
             and cmp==9223622 then return true
            end
      end
end
UO.SysMessage("Cannot open runebook")
stop()
end

-- Recall chunk
function bSuc(rune,int)
 local result=false
   local curLoc=UO.CharPosX..UO.CharPosY
   local tmp=UO.GetPix(UO.CliXRes/2, UO.CliYRes/2)
  local cmp=UO.GetPix(UO.ContPosX+165, UO.ContPosY+25)
  local clickX=UO.ContPosX+140+math.floor(((rune-1)+(rune%2))/2)*35+(math.floor((rune-1) / 8)) * 30
  local clickY=UO.ContPosY+200
  while UO.GetPix(UO.ContPosX+165, UO.ContPosY+25)==cmp do 
        timer=getticks()+100
        UO.Click(clickX ,clickY, true, true, true, false)
        while timer>getticks() do
              if UO.GetPix(UO.ContPosX+165, UO.ContPosY+25)~=cmp then break end
        end
   end
  clickX=140+UO.ContPosX+((rune-1)%2)*160
  clickY=150+UO.ContPosY+jSacred
  while UO.ContSizeX==452 do
        timer=getticks()+100
        UO.Click(clickX ,clickY, true, true, true,false)
        while timer>getticks() do
              if string.match(UO.SysMsg, "^%d+.%s%d+.%u%p%s%d+.%s%d+.%u$") then break end
        end
  end
   UO.SysMessage(bRune[int].name..":Rune "..rune)
   while curLoc == UO.CharPosX..UO.CharPosY do end
   timer=getticks()+500
      while timer>getticks() do
                if UO.GetPix(UO.CliXRes/2, UO.CliYRes/2)~=cmp then result=true break end
   end
   killGump()
   return result
end


-- Resource locator chunk
function find()
local result={}
for nx=-2,2,1 do
    for ny=2,-2,-1 do
        local out=true
        local tileCnt = UO.TileCnt(nx+UO.CharPosX, ny+UO.CharPosY)
        local TType, ZZ, NName= UO.TileGet(nx+UO.CharPosX ,ny+UO.CharPosY, tileCnt, UO.CursKind)
        --if math.abs(ZZ) - math.abs(UO.CharPosZ) < math.abs(maxZ)  then
         for t,tt in pairs(cavetiles) do
              if TType == tt or string.match(NName, "cave") ~= nil then
               table.insert(result, {t=TType, z=ZZ, x=nx+UO.CharPosX, y=ny+UO.CharPosY, k=3})
               out=false
               break
               end
         end
         if out then
         for v,vv in pairs(mineabletiles) do
             if TType == vv then 
             table.insert(result, {t=TType, z=ZZ, x=nx+UO.CharPosX, y=ny+UO.CharPosY, k=2}) 
             break
             end
         end
         end
         --end
    end
end
return result
end

-- Miner chunk
                                        
function gather(tbl)
local cnt=1
for i,ii in pairs(tbl) do
    if not findCont(mTool[cTool].cont) then openCont(mTool[cTool].cont) end
    while cnt==i do
    print(cTool.." "..#mTool)
    if cTool>#mTool then UO.SysMessage("No more shovels found..") stop() end
    killGump()
    UO.LTargetKind=ii.k
    UO.LTargetTile=ii.t
    UO.LTargetX=ii.x
    UO.LTargetY=ii.y
    UO.LTargetZ=ii.z
    local oldWgt = UO.Weight
    UO.LObjectID = mTool[cTool].id         
       while not UO.TargCurs do
             timer=getticks()+250
             UO.Macro(17,0)
             while timer>getticks() do
                   if UO.TargCurs then break end
             end
      end
      UO.Macro(22,0)
      timer=getticks()+250
      while timer>getticks() do
          local status=journal(digmsg)
                if UO.TargCurs then UO.Macro(22,0) timer=getticks()+250 end
                if status==9 then cTool=cTool+1 end
                if status==8 then UO.SysMessage("Demount and try again.") stop()
             elseif status>=4 then cnt=cnt+1 break
             elseif status~=0 or oldWgt~=UO.Weight then break
             end
      end
      wTest()
      end
  end
end


function statbar()
while UO.Weight == 0 do 
   timer=getticks()+250
   UO.Macro(8,2) 
   while timer>getticks() do
         if UO.Weight>0 then return true end
   end
end
return false
end
                 

--Weight test
function wTest()
statbar()
if UO.Weight > UO.MaxWeight or UO.Weight >= 380 then
   local saveID = UO.LObjectID
   local saveK = UO.LTargetKind
   local saveTar = UO.LTargetID
   local saveT = UO.LTargetTile
   local saveX = UO.LTargetX
   local saveY = UO.LTargetY
   local saveZ = UO.LTargetZ
      UO.TargCurs = false
      findCont(UO.BackpackID)
      smelt()
     UO.LObjectID = saveID
      UO.LTargetKind = saveK
      UO.LTargetTile = saveT
      UO.LTargetID = saveTar
      UO.LTargetX = saveX
      UO.LTargetY = saveY
      UO.LTargetZ = saveZ
     end
   return
end

-- Smelt and store chunk

function smelt()
local all = {}
for i, ii in pairs(scan(smet)) do
    if ii.tp == smet[1] then
       table.insert(all, {id = ii.id, stack = ii.stack})
    end
end
if not next(all) then
   UO.SysMessage("You weight too much, and I can't smelt anything.  Goodbye.")
   stop()
end
reDump(all)
    
local grn, met = {}, {}
    for i, ii in pairs(scan(smet)) do
        if ii.tp == smet[3] then
               table.insert(met, {id = ii.id})
           elseif ii.tp == smet[2] then
               table.insert(grn, {id = ii.id})
        end
    end
if next(met) then
   UO.LObjectID = mKey[1].id
   reStore(met)
end
killGump()
if next(grn) then
   UO.LObjectID = sKey[1].id
    reStore(grn)
end
killGump()
return
end


function reDump(ore)
UO.TargCurs=false
UO.LTargetKind = 1
UO.LTargetID = forge[1].id
--local oldRef = 0
for i,ii in pairs(ore) do 
    local wgt= UO.Weight
    UO.LObjectID = ii.id
    while not UO.TargCurs do
          timer=getticks()+250
          UO.Macro(17,0)
          while timer>getticks() do
                if UO.TargCurs then break end
          end
    end
    while UO.TargCurs do UO.Macro(22,0) end
    timer=getticks()+250
    while timer>getticks() do
        local status=journal(smlog)
          if status>1  then break
          elseif  wgt > UO.Weight then break
          end
    end      
end
UO.TargCurs=false
killGump()
return
end

function reStore(tbl)
UO.TargCurs=false
--local wgt = UO.Weight
--local timer=getticks()
killGump()
UO.Macro(17,0)
 while UO.ContSizeX ~= 505 and UO.ContSizeY ~= 270 and UO.GetPix(UO.ContPosX+246,UO.ContPosY+34)~=15193649 do end
   while not UO.TargCurs do
         timer=getticks()+100
         UO.Click(UO.ContPosX +290,UO.ContPosY+235,true,true,true,false)
         while timer>getticks() do if not UO.TargCurs then break end end
    end
   UO.LTargetKind =  1
for i,ii in pairs(tbl) do 
    UO.LTargetID = ii.id
    while not UO.TargCurs do end 
    UO.Macro(22,0)
end
UO.TargCurs=false
killGump()
return
end       


function killGump()
while true do
local x,y=findCont(505, 270)
if x then UO.Click(x+505/2, y+270/2, false, true, true, false)  end
local x,y=findCont(452, 236)
if x then UO.Click(x+452/2, y+236/2, false, true, true, false) end
if not x then break end
end
 return
 end
 
 function findCont(x,y)
for i=0, 20 do
     local a,nx,ny,nsx,nsy = UO.GetCont(i)
     if a==nil then return false
     elseif nsx==x and nsy==y then
      return nx, ny
     end
end
    return false
end
 
function journal(msg)
oldRef, jourCnt = UO.ScanJournal(oldRef)
    for i=jourCnt-1,0,-1 do
         local lines= UO.GetJournal(i)
         for ii,iii in pairs(msg) do
             if string.match(lines, iii) then return ii end
         end             
    end  
    return 0
end


 function Main(bNext)
 local runCnt, rune=0,1
 while bNext <= #bRune do
bNext, rune = bNext + 1, 1
 openBook(bNext)
 runCnt = runeCount()
 UO.SysMessage("Runes: "..runCnt)
 while rune <= runCnt do
 if rune ~= 1 then
    openBook(bNext)
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
 

-- Begin

init()
Main(0)