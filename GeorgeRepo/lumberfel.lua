local mx,my,mc=0,0,0
local axe=1080804848
local oldRef=UO.ScanJournal(0)
local tileData = UO.TileInit(false)
local timer
local digmsg={"You put some ", "You found ", "fail to find any",
               "There's not enough wood", "That is too far away.",  
               "Target cannot be seen.", "can't use an axe on that",
               "You have worn out your tool!"} 
function main()
while true do
if mx~=UO.CharPosX or my~=UO.CharPosY or mc~=UO.CursKind then
wait(500)
   gather(find())
   mx,my,mc=UO.CharPosX,UO.CharPosY,UO.CursKind
end
end
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
UO.ExMsg(UO.CharID,3,68,"Tree found.")
local bol=false       
local obj,targ,tk=UO.LObjectID,UO.LTargetID,UO.LTargetKind
   for i,ii in pairs(tbl) do
       local oldWgt = UO.Weight
          local status=usePick()
          UO.LTargetKind=ii.k
         UO.LTargetTile=ii.t
         UO.LTargetX=ii.x
         UO.LTargetY=ii.y
         UO.LTargetZ=ii.z
          while true do
          if UO.TargCurs then UO.Macro(22,0) end
             if status==8 then stop()
               --elseif status==7 then UO.LTargetKind=cnt%4 cnt=cnt+1
               elseif status>=4 then break
               elseif status~=0 or oldWgt~=UO.Weight then bol=true
            end
            if bol then status=usePick() bol=false oldWgt=UO.Weight
            else status=journal(digmsg)
            end
            wTest(ii.k,ii.t,ii.x,ii.y,ii.z)
          end
          
   end
UO.LObjectID=obj
UO.LTargetKind=tk
UO.LTargetID=targ
UO.ExMsg(UO.CharID,3,68,"Tree harvested.")
return
end
       
       
       
function usePick()
UO.LObjectID=axe
UO.Macro(17,0)
timer=getticks()+500
while true do
   if UO.TargCurs then break
   elseif timer<getticks() then
             UO.LObjectID=axe
             UO.Macro(17,0)
             timer=getticks()+500
   end
end
return journal(digmsg)
end

function scan()
local result={}
 for i=0, UO.ScanItems(false)-1,1 do
      local nid,typ,_,contid=UO.GetItem(i)
       if contid==UO.BackpackID and typ==7133 then
          table.insert(result,nid)
       end
 end
return result
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

function wTest(kind, tile, ox, oy, oz)
while UO.Weight==0 do end
--if math.min(365, UO.MaxWeight-25)<=UO.Weight-gwt then
if UO.Weight>=350 then
      UO.TargCurs = false
      reStore(scan())
      UO.LTargetKind=kind
      UO.LTargetTile=tile
      UO.LTargetX=ox
      UO.LTargetY=oy
      UO.LTargetZ=oz
end
   return
end

function reStore(tbl)
UO.LObjectID=1100900732
UO.Macro(17,0)
timer=getticks()+500
while true do
if UO.ContSizeX==505 then break
elseif timer<getticks() then
   UO.LObjectID=1100900732
   UO.Macro(17,0)
   timer=getticks()+500
end
end
         UO.Click(UO.ContPosX+290,UO.ContPosY+260,true,true,true,false)
         timer=getticks()+250
         while true do 
            if UO.TargCurs then break
            elseif timer<getticks() then
                  UO.Click(UO.ContPosX+290,UO.ContPosY+260,true,true,true,false)
               timer=getticks()+500
            end 
         end
for i,ii in pairs(tbl) do 
    UO.LTargetKind=1
    UO.LTargetID=ii
    while not UO.TargCurs do end 
    UO.Macro(22,0)
end
--waitGump(var,int+2)
if UO.TargCurs then UO.TargCurs=false end
return
end       

main()