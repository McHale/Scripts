--User Variables -- EDITING MAY CAUSE INSTABLILITY
waitVar = 0 -- Set high for saftey, low for speed
         -- Miliseconds (1000) = 1 second

-- Global variables
runCnt, cTool, mCnt, bRune, mTool, gIngot, next,gloCnt, oldX, oldY = 0, 0, 0, {}, {}, {6009, 7154}, false, 1, {}, {}
mineabletiles = {}
mineabletiles = {
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
 cavetiles = {}
 cavetiles = {2,475,430,2028}
 
    --UO.Key("I", false, true, false)
   --wait(500)
   --UO.Key("S", false, true, false)
-- Runebook array
for i=0, UO.ScanItems(false)-1,1 do
    local id,typ,kind,contid,x,y,z,stack,rep,col = UO.GetItem(i)
    local bIgnore = false
    if (typ == 8901) and contid == UO.BackpackID then
       for ii=0,runCnt do
           if id == bRune[ii] then
              local bIgnore = true
           end
        end
        if bIgnore == false then
           bRune[runCnt] = id
           runCnt = runCnt + 1                
        end
    end
end

if runCnt == 0 then
   UO.SysMessage("No runebooks found... aborting.")
   stop()
else
    UO.SysMessage("Runebooks: "..runCnt)
end

-- Find resource keys
for i=0, UO.ScanItems(false)-1,1 do
    local id,typ,kind,contid,x,y,z,stack,rep,col = UO.GetItem(i)
    if typ == 5995 and contid == UO.BackpackID then
       local name, info = UO.Property(id)
       if name == "Metal Worker's Keys" then
          mKey = true
          repeat
          local gTest = 0
          while UO.LObjectID ~= id do
             UO.LObjectID = id
          end
          wait(200)
          UO.Macro(17,0)
          for i=0 , 20 do
              if UO.ContName == "generic gump" and UO.ContSizeX == 505 then
                 break
              end
              wait(20)
          end
          wait(500)
          UO.ContPosX = 800
          UO.ContPosY = 10
          wait(500)
          local gTest = UO.GetPix(1090, 245)
          until gTest == 10268077
    elseif name == "Stone Worker's Keys" then
          sKey = true
          repeat
          local gTest = 0
          while UO.LObjectID ~= id do
             UO.LObjectID = id
          end
          wait(200)
          UO.Macro(17,0)
          for i=0 , 20 do
              if UO.ContName == "generic gump" and UO.ContSizeX == 505 then
                 break
              end
              wait(20)
          end
          wait(500)
          UO.ContPosX = 800
          UO.ContPosY = 300
          wait(500)
          local gTest = UO.GetPix(1090, 535)
          until gTest == 10268077
    end
    end
end

if mKey == false then
   UO.SysMessage("No keys found, aborting...")
end

--Find mobile forge
for i=0, UO.ScanItems(false)-1,1 do
    local id,typ,kind,contid,x,y,z,stack,rep,col = UO.GetItem(i)
    if typ == 3634 and contid == UO.BackpackID then
       forge = id
       break
    end
end
if forge == nil then
   UO.SysMessage("No mobile forge found.")
   stop()
end

-- Mining tool array
for i=0, UO.ScanItems(false)-1,1 do
    local mIgnore = false
    local id,typ,kind,contid,x,y,z,stack,rep,col = UO.GetItem(i)
    if typ == 3897 or typ == 3718 then
       for ix=0, mCnt do
           if id == mTool[ix] then
              mIgnore = true
              break
           end
       end
       if mIgnore == false then
          mTool[mCnt] = id
          mCnt = mCnt + 1
       end 
    end
end

if mCnt == 0 then
   UO.SysMessage("No shovels found, aborting...")
   stop()
else
    UO.SysMessage("Shovels found: "..mCnt)
end

-- Recall chunk
bSuc = function(page, side, bNext, nextPage)
repeat
if nextPage == 2 then
   nextPage = 0
   page = page + 1
   if page == 8 then
      page = 0
      if bNext +1 == runCnt then
         bNext = 0
      else
          bNext = bNext + 1
      end
   end
end
wTest()
   local curLoc=  UO.CharPosX..UO.CharPosY
   while UO.LObjectID ~= bRune[bNext] do
         UO.LObjectID = bRune[bNext]
   end 
   UO.Macro(17,0)
   wait(300)
   for i=0 , 20 do
       if UO.ContName == "generic gump" and UO.ContSizeX == 230 then
          break
       elseif UO.SysMsg == "This book needs time to recharge." then
          wait(1000)
          UO.Macro(17,0)
          i = 0
       end
       UO.ContTop(i)
       wait(50)
   end
   for i=0, 20 do
       UO.ContPosY = 100
       UO.ContPosX = 100
       if UO.GetPix(240, 125) == 1579107 then
          break
       end
       wait(50)
   end
      if page < 4 then
         clickX = 240 + (page * 35)
      else
          clickX = 410 + (page * 35)
      end
      wait(200)
      UO.Click(clickX ,300, true, true, true,false)
      for i=0, 20 do
          if UO.GetPix(375, 210) == 2173225 then
             break
          end
       wait(50)
       end
       wait(200)
      if side == true then
         clickX, side = 240, false
         side = false
      else
          clickX, side = 400, true
      end
      UO.Click(clickX ,245, true, true, true,false)
   for i=0, 10 do
       if curLoc ~= UO.CharPosX..UO.CharPosY then
          gather()
          nextPage = nextPage + 1
          break
       end
       wait(500)
   end
   until allEnd == true
   print("Error log:")
   print("contname: "..UO.ContName.."contkind: "..UO.ContKind)
   UO.SysMessage("Recall failed, report error log to dev.")
end

-- Resource locator chunk
function find(reset)
repeat
   if reset == true then
      for i=1, #oldX do
          oldX[i], oldY[i] = nil, nil
          gloCnt = 1
      end
   end
   for ii=0, 1000 do
       xOff, yOff = offset(oldX, oldY)
       if xOff ~= false then
      local locX, locY = (UO.CharPosX + xOff), (UO.CharPosY + yOff)
      local tileData = UO.TileInit(false)
      local tileCnt = UO.TileCnt(locX, locY)
      for i=0, (tileCnt-1) do
         local TType, ZZ, NName, FFlags = UO.TileGet(locX ,locY, tileCnt)
         if ZZ < 5 then
         for t in pairs(mineabletiles) do
             if TType == mineabletiles[t] then
               return TType, ZZ, locX, locY, 2
            end
         end
         for tt in pairs(cavetiles) do
              if TType == cavetiles[t] then
               return TType, ZZ, locX, locY, 2
             end
         end
         end
      end
      oldX[gloCnt], oldY[gloCnt] = xOff, yOff
      gloCnt = gloCnt + 1
      else
          print("Error log:")
          print("charX: "..UO.CharPosX.."charY: "..UO.CharPosY)
          UO.SysMessage("Unable to find resources. See error log.")
          stop() 
      end    
   end
until endit == true
end

-- Rnd func
function offset(tableX, tableY)
repeat
local same = false
local total = 0                                                
a, b = math.random(-3, 3) ,math.random(-2, 2)
for i=1, #tableX do
    if a == tableX[i] and b == tableY[i] then
       local same = true
       break
    end
end
if same == false then
   return a, b
end
until endit == true
return false
end

-- Miner chunk
function gather()
local theEnd = false
sGood = false
repeat
   if sGood == false then
      local tTile, zTile, xTile, yTile, mKind = find(next)
      UO.LObjectID = mTool[cTool]
      UO.LTargetKind = mKind
      UO.LTargetTile = tTile
      UO.LTargetX = xTile
      UO.LTargetY = yTile
      UO.LTargetZ = zTile
   end
      if wTest() == true then
         if gloSave ~= nil then
          UO.LTargetKind = gloK
          UO.LTargetID = gloSave
          UO.LObjectID = mTool[cTool]
         end
         wait(500)
      end  
      wait(100)
      UO.Macro(17,0)
      for i=1, 10 do
         if UO.TargCurs == true then
            break
         end
         wait(50)
      end
      wait(200)
      local oldWgt = UO.Weight
      local jourRef, jourCnt = UO.ScanJournal(0)
      local oldRef = jourRef
      UO.Macro(22,0)
      wait(50)
      for i=0, 100 do
          local jourRef, jourCnt = UO.ScanJournal(oldRef)
          if oldRef ~= jourRef then
             local lines = UO.GetJournal(0)
             local oldRef = jourRef
             if string.match(lines, "no metal") ~= nil then
                local theEnd = true
                next = true
                    return
             elseif string.match(lines, "You put some ") ~= nil then
                    sGood, gloSave, gloK = true, UO.LTargetID,UO.LTargetKind
                    next = true
                break
             elseif UO.Weight > oldWgt then
                    sGood, gloSave, gloK = true, UO.LTargetID,UO.LTargetKind
                    next = true
                break
             elseif string.match(lines, "while riding.") ~= nil then
                    UO.SysMessage("You are on a horse.  You should not be on a horse.")
                    stop()
             elseif string.match(lines, "You loosen some rocks") ~= nil then
                    sGood, gloSave, gloK = true, UO.LTargetID,UO.LTargetKind
                    next = true
                break
              elseif string.match(lines, "You carefully") ~= nil then
                    sGood, gloSave, gloK, next = true, UO.LTargetID,UO.LTargetKind, true
                    break
             elseif string.match(lines, "That is too far away.") ~= nil then
                    sGood= false
                break
             elseif string.match(lines, "You can't mine there.") ~= nil then
                    sGood= false
                    break
             elseif string.match(lines, "Target cannot be seen.") ~= nil then
                    sGood = false
                break
             end
          end
          sGood = false
          wait(20)
      end
      wait(200)
   until theEnd == true
end



      
--Weight test      
wTest = function()
if UO.Weight == 0 then
   UO.SysMessage("You do not have your status open.")
   stop()
elseif UO.Weight > UO.MaxWeight then
      smelt()
      return true
   elseif UO.Weight > 400 then
      smelt()
      return true
   else
       return false
   end
end
   
-- Smelt and store chunk
smelt = function()
UO.LTargetKind = 1
UO.LTargetID = forge
   for i=0, UO.ScanItems(false)-1,1 do
       local id,typ,kind,contid,x,y,z,stack,rep,col = UO.GetItem(i)
       if typ == 6585 and contid == UO.BackpackID then                         
          gloNext = false
          while UO.LObjectID ~= id  do
             UO.LObjectID = id
          end
          while gloNext == false do
          local weight = UO.Weight
             wait(500)
             UO.Macro(17,0)
             for i=0,10 do
                if UO.TargCurs == true then
                   break
                end
                wait(15)
             end
             wait(200)
             UO.Macro(22,0)
             wait(100)
             local oldRef = 0
             for i=0,20 do
                 local jourRef, jourCnt = UO.ScanJournal(oldRef)
                 if oldRef ~= jourRef then
                    local lines = UO.GetJournal(0)
                    local oldRef = jourRef
                    if string.match(lines, "You smelt the ore ") ~= nil then    
                       gloNext = true
                       break
                    elseif string.match(lines, "You burn away the impurities ") and stack > 1 ~= nil then 
                       gloNext = false
                       break
                    elseif  i >18 then
                       gloNext = true
                       break
                    end           
                 end
                 wait(50)
             end
          end
       end
   end
   for i=0, UO.ScanItems(false)-1,1 do
       local id,typ,kind,contid,x,y,z,stack,rep,col = UO.GetItem(i)
       for ix=1,2 do
           if typ == gIngot[ix] and contid == UO.BackpackID then
              UO.LTargetKind = 1
              UO.LTargetID = id
              if typ == 6009 then
                 stAdd = 300
              else
                  stAdd = 10
              end
              for ii=0,10 do
                  if UO.GetPix(1090, (stAdd +235)) == 10268077 then
                     break
                  end
                  wait(50)
              end 
              UO.Click(1090, stAdd+235, true, true, true, false)
              for xi=0,10 do
                  if UO.TargCurs == true then
                     break
                  end
                  wait(20)
              end
              wait(300)
              UO.Macro(22,0)
              wait(500)
              repeat
              local colour = 0
                 UO.ContPosX = 800
                 UO.ContPosY = (stAdd)
                 wait(50)
                 local colour = UO.GetPix(1090, (stAdd +235))
              until colour == 10268077
              wait(500)
           end
       end
   end
return
end

   

-- Begin
bSuc(0, true, 0, 0)    
   
   
   

                        