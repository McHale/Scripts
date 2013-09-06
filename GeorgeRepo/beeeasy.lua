                   --==========================================================
-- Script Name: Bee Tending Application
-- Author: Themadxcow
-- Version: 1.5.5
-- OpenEUO version tested with: 0.91
-- Purpose: Tending and Harvesting Bee Hives
--==========================================================
local gwait = 1000
--3701 cont/sprinkler
local colours={59367, 6375, 59160}
        --|yellow|red|green
local exmess={68, 153, 34}
        --green|yellow|red
local offset = {a={x=35, y=54}, b={x=175, y=23, stat=15}, c={x=285, y=165}}
local gump={{x=258, y=219, cx=78, cy=176, c=526344}, {x=178, y=178, cx=75, cy=9, c=532810}, {x=250, y=219, cx=130, cy=68, c=526344}, {x=505, y=475}}
        --sx main hive|sy main hive| sxsy pour|sx collect|sx key|sy key|
local pixel=15724502
local storage = {2448, 2473, 2474, 2475, 2482, 2717, 3648, 3649, 3650, 3651,
                 3701, 3702, 3703, 3705, 3706, 3708, 3709, 3710, 3791,
                 9002, 9431, 9435, 10257, 10258, 11759, 11761, 11762, 11764}
local tools={2330, 2549, 2532,  3921, 2532, 5995, 3847, 3848, 3849, 
             3850, 3852, 3854}
local reso={2540, 5154}
local beedb={}
--gump= 83x41   17064/ opened 344 241
        --|2330 bee|2549 hive tool|
--3854 emp bot
local potion = {{3848,"Greater Agility"},{3850,"Greater Poison"},
               {3847, "Greater Cure"}, {3852,"Greater Heal"}, {3849,"Greater Strength"}}
--local blank = {3221801, 1589842, 3748145, 4340025, 8497, 4337969, 2695457}
local blip = {4342461,4868797,4342453,5395142,1579148,1052812,526443,2171292,1052804}

local pathfail={"Can't get there"}
local pfail={"The keg is empty.", "do not have any of that resource!"}
local psuccess={"You pour some of the keg's", "and place it into your backpack"}
local bfail={"You don't have any strong","beehive is already soaked"}
local bsuccess={"You pour the potion into the beehive"}
local gfail={"You do not have any"}
local state={"Healthy", "Sickly", "Dying"}
local refail={"place it in your pack", "There isn't enough"}
local broke={"You wear out the"}
local dead={"Corpse"}
local baditem={"Holding", "Sending", "Trash", "Gem Pouch", "Seed Box", "Exex Deposit Box"}

local keg,  bee, waxpot, waxtool, hivetool, bee, database ={},{},{},{},{},{},{}
local empty, key, tcnt  = 0, 0, 1
local kegtp, pot={0,0,0,0,0},{0,0,0,0,0}
local harvest, getbot, huge=true, false, nil
local next=next

function init()
UO.Macro(8,1)
killBee()
UO.Macro(8,7)
oldRef=UO.ScanJournal(0)
if findBeeFood()==0 then UO.SysMessage("I have not found all five keg types.  Please close all containers and restart.") stop()
else UO.SysMessage("Found "..#keg.." potion kegs.") end 
return
end 

function scan(tbl)
local item = {}
for i=0, UO.ScanItems(true)-1,1 do
     local nid,typ,kind,contid,xu,yu,zu,stck = UO.GetItem(i)
     if typ==2331 then UO.HideItem(nid)
     else 
         for ii,iii in pairs(tbl) do
              if typ == iii then
                 local bol=true
                  local nma, inf = UO.Property(nid) 
                  for del,msg in pairs(baditem) do
                      if string.match(nma, msg) then bol=false break end
                  end
                  if bol then
                  if kind==1 and math.abs(UO.CharPosZ-zu)<=15 and zu>=UO.CharPosZ  then
                    dir=getDist(xu, yu)
                  else dir=999 
                  end
                  table.insert(item, {id=nid, tp=typ, k=kind, cont=contid, dist=dir, x=xu, y=yu, stack=stck, name=nma, info=inf})
                  end
              end
         end
     end
end     
    table.sort(item, function(a,b) return a.dist<b.dist end)
    return item
end

function journal(msg, mfail)
oldRef, jourCnt = UO.ScanJournal(oldRef)
    for i=jourCnt-1,0,-1 do
         local lines= UO.GetJournal(i)
         for ii,iii in pairs(msg) do
             if string.match(lines, iii)~=nil then return ii end
         end             
         for ii,iii in pairs(mfail) do
             if string.match(lines, iii)~=nil then return 0-ii end
         end
    end  
    return 0
end


function findTools(main, pack)
for i,item in pairs(scan(main)) do
   if item.k==0 then
      if item.tp == 5995 and item.name == "Spell Caster's Keys" then
         UO.SysMessage("Spell Keys found!")
         key = item.id
      elseif item.tp == 2532 then
         table.insert(waxpot, {id=item.id, use=string.match(item.info, "%d+")})
      elseif item.tp == 3921 then
         table.insert(waxtool, {id=item.id, use=string.match(item.info, "%d+")})
      elseif item.tp == 2549 then
         table.insert(hivetool, {id=item.id, use=string.match(item.info, "%d+")})
      elseif item.tp == 3854 then 
         if string.match(item.name, "Empty Bottle")~=nil then empty=empty+item.stack
         else 
            for i,ii in pairs(potion) do
               if item.tp == ii[1] then pot[i]=pot[i]+1 break end
            end           
         end
      end
   elseif item.tp == 2330 then
      if string.match(item.info, "Empty")~=nil then 
         UO.ExMsg(item.id,3,colours[5],"Dead bees =(.")
         UO.HideItem(item.id)                             
      else table.insert(bee, {id=item.id, name=item.name, use=tonumber(string.match(item.info,"%d+", 22)), age=tonumber(string.match(item.info,"%d+", 11)), x=item.x, y=item.y, dist=item.dist})
      end
   end
end
if next(bee)==nil then UO.SysMessage("There appear to be no bees near, bee tending complete!") stop() else
   table.sort(bee, function(a,b) return a.dist<b.dist end)
    UO.SysMessage("Found "..#bee.." bee hives") end
if next(waxpot)==nil then UO.SysMessage("No wax pots found.") else
	UO.SysMessage("Found "..#waxpot.." wax pot.") end
if next(waxtool)==nil then UO.SysMessage("No wax tool found.") else
	UO.SysMessage("Found "..#waxtool.." wax tool.") end
if next(hivetool)==nil then 
   UO.SysMessage("No hive tool found.  Harvesting disabled.")
   harvest=false
else
    UO.SysMessage("Found "..#hivetool.." hive tools.") end
return true
end

function findBeeFood()
UO.SysMessage("Searching for bee supplies...")
--local open=findCont(0)
local open={}
local store=scan(storage)
  for i,ii in pairs(store) do
    if ii.id==UO.BackpackID then 
       gwt=math.abs(string.match(ii.info, "%d%d?", 3)-UO.Weight)
    end
    if ii.cont==UO.BackpackID then
       if string.match(ii.name, "Holding") then huge=ii.id end
       if openCont(ii.id)==1 then 
          table.insert(open, {id=ii.id, x=ii.x, y=ii.y, sx=UO.ContSizeX, sy=UO.ContSizeY, name=ii.info})
       end
    end
  end
  if not findTools(tools, open) then killCont(#open) return 0
  elseif findKeg(open)>=#potion-1 then killCont(#open) return 1 
  end
  open={}
  getbot=true
  for i,ii in pairs(store) do
      if getDist(ii.x, ii.y)>2 and ii.dist<999 then
         if i>1 then 
             for i=10, 30 do
                 if findKeg(open)>=#potion-1 then killCont(#open) return 1 end
                 wait(i)
             end
             killCont(#open)
             open={}
         end
         movePath(ii.x, ii.y)
     elseif ii.dist>=999 then break end 
     if openCont(ii.id)==1 then 
         table.insert(open, {id=ii.id, x=ii.x, y=ii.y, sx=UO.ContSizeX, sy=UO.ContSizeY}) 
     end
  end
if next(open)~= nil then
   for i=10, 30 do
      if findKeg(open)>=#potion-1 then killCont(#open) return 1 end
      wait(i)
   end
end
return 0
end

function findKeg(cur)
local result=0
    for i,item in pairs(scan({6464})) do
         for ii=1, #potion do
              if string.match(item.name, potion[ii][2]) then
                  for iii,iv in pairs(cur) do
                        if iv.id == item.cont then
                            table.insert(keg, {id=item.id, name=item.name, use=item.info, cont=item.cont, x=iv.x, y=iv.y, sx=iv.sx, sy=iv.sy})
                            print("keg: "..item.id)
                            if ii%5>0 then
                               result=result+1-kegtp[ii]
                            end
                            kegtp[ii]=1
                            break  
                        else
                            UO.SysMessage("Script error, please report: "..item.name.." "..item.cont)
                            stop()
                        end
                  end
              end
         end
    end
    print(result)
return result
end

function getDist(x,y) return math.max(math.abs(UO.CharPosX-x),math.abs(UO.CharPosY-y)) end

function movePath(x,y)
local varm = math.max(x-UO.CharPosX,y-UO.CharPosY)
        local varx,vary=x,y
local pos=UO.CharPosX+UO.CharPosY	   
    for t=0,10 do
    UO.Move(x,y,2,500)
    if getDist(x, y)<=2 then return 1
    elseif UO.CharPosX+UO.CharPosY==pos then
             --UO.Move(x+math.random(t*(-1),t),y+math.random(t*(-1),t),2, 500-t*25)
             unStuck(x,y,t)
    elseif UO.CharPosX+UO.CharPosY~=pos then
          pos=UO.CharPosX+UO.CharPosY 
    end
end
  for t=0,10 do   
  UO.Pathfind(x,y,UO.CharPosZ)
  wait(500-t*25)
        if getDist(x, y)<=2 then return 1
        elseif journal(pathfail, pathfail) ~=0 then break
            --UO.Pathfind(x+math.random(t*(-1),t),y+math.random(t*(-1),t),UO.CharPosZ)
            --wait(500-t*25)
            
        elseif UO.CharPosX+UO.CharPosY==pos then 
            unStuck(x,y,t)
        elseif UO.CharPosX+UO.CharPosY~=pos then
              pos=UO.CharPosX+UO.CharPosY 
        end
end
local mx=""                  
local my=""
if x>UO.CharPosX then mx=" east "
elseif x< UO.CharPosX then mx=" west " end
 if y>UO.CharPosX then my=" north "          
elseif y< UO.CharPosX then my=" south " end 
UO.ExMsg(UO.CharID, colour[3],"I am lost.  Please direct me"..my..mx..". I will take over automatically soon.")
while getDist(x, y)>2 do
    wait(20)
end
UO.SysMessage("Subject found, resuming normal operations.")
return 1 
end

function unStuck(x, y, int)
local dir=0
--local var=0
for i=0,3+int do
local var=0
local curx=UO.CharPosX
local cury=UO.CharPosY
--while getDist(x, y)>2 do
if getDist(x,y)<=2 then return end
print("we are moving "..var.." d "..dir)
     if curx< x and cury> y then var=unStuckSub(7%dir,x,y)
elseif curx==x and cury> y then var=unStuckSub(7%(dir+1),x,y)
elseif curx> x and cury> y then var=unStuckSub(7%(dir+2),x,y)
elseif curx> x and cury==y then var=unStuckSub(7%(dir+3),x,y)
elseif curx> x and cury< y then var=unStuckSub(7%(dir+4),x,y)
elseif curx==x and cury< y then var=unStuckSub(7%(dir+5),x,y)
elseif curx< x and cury< y then var=unStuckSub(7%(dir+6),x,y)
elseif curx< x and cury==y then var=unStuckSub(7%(dir+7),x,y)   
--[[    if curx< x and cury> y then UO.Macro(5,0)
elseif curx==x and cury> y then UO.Macro(5,1)
elseif curx> x and cury> y then UO.Macro(5,2)
elseif curx> x and cury==y then UO.Macro(5,3)
elseif curx> x and cury< y then UO.Macro(5,4)
elseif curx==x and cury< y then UO.Macro(5,5)
elseif curx< x and cury< y then UO.Macro(5,6)
elseif curx< x and cury==y then UO.Macro(5,7)    ]]--
end
dir=dir+(7-i+var)
end
end

function unStuckSub(dir,x,y)
for i=1,2 do
curx=UO.CharPosX
cury=UO.CharPosY
--local cdir=UO.CharDir
UO.Macro(5,dir)
    for i=0,25 do
        wait(i)
        if curx~=UO.CharPosX or cury~=UO.CharPosY then break end
    end
    
   if getDist(x, y)<=2 then return 0 end
end
return 1
end


function findCont(x, y)
local timer=getticks()+gwait
local result
if x==0 then result={}
else result=0
end
for i=0, 25 do
     local a,nx,ny,nsx,nsy = UO.GetCont(i)
     if a==nil then return result
     elseif x==0 then table.insert(result, {id=a, sx=nsx,sy=nsy})
     elseif nsx==x and nsy==y then
             --for ii=i, 0,-1 do
                if UO.ContSizeX..UO.ContSizeY~=x..y then UO.ContTop(i) end
             --end
      return nx..ny
     end
end
    return result
end

function getPot(index, num)
local result, tmp = 0,0
for i,ii in pairs(keg) do 
     if string.match(ii.name, potion[index][2]) ~= nil then
        UO.LObjectID=ii.id
        while getDist(ii.x, ii.y)>2 or findCont(ii.sx, ii.sy)==0 do
           movePath(ii.x, ii.y)
           openCont(ii.cont) 
        end
        UO.LObjectID=ii.id
        while result <num do
        local timer=getticks()+250
              tmp=useItem(psuccess, pfail)
              if tmp==-1 then table.remove(keg, i) killCont(1) return result
              elseif tmp==1 then
                     result=result+1 
                     empty=empty-1
              end
              while timer>getticks() do end
             
         end
         if UO.ContSizeX..UO.ContSizeY==ii.sx..ii.sy then
         killCont(1)
         end
         return result
     end
end
UO.SysMessage("Unable to locate more potions, terminating...")
stop()
end

function checkPot(index, num)
if empty<num then getEmpty() end
while pot[index]<num do pot[index]=pot[index]+getPot(index,num) end
return
end

function useItem(str, f)
local tmp=0
while tmp==0 do
      local timer=getticks()+500
    UO.Macro(17,0)
    while timer>getticks() do
          tmp=journal(str, f)
          if tmp~=0 then return tmp end
    end
end
return tmp
end

function useBee(id,x,y)
while getDist(x, y)>2 do
	movePath(x, y)
end
for i=10,30 do
UO.LObjectID=id
    UO.Macro(17,0)
    wait(i)
        if UO.ContSizeX..UO.ContSizeY==gump[1].x..gump[1].y then return 1 end
end
return 0
end

function getEmpty()
local old=empty
if key==nil then UO.SysMessage("No keys found and not enough bottles..") end
--while UO.LObjectID~=key do  end
for i=10,35 do 
   UO.LObjectID=key
   UO.Macro(17,0)
   wait(i)
   if UO.ContSizeX..UO.ContSizeY==gump[4].x..gump[4].y then 
      for t=10,35 do
          UO.Click(UO.ContPosX+offset.c.x, UO.ContPosY+offset.c.y,true,true,true,false)
          wait(i+t)
          if journal(pfail, pfail) ~= 0 then UO.SysMessage("We have run out of bottles.") stop()
          else tmp = scan({3854})
          end
      if #tmp>=1 then 
         for ii,iii in pairs(tmp) do
             if iii.cont ==UO.BackpackID and iii.stack>old then
                empty=iii.stack
                while UO.ContSizeX~=gump[4].x do wait(t+i) end
                killCont(1)
                UO.TargCurs=false
                return
             end
         end
      end
      end
   stop()
   end
end  
UO.TargCurs=false
UO.SysMessage("Script error, please report: "..key)
stop()
end

function openCont(id)
UO.LObjectID=id
for i=0, 7 do
print(i)
         timer=getticks()+250
        UO.Macro(17,0)
        while timer>getticks() do
        if UO.ContID==id then return 1 end
        end
end
return 0
end

function hitButton(x,y, int)
local pos=UO.ContPosX..UO.ContPosY
local timer = getticks()+gwait
while timer>getticks() do
    if UO.ContSizeX..UO.ContSizeY==gump[int].x..gump[int].y
	and UO.GetPix(UO.ContPosX+gump[int].cx,UO.ContPosY+gump[int].cy)==gump[int].c then
        UO.Click(UO.ContPosX+x, UO.ContPosY+y,true,true,true,false)
	break
    end
end
while timer>getticks()  do
	if UO.ContSizeX..UO.ContSizeY~=pos 
	and UO.GetPix(UO.ContPosX+gump[int].cx,UO.ContPosY+gump[int].cy)~=gump[int].c then return 1 end
end
return 0
end

function killCont(int)
for i=1,int do
    local cur, cursx, curx =UO.ContID, UO.ContSizeX, UO.ContPosX   
    while UO.ContID==cur and UO.ContSizeX==cursx and UO.ContPosX==curx do
        UO.Click(UO.ContPosX+UO.ContSizeX/2, UO.ContPosY+UO.ContSizeY/2, false, true, true, false)
    end
end
return int
end  

function killBee()
local bang,shot,kill=0,0,1 
for i=0,25 do
    if findCont(gump[2].x,gump[2].y)==0 then break end
    UO.Click(UO.ContPosX+UO.ContSizeX/2, UO.ContPosY+UO.ContSizeY/2, false, true, true, false)
    bang=bang+1
end  
for i=0,25 do
        kill=findCont(gump[1].x,gump[1].y)
    if kill==0 and shot>=bang then break end
    if kill~=0 then
        UO.Click(UO.ContPosX+UO.ContSizeX/2, UO.ContPosY+UO.ContSizeY/2, false, true, true, false)
        shot=shot+1
    else
         wait(i)
    end
end  
for i=0,25 do
    if findCont(gump[3].x,gump[3].y)==0 then return end
        UO.Click(UO.ContPosX+UO.ContSizeX/2, UO.ContPosY+UO.ContSizeY/2, false, true, true, false)
end    
end

function feedBee(int, num,mx,my)
if getbot then checkPot(int,num) end
while getDist(mx, my)>2 do
   movePath(mx,my)
end
local amt=0
local out=false
for c=0,num do
     for t=0,25 do
          if UO.ContSizeX..UO.ContSizeY ==gump[1].x..gump[1].y  then break
          elseif UO.ContSizeX..UO.ContSizeY ==gump[2].x..gump[2].y then out=true break end
     end
     --print("DOING "..pot[int].." FOR "..num.." DID "..c)
     if out==false then
         hitButton(offset.a.x+offset.b.x, offset.a.y+(24.75*(int-1)),1)
     else out=false
     end
         for i,ii in pairs(dotArray()) do
              for iii=1,25 do
                    if UO.ContSizeX..UO.ContSizeY==gump[1].x..gump[1].y
                        and findCont(2)==0 then out=true break
                    elseif UO.GetPix(UO.ContPosX+75,UO.ContPosY+9)==532810 
                        and UO.ContSizeX..UO.ContSizeY==gump[2].x..gump[2].y then break 
                    end
              wait(iii)
              end
         if out==true then break 
         else out=false 
         end
         UO.Click(ii[1],ii[2],true,true,true,false)
     end
     for t=10, 30 do            
         status=journal(bsuccess, bfail)
         if status==1 then 
             if getbot then pot[int]=pot[int]-1 end
             empty=empty+1
             amt=amt+1
             break 
         elseif status==-1 then print(potion[int][2].." ERROR wants "..num) stop()
         --elseif t>45 and UO.ContSizeX..UO.ContSizeY==gump[2].x..gump[2].y then
         wait(t)
         end
     end
     if amt==num then break end
end
for i=0,25 do
     if UO.ContSizeX..UO.ContSizeY==gump[1].x..gump[1].y then return amt
     elseif UO.ContSizeX..UO.ContSizeY==gump[2].x..gump[2].y then break end
     wait(i)
end
return amt
end

function dotArray()
for t=1,25 do
    if UO.ContSizeX..UO.ContSizeY==gump[2].x..gump[2].y 
        and UO.GetPix(UO.ContPosX+gump[2].cx,UO.ContPosY+gump[2].cy)==gump[2].c then break end
    wait(t)
end
local result={}
for i = UO.ContPosX+30, UO.ContPosX+155,4 do
     for ii = UO.ContPosY+15, UO.ContPosY+135,4 do
          local pix=UO.GetPix(i,ii) 
          for iii,iv in pairs(blip) do
                if pix==iv then 
                    table.insert(result, {i, ii, pix})
                    break
                end
          end
     end
end
return result
end

function checkWgt(id,bx,by)
while UO.Weight==0 do 
   UO.Macro(8,2) 
   UO.Macro(10,2) 
end
if math.min(400, UO.MaxWeight)-25<=UO.Weight-gwt then
   UO.Macro(8,7)
   UO.SysMessage("Dumping resources to storage.")
   if huge then
      for i,ii in pairs(scan(reso)) do
          UO.Drag(ii.id, ii.stack)
          UO.DropC(huge)
      end
      return 1
   end
   local curx=UO.CharPosX
   local cury=UO.CharPosY 
   while getDist(keg[1].x, keg[1].y)>2 do
      movePath(keg[1].x, keg[1].y)
      --openCont(keg[1].cont) 
   end
    --print("Overweight!!x2")
   for i,ii in pairs(scan(reso)) do
       if ii.cont==UO.BackpackID then
          UO.Drag(ii.id, ii.stack)
          UO.DropC(keg[1].cont)
       end
   end
   --print("sending "..bx.." "..by)
   while getDist(bx, by)>2 do
      movePath(bx, by)
      --openCont(keg[1].cont) 
   end
   while UO.ContSizeX..UO.ContSizeY~=gump[1].x..gump[1].y and
         UO.ContSizeX..UO.ContSizeY~=gump[3].x..gump[3].y do
         useBee(id)
         return 1
   end
end
return 0
end

function gatherBee(int)
local tmp=0
local weight=UO.Weight
if empty<=0 and int==1 then getEmpty() end
for i=10,30 do
    if UO.ContSizeX..UO.ContSizeY==gump[3].x..gump[3].y 
    and UO.GetPix(UO.ContPosX+130,UO.ContPosY+68)==526344 then
           hitButton(65+(int*147), 158,3)    
    end
end
           if int==tmp then return tmp end
for i=0,25 do
         tmp=journal(refail, broke)
         --print("we saw result as "..tmp)
         if tmp==1 then empty=empty-(UO.Weight-weight) return tmp
         elseif tmp==2 then return 0
         elseif tmp< 0 then tcnt=tcnt+1
            if tcnt>#hivetool then 
               UO.ExMsg(UO.CharID, 3, exmess[1], "We have run out of hive tools and must stop.") stop()
            end
         end
end
return 1
end 

function checkAmt(int,id,mx,my)
if checkWgt(id,mx,my)==1 then
   print("we moved")
   while UO.ContSizeX..UO.ContSizeY~=gump[3].x..gump[3].y 
   and UO.GetPix(UO.ContPosX+130,UO.ContPosY+68)~=526344 do
       hitButton(66, offset.a.y, 1) 
   end
end     

for i=10,30 do
    if UO.ContSizeX..UO.ContSizeY==gump[3].x..gump[3].y 
    and UO.GetPix(UO.ContPosX+130,UO.ContPosY+68)==526344 then break
   end
   wait(i)
end

while true do
local bol=0
for i=1,9,2 do
    if UO.GetPix(UO.ContPosX+122+(int*72)+i%2,UO.ContPosY+102+i)==pixel then
          gatherBee(int)
          bol=gatherBee(int)
          if int==0 then return end
          break
    end
end
--print(bol)

for i=10,30 do
    if UO.ContSizeX..UO.ContSizeY==gump[3].x..gump[3].y 
    and UO.GetPix(UO.ContPosX+130,UO.ContPosY+68)==526344 then break
   end
   wait(i)
end
if bol==0 then
   local mleft = UO.GetPix(UO.ContPosX+115+(int*72),UO.ContPosY+108)
   local bleft = UO.GetPix(UO.ContPosX+115+(int*72),UO.ContPosY+110)
   local mright = UO.GetPix(UO.ContPosX+120+(int*72),UO.ContPosY+107)
   local bright = UO.GetPix(UO.ContPosX+119+(int*72),UO.ContPosY+110)
   local mid = UO.GetPix(UO.ContPosX+117+(int*72),UO.ContPosY+105)
   local offset = UO.GetPix(UO.ContPosX+117+(int*72),UO.ContPosY+111) 
   print(int.." "..mleft.." "..bleft.." "..mright.." "..bright.." "..mid.." "..offset)
   if mleft==pixel and bleft==pixel and mright==pixel and bright==pixel and mid~=pixel and offset==pixel then return
   --if mleft==pixel and mright==pixel and bleft==pixel and bright==pixel and offset==pixel and mid~=pixel then break end
   elseif int==1 and mleft==pixel and bleft==pixel and mright~=pixel and bright~=pixel and mid~=pixel and offset~=pixel then return 
   elseif int==1 and mleft~=pixel and bleft==pixel and mright~=pixel and bright~=pixel and mid~=pixel and offset==pixel then return
   end
end
gatherBee(int)
if int==0 then return end
end
return
end

--local resgump=250, 219
--local newcli=117,106
function beeExtra(id,mx,my)
local result=1
for i=0,25 do
    if i>23 then return 0 end
     if UO.ContSizeX..UO.ContSizeY==gump[1].x..gump[1].y
         and UO.GetPix(UO.ContPosX+78,UO.ContPosY+176)==526344 then break end
     if findCont(gump[1].x, gump[1].y)~= 0 then break end
     wait(i)
end
while UO.ContSizeX..UO.ContSizeY~=gump[3].x..gump[3].y
   and UO.GetPix(UO.ContPosX+130,UO.ContPosY+68)~=526344 do
       hitButton(66, offset.a.y, 1) 
end
for i=0,1 do
    if UO.GetPix(UO.ContPosX+117+(i*73),UO.ContPosY+106)~=6375 then checkAmt(i,id,mx,my) end 
end
              --killCont(1)
return
end
     

function potNum(u, a)

for i=0,25 do
     if UO.ContSizeX..UO.ContSizeY==gump[1].x..gump[1].y
         and UO.GetPix(UO.ContPosX+78,UO.ContPosY+176)==526344 then break
     end
     findCont(gump[1].x, gump[1].y)
     wait(i)
end
local pix1, pix2=0,0
local result,sub,mid={},{},{}
for i=0,#kegtp-1 do
     pix1 = UO.GetPix(UO.ContPosX+195,UO.ContPosY+offset.a.y-1+1*(math.floor(24.75*i)))
     pix2 = UO.GetPix(UO.ContPosX+195,UO.ContPosY+offset.a.y+4+1*(math.floor(24.75*i)))
--local pix3 = UO.GetPix(UO.ContPosX+195,UO.ContPosY+152)
--local pix4 = UO.GetPix(UO.ContPosX+195,UO.ContPosY+156)
--print("results "..pix1.." "..pix2.." "..i)
    if pix1 == pixel and pix2 == pixel then table.insert(result,2)
    elseif pix1 == pixel then  table.insert(result,0)
    else table.insert(result,1)
    end
end
local int=0
local mod=0
if u <10 then mod =2 end
if a>=80 then mod=2
elseif a>=40 then mod=1
end
table.insert(sub, table.remove(result,1))
table.insert(sub, table.remove(result))
print(u.." "..a)
print(mod)
print(sub[2].." "..sub[1])
sub[2]= sub[2]+mod
print(sub[2].." "..sub[1])
table.insert(mid, table.remove(result))
return result,sub,mid
end

function beeStatus()
local result= {}
for int=0, 1 do
    local val = 0
    local pix1 = UO.GetPix(UO.ContPosX+84,UO.ContPosY+80+25*int)
    for ii, iii in pairs(colours) do
         if pix1==iii then val=ii break end
    end
table.insert(result, val)
end
for int=0, 1 do
    local val = 0
    local pix1 = UO.GetPix(UO.ContPosX+84,UO.ContPosY+130+25*int)
    for ii, iii in pairs(colours) do
         if pix1==iii then val=ii break end
    end
table.insert(database, val..int)
end
return result
end
     
function happyBee()
local pour=0
for i, ii in pairs(bee) do
     while getDist(ii.x, ii.y)>2 do
             movePath(ii.x, ii.y)
     end
     while UO.ContSizeX..UO.ContSizeY~=gump[1].x..gump[1].y do
         useBee(ii.id, ii.x,ii.y)
         if UO.ContSizeX..UO.ContSizeY==gump[1].x..gump[1].y
             and UO.GetPix(UO.ContPosX+78,UO.ContPosY+176)==526344 then break end
     end
     nums,alts,mids=potNum(ii.use, ii.age)
     --local poxy=UO.ContPosX..UO.ContPosX
     for iii,iv in pairs(alts) do
         if iv<2 then
             pour=0        
             UO.ExMsg(ii.id, 3,exmess[2-iv],"Bee needs "..2-iv.." "..potion[1+(4*(iii-1))][2])
             while pour<2-iv do
                 pour=pour+feedBee(1+(4*(iii-1)),2-iv-pour,ii.x,ii.y)
--          UO.SysMessage("The bees are not happy. (308)") stop() 
             end
         end
     end
     while getDist(ii.x, ii.y)>2 do
             movePath(ii.x, ii.y)
     end
     while UO.ContSizeX..UO.ContSizeY~=gump[1].x..gump[1].y do
         useBee(ii.id, ii.x,ii.y)
         if UO.ContSizeX..UO.ContSizeY==gump[1].x..gump[1].y
             and UO.GetPix(UO.ContPosX+78,UO.ContPosY+176)==526344 then break end
     end
     for iii, iv in pairs(state) do
        if string.match(ii.name, iv)~= nil and mids[1]<iii then
            pour=0 
            UO.ExMsg(ii.id, 3,exmess[iii],"Bee needs "..iii-mids[1].." "..potion[4][2])
      --checkPot(4,iii-nums[3])
            while pour<iii-mids[1] do
                 pour=pour+feedBee(4,iii-mids[1]-pour,ii.x,ii.y)
             --UO.SysMessage("The bees are not happy. nest: eal") stop()
             end
        end
     end
while getDist(ii.x, ii.y)>2 do
    movePath(ii.x, ii.y)
end
while UO.ContSizeX..UO.ContSizeY~=gump[1].x..gump[1].y do
    useBee(ii.id, ii.x,ii.y)
    if UO.ContSizeX..UO.ContSizeY==gump[1].x..gump[1].y
        and UO.GetPix(UO.ContPosX+78,UO.ContPosY+176)==526344 then break end
end
    for iii, iv in pairs(beeStatus()) do
        if nums[iii]<iv then
            pour=0 
             -- checkPot(iii+1,iii-nums[iii])
            while pour<iv-nums[iii] do
                    print(pour.."poured. iv "..iv.." logged "..nums[iii].." @ "..iii.." array: "..iv-nums[iii])
                    --pause()
              pour=pour+feedBee(iii+1,iv-nums[iii]-pour,ii.x,ii.y)
                  --if feedBee(iii+1,iii-nums[iii],ii.x,ii.y)<0 then
                  --UO.SysMessage("The bees are not happy. nest: "..iii.." "..iv) stop()
            end
        end
    end
    while getDist(ii.x, ii.y)>2 do
    movePath(ii.x, ii.y)
end
while UO.ContSizeX..UO.ContSizeY~=gump[1].x..gump[1].y do
    useBee(ii.id, ii.x,ii.y)
    if UO.ContSizeX..UO.ContSizeY==gump[1].x..gump[1].y
        and UO.GetPix(UO.ContPosX+78,UO.ContPosY+176)==526344 then break end
end
   if harvest then
    beeExtra(ii.id,ii.x,ii.y)
    killBee()
    end
end    
if empty>0 then clean() end
UO.SysMessage("Congradulations, you are the proud owner of happy bees.")
UO.SysMessage("A report has been created in the console for your consideration.")
for i, ii in pairs(bee) do
     UO.ExMsg(ii.id, 3,exmess[1],"Buzzz buzz thank you!")
end
local n={1,0,3}
for i,ii in pairs(database) do
    if ii==n[1]..n[2] then print("Bee has slightly too many flowers")
    elseif ii==n[1]..n[1] then print("Bee has slightly too much water")
    elseif ii==n[3]..n[2] then print("Bee has far too many flowers")
    elseif ii==n[3]..n[1] then print("Bee is drowining in water")
    end
end
end

function clean()
local tmp={}
   for i,ii in pairs(scan({3854})) do
       if string.match(ii.name, "Empty Bottle") and ii.cont==UO.BackpackID then
          table.insert(tmp, {id=ii.id, name=ii.name})
       end
   end
if next(tmp) then
   UO.LObjectID=key
   UO.Macro(17,0)
   while true do
         if UO.ContSizeX..UO.ContSizeY==gump[4].x..gump[4].y then break
         elseif getticks()%500>=250 then UO.Macro(17,0) end
   end
   while not UO.TargCurs do
         if UO.ContSizeX..UO.ContSizeY==gump[4].x..gump[4].y then
         UO.Click(UO.ContPosX+289, UO.ContPosY+435, true,true,true,false)
         end
   end
   for i,ii in pairs(tmp) do
       --if string.match(ii.name, "Empty Bottle")~=nil then
          while UO.TargCurs do 
          UO.LTargetID=ii.id  
          UO.LTargetKind=1
          UO.Macro(22,0) 
          end 
       --end
   end
   local timer=getticks()+500
   while timer>getticks() do
         if UO.TargCurs then UO.TargCurs=false     end
         if UO.ContSizeX..UO.ContSizeY==gump[4].x..gump[4].y then
            UO.Click(UO.ContPosX+UO.ContSizeX/2, UO.ContPosY+UO.ContSizeY/2, false, true, true, false)
         end
   end
UO.TargCurs=false
return
end
    
    --1while UO.TargCurs do w 0 = too many flowers.
    --30 = way too freakin many
    --11 = too much water.
stop()
end

init()
happyBee()