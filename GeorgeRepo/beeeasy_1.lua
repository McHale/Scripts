                   --==========================================================
-- Script Name: Bee Tending Application
-- Author: Themadxcow
-- Version: 1.8.2
-- OpenEUO version tested with: 0.91
-- Purpose: Tending and Harvesting Bee Hives
--==========================================================
--local gwait = 1000
local colours={59367, 6375, 59160} --|yellow|red|green
local exmess={68, 153, 34} --green|yellow|red
local offset={a={x=35, y=54}, 
                     b={x=175, y=23, stat=15}, 
                     c={x=290, y=160}}
local gump={{x=258, y=219, cx=78,  cy=176, c=526344},  --main gump
                     {x=178, y=178, cx=75,  cy=9,   c=532810}, --dot gump
                     {x=250, y=219, cx=130, cy=68,  c=526344},      -- gather gump
                     {x=505, y=475, cx=205, cy=34,  c=15193649, ox=290, oy=160}} --gump= 83x41   17064/ opened 344 241
        --sx main hive|sy main hive| sxsy pour|sx collect|sx key|sy key|
local pixel=15724502
local blip={4342461, 4868797, 4342453, 5395142, 1579148, 1052812, 526443,
                  2171292,1052804}
local storage={2448, 2473, 2474, 2475, 2482, 2717, 3648, 3649, 3650, 3651,
                         3701, 3702, 3703, 3705, 3706, 3708, 3709, 3710, 3791,
                         9002, 9431, 9435, 10257, 10258, 11759, 11761, 11762, 11764}
local tools={2330, 2549, 2532,  3921, 2532, 5995, 3847, 3848, 3849, 3850,
                    3852, 3854}
local reso={2540, 5154} --bees wax|honey
local potion = {{3848,"Greater Agility"},
                        {3850,"Greater Poison"},
                        {3847, "Greater Cure"},
                        {3852,"Greater Heal"}}
--local blank = {3221801, 1589842, 3748145, 4340025, 8497, 4337969, 2695457}
local pathfail={"Can't get there"}
local pfail={"The keg is empty.", "do not have any of that resource!"}
local psuccess={"You pour some of the keg's", "and place it into your backpack"}
local bfail={"You don't have any strong","beehive is already soaked"}
local bsuccess={"You pour the potion into the beehive"}
local gfail={"You do not have any"}
local state={"Healthy", "Sickly", "Dying"}
local refail={"place it in your pack", "There isn't enough"}
local broke={"You wear out the"}
--local dead={"Corpse"}
local baditem={"Sending", "Trash", "Gem Pouch", "Seed Box", "Exex Deposit Box", "Post Box"}
local keg,bee,hivetool,database,key={},{},{},{},{}
local empty, gwt, tcnt  = 0, false, 1
local null=9^9
local kegtp, pot={0,0,0,0},{0,0,0,0}
local harvest, getbot, flag, huge=true, false, false, nil
local next=next
local timer=getticks()

function init()
   timer=getticks()+500
   while timer>getticks() do
         UO.Macro(8,7)
         local subtime=getticks()+100
         while subtime>getticks() do
         if UO.Weight~=0 then flag=true break end
         end
         if flag then UO.Macro(10,7) break end
   end
   flag=false
   while true do
      if killBee()==0 then break end
   end
   timer=getticks()+500
   while timer>getticks() do
         UO.Macro(8,1)
         local subtime=getticks()+100
         while subtime>getticks() do
         if UO.ContType==UO.CharType then flag=true break end
         end
         if flag then UO.Macro(10,1) break end
   end
   flag=false
   timer=getticks()+500
   while timer>getticks() do
         UO.Macro(8,2)
         local subtime=getticks()+100
         while subtime>getticks() do
         if UO.ContID==UO.BackpackID then flag=true break end
         end
         if flag then break end
   end
   oldRef=UO.ScanJournal(0)
   if findBeeFood()==0 then UO.SysMessage("I have not found all keg types.  Please close all containers and restart.") stop()
   else UO.SysMessage("Found "..#keg.." potion kegs.") end 
return
end 

function beeExtra(id,mx,my)
local result=1
pass=true
timer=getticks()+500
   while timer>getticks() do
      if UO.ContSizeX..UO.ContSizeY==gump[1].x..gump[1].y
         and UO.GetPix(UO.ContPosX+gump[1].cx,UO.ContPosY+gump[1].cy)==gump[1].c then 
         pass=false
         break 
      end
      findCont(gump[1].x, gump[1].y)
   end
   if pass then return 0 end
   pass=true
   timer=getticks()+500
   while timer>getticks() do
      hitButton(66, offset.a.y, 1) 
      if UO.ContSizeX..UO.ContSizeY==gump[3].x..gump[3].y
      and UO.GetPix(UO.ContPosX+gump[3].cx,UO.ContPosY+gump[3].cy)~=gump[3].c then
      pass=false
      break
      end
   end
   for i=0,1 do
      if UO.GetPix(UO.ContPosX+117+(i*73),UO.ContPosY+106)~=6375 then checkAmt(i,id,mx,my) end 
   end
return
end

function beeStatus(id)
local result= {}
for int=0, 1 do
    local val = 0
    local pix1 = UO.GetPix(UO.ContPosX+84,UO.ContPosY+80+int*25)
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
table.insert(database, {val..int, id})
end
return result
end

function checkAmt(int,id,mx,my)
   if checkWgt(id,mx,my)==1 then
      print("we moved")
      timer=getticks()+250
      while UO.ContSizeX..UO.ContSizeY~=gump[3].x..gump[3].y 
      and UO.GetPix(UO.ContPosX+gump[3].cx,UO.ContPosY+gump[3].cy)~=gump[3].c do
         hitButton(66, offset.a.y, 1) 
         while timer>getticks() do
            if UO.ContSizeX..UO.ContSizeY==gump[3].x..gump[3].y 
            and UO.GetPix(UO.ContPosX+gump[3].cx,UO.ContPosY+gump[3].cy)==gump[3].c then
            break
            end
         end
      end
   end
   while true do
      local cnt=0
      for i=1,9,2 do
         if UO.GetPix(UO.ContPosX+122+(int*72)+i%2,UO.ContPosY+102+i)==pixel then
            gatherBee(int)
            cnt=gatherBee(int)
            if int==0 then return end
            break
         end
      end
      pass=false
      timer=getticks()+500
      while timer>getticks() do
         if UO.ContSizeX..UO.ContSizeY==gump[3].x..gump[3].y 
         and UO.GetPix(UO.ContPosX+gump[3].cx,UO.ContPosY+gump[3].cy)==gump[3].c  then
            pass=true
            break
         end
      end
      if cnt==0 then
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

function checkPot(tbl,num)
   if empty<num then getEmpty() end
   for i,ii in pairs(tbl) do
   while pot[i]<ii do pot[i]=pot[i]+getPot(i,ii) end
   end
return
end

function checkWgt(bid,bx,by)
print("WGT")
   while UO.Weight==0 do  UO.Macro(8,2)  end
if math.min(385, UO.MaxWeight)<=UO.Weight-gwt then
   --UO.Macro(8,7)
   UO.SysMessage("Dumping resources to storage.")
   local dump=scan(reso)
   if huge then
      for i,ii in pairs(dump) do
         if ii.cont==UO.BackpackID then
            local wgt=UO.Weight
            UO.Drag(ii.id, ii.stack)
            timer=getticks()+250
            UO.DropC(huge)
            while timer>getticks() do
               if wgt>UO.Weight then break end
            end
         end
      end
      return 1
   end
      local curx=UO.CharPosX
      local cury=UO.CharPosY 
      print("WEIGHT")
      while getDist(keg[1].x, keg[1].y)>2 do movePath(keg[1].x, keg[1].y) end
      openCont(keg[1].cont,0) 
      for i,ii in pairs(dump) do
         if ii.cont==UO.BackpackID then
            UO.Drag(ii.id, ii.stack)
            timer=getticks()+250
            UO.DropC(keg[1].cont,0)
            while timer>getticks() do
               if wgt>UO.Weight then break end
            end
       end
   end
   while getDist(bx, by)>2 do movePath(bx, by) end
   timer=getticks()+1000
   while timer>getticks() do
      openCont(bid,1)
      if UO.ContSizeX..UO.ContSizeY==gump[1].x..gump[1].y 
      and UO.GetPix(UO.ContPosX+gump[1].cx,UO.ContPosY+gump[1].cy)==gump[1].c then return 1
      end
   end
end
return 0
end

function clean()
local tmp={}
   for i,ii in pairs(scan({3854})) do
       if string.match(ii.name, "Empty Bottle") and ii.cont==UO.BackpackID then
          table.insert(tmp, {id=ii.id, name=ii.name})
       end
   end
if next(tmp) then
   openCont(key[1].id,4)
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

function dotArray()
print("ARRAY")
flag=true
timer=getticks()+500
   while timer>getticks() do
      if UO.ContSizeX..UO.ContSizeY==gump[2].x..gump[2].y
      and UO.GetPix(UO.ContPosX+gump[2].cx,UO.ContPosY+gump[2].cy)==gump[2].c then flag=false break 
      elseif findCont(2) then flag=false break
      elseif findCont(1) then return false
      end
   end
   if flag then
      print(UO.GetPix(UO.ContPosX+gump[2].cx,UO.ContPosY+gump[2].cy).."dot"..gump[2].c)
      --UO.SysMessage("Array error: "..UO.ContSizeX..UO.ContSizeY.."/"..gump[2].x..gump[2].y) stop()
      return false 
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

function feedBee(int, num,mx,my)
local cnt=1
print("FEED BEE")
   if getbot and pot[int]<num then checkPot(int,num) end
   while getDist(mx, my)>2 do movePath(mx,my) end
local amt=0
flag=false
   for c=0,num do
      timer=getticks()+500
      while timer>getticks() do
         if UO.ContSizeX..UO.ContSizeY==gump[1].x..gump[1].y  then break
         elseif UO.ContSizeX..UO.ContSizeY==gump[2].x..gump[2].y then flag=true break
         end
      end
      if not flag then hitButton(offset.a.x+offset.b.x, offset.a.y+(24.75*(int-1)),1) end
      local dot=dotArray()
      if dot then
         flag=false
         timer=getticks()+1000
         while timer>getticks() do
      for i,ii in pairs(dot) do
          local subtime=getticks()+250
          while subtime>getticks() do
            if UO.ContSizeX..UO.ContSizeY==gump[1].x..gump[1].y 
               and UO.GetPix(UO.ContPosX+gump[1].cx,UO.ContPosY+gump[1].cy)==gump[1].c then 
                   flag=true
                   break
            elseif UO.ContSizeX..UO.ContSizeY==gump[2].x..gump[2].y then
                   if UO.GetPix(ii[1], ii[2])==ii[3] then
                      UO.Click(ii[1],ii[2],true,true,true,false)
                      print(ii[1].." dot "..ii[2]) break
                   else print(ii[3]..":"..ii[1].." snub "..ii[2]..":"..UO.GetPix(ii[1], ii[2])) break
                   end
            end
         end
         if flag then break end
         end
	 if flag then break end
      end
      ---if pass then
      timer=getticks()+1000
      pass=false
      while timer>getticks() do           
         status=journal(bsuccess, bfail)
         if status==1 then 
            if getbot then pot[int]=pot[int]-1 end
            empty=empty+1
            amt=amt+1
            break 
         elseif status==-1 then print(potion[int][2].." ERROR overfed "..num) stop()
         end
      end
      if amt==num then break end
      end
   end
timer=getticks()+500
   while timer>getticks() do
      if UO.ContSizeX..UO.ContSizeY==gump[1].x..gump[1].y then return amt
      elseif UO.ContSizeX..UO.ContSizeY==gump[2].x..gump[2].y then killCont(1) 
      end
   end
return amt
end

function findBeeFood()
UO.SysMessage("Searching for bee supplies...")
local open={}
local store=scan(storage)
   for i,ii in pairs(store) do
      if ii.cont==UO.BackpackID then
         if string.match(ii.name, "Holding") and  string.match(string.reverse(ii.info),"%z%s",7)then huge=ii.id end
         if openCont(ii.id, 0)==1 then 
            table.insert(open, {id=ii.id, x=ii.x, y=ii.y, sx=UO.ContSizeX, sy=UO.ContSizeY, name=ii.info})
         end
      end
   end
  --if gwt==0 then print("weight is off") stop() end
   if not findTools(tools, open) then killCont(#open) return 0
   elseif findKeg(open)>=#potion-1 then killCont(#open) return 1 
   end
   open={}
   getbot=true
   for i,ii in pairs(store) do
      if getDist(ii.x, ii.y)>2 and ii.dist<999 then
         if i>1 then 
            timer=getticks()+100
            while timer>getticks() do 
               if findKeg(open)>=#potion-1 then killCont(#open) return 1
               elseif UO.ContID==ii.id then break
               end
            end
            killCont(#open)
            open={}
         end
         movePath(ii.x, ii.y)
      elseif ii.dist>=999 then break 
      end 
      if openCont(ii.id,0)==1 then 
         table.insert(open, {id=ii.id, x=ii.x, y=ii.y, sx=UO.ContSizeX, sy=UO.ContSizeY}) 
     end
   end
   if next(open)~= nil then
      timer=getticks()+500
      while timer>getticks() do
         if findKeg(open)>=#potion-1 then killCont(#open) return 1 end
      end
   end
return 0
end

function findCont(x, y)
print("FCONT")
local result=0
   if x==0 then result={} end
   for i=0, 999 do
      local a,nx,ny,nsx,nsy,_,nid = UO.GetCont(i)
      if a==nil then return result
      elseif x>5000 and x==nid then return nx,ny,nsx,nsy
      elseif x==0 then table.insert(result, {id=a, sx=nsx,sy=nsy})
      elseif nsx==x and nsy==y then UO.ContTop(i) return nx..ny
      end
   end
return result
end

function findKeg(cur)
--table.insert(cur,{id=UO.BackpackID})
local result=0
   for i,item in pairs(scan({6464})) do
      for ii=1, #potion do
         if string.match(item.name, potion[ii][2]) then
            for iii,iv in pairs(cur) do
               if iv.id == item.cont then --or item.cont==UO.BackpackID then
                  table.insert(keg, {id=item.id, name=item.name, use=item.info, cont=item.cont, x=iv.x, y=iv.y, sx=iv.sx, sy=iv.sy})
                  if ii%5>0 then result=result+1-kegtp[ii] end
                  kegtp[ii]=1
                  break  
               else
                  print("sanatize: "..item.cont)
                  local tx,ty,tsx,tsy=findCont(item.cont,0)
                  if not tsx then UO.SysMessage("Rogue gump detected: Close all external containers and restart.") stop() end
                  table.insert(keg, {id=item.id, name=item.name, use=item.info, cont=item.cont, x=tx, y=ty, sx=tsx, sy=tsy})
                  if ii%5>0 then result=result+1-kegtp[ii] end
                  kegtp[ii]=1
                  break  
               end
            end
         end
      end
   end
return result
end

function findTools(main, pack)
for i,item in pairs(scan(main)) do
   if item.k==0 then
      if item.tp == 5995 and string.match(item.name,"Spell Caster's Keys") then
         UO.SysMessage("Spell keys found.")
         table.insert(key, {id=item.id, cont=item.cont})
      --elseif item.tp == 2532 then
      --   table.insert(waxpot, {id=item.id, use=string.match(item.info, "%d+")})
      --elseif item.tp == 3921 then
      --   table.insert(waxtool, {id=item.id, cont=item.cont, use=string.match(item.info, "%d+")})
      elseif item.tp == 2549 then
         table.insert(hivetool, {id=item.id, cont=item.cont, use=string.match(item.info, "%d+")})
      elseif item.tp == 3854 and string.match(item.name, "Empty") then empty=empty+item.stack
      else 
         for p,pp in pairs(potion) do
            if item.tp == pp[1] then pot[p]=pot[p]+1 break end
         end           
      end
   elseif item.tp == 2330 then
      if string.match(item.info, "Empty") then 
         UO.ExMsg(item.id,3,colours[5],"Dead bees =(.")
         UO.HideItem(item.id)                             
      else table.insert(bee, {id=item.id, name=item.name, use=tonumber(string.match(item.info,"%d+", 22)), age=tonumber(string.match(item.info,"%d+", 11)), x=item.x, y=item.y, dist=item.dist})
      end
   end
end
if not next(bee) then UO.SysMessage("There appear to be no bees near, bee tending complete!") stop() 
else table.sort(bee, function(a,b) return a.dist<b.dist end)
   UO.SysMessage("Found "..#bee.." bee hives") 
end
--if next(waxpot)==nil then UO.SysMessage("No wax pots found.") else
--   UO.SysMessage("Found "..#waxpot.." wax pot.") end
--if next(waxtool)==nil then UO.SysMessage("No wax tool found.") else
--   UO.SysMessage("Found "..#waxtool.." wax tool.") end
for i,ii in pairs(pot) do
    if ii then UO.SysMessage("Potion type "..i.." has "..ii) end
end
if not next(hivetool)then  UO.SysMessage("No hive tool found.  Harvesting disabled.")
   harvest=false
else UO.SysMessage("Found "..#hivetool.." hive tools.  First tool has "..hivetool[1].use.." uses.") end
   return true
end

function gatherBee(int)
--local tmp=0
local weight=UO.Weight
   if empty<=0 and int==1 then 
      if not getEmpty() then
         UO.SysMessage("Not enough bottles, harvesting disabled.")
         harvest=false
      end
   end
   flag=true
   timer=getticks()+1000
   while timer>getticks() do
      if UO.ContSizeX..UO.ContSizeY==gump[3].x..gump[3].y 
      and UO.GetPix(UO.ContPosX+gump[3].cx,UO.ContPosY+gump[3].cy)==gump[3].c then
         if hitButton(65+(int*147), 158,3) then flag=false break end
      end
   end
   --if int==tmp then return tmp end
   timer=getticks()+500
   while timer>getticks() do
  -- for i=0,25 do
      local tmp=journal(refail, broke)
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

function getDist(x,y) return math.max(math.abs(UO.CharPosX-x),math.abs(UO.CharPosY-y)) end

function getEmpty()
flag=true
--local old=empty
   if not next(key) then UO.SysMessage("No keys found and not enough bottles..") end
--while UO.LObjectID~=key do  end
   --while UO.ContSizeX..UO.ContSizeY~=gump[4].x..gump[4].y do
         if not openCont(key[1].id,4) then UO.SysMessage("timed out") print("timeout "..key[1].id) stop() end
      if UO.ContSizeX..UO.ContSizeY==gump[4].x..gump[4].y 
      and UO.GetPix(UO.ContPosX+gump[4].cx, UO.ContPosY+gump[4].cy)==gump[4].c then
         local wgt=UO.Weight 
         while flag do
            timer=getticks()+500
            UO.Click(UO.ContPosX+gump[4].ox, UO.ContPosY+gump[4].oy,true,true,true,false)
            while timer>getticks() do
               if wgt>UO.Weight then flag=false break
               elseif journal(pfail, pfail)~=0 then
                  UO.TargCurs=false
                  timer=getticks()+500
                  while timer>getticks() do
                     if UO.ContSizeX..UO.ContSizeY==gump[4].x..gump[4].y then killCont(1) break end
                  end
                  return false
               end
            end
         end
         local tmp=scan({3854})
         if next(tmp) then 
            for ii,iii in pairs(tmp) do
               if iii.cont==UO.BackpackID and iii.stack>empty then
                  empty=iii.stack
                  timer=getticks()+500
                  while timer>getticks() do
                     if UO.ContSizeX..UO.ContSizeY==gump[4].x..gump[4].y then killCont(1) break end
                  end
                  return true
               end
            end
         end
end  
UO.TargCurs=false
UO.SysMessage("Script error, please report: "..key.."+"..empty)
stop()
end

function getPot(index, num)
print("GETTING")
local result, tmp = 0,0
   for i,ii in pairs(keg) do 
      if string.match(ii.name, potion[index][2]) ~= nil then
         while getDist(ii.x, ii.y)>2 do movePath(ii.x, ii.y) end
         timer=getticks()+500
         while timer>getticks() do
            --if  findCont(ii.sx, ii.sy)==0 then
                UO.LObjectID=ii.cont
                if openCont(ii.cont,0)==1 then break end
            --else break 
            --end
         end
         while result <num do
               UO.LObjectID=ii.id
            timer=getticks()+250
            tmp=useItem(ii.id, psuccess, pfail)
               if tmp<0 then 
                  print("keg down")
                  table.remove(keg, i)
                  killCont(1)
                  return result
               elseif tmp==1 then result=result+1 empty=empty-1 
               end               
            while timer>getticks() do end
         end
         timer=getticks()+500
         while timer>getticks() do  
            if UO.ContSizeX..UO.ContSizeY==ii.sx..ii.sy then killCont(1) break end
         end
         return result
      end
   end
UO.SysMessage("Unable to locate more potions, terminating...")
stop()
end

function happyBee()
local pour=0
for i, ii in pairs(bee) do
   local potreq,potcnt={0,0,0,0},0
    UO.ExMsg(ii.id,3,68,"Checking bee "..i)
    print("H 1 BEE")
    print(ii.x.." "..ii.y.." "..UO.Property(ii.id))
     while getDist(ii.x, ii.y)>2 do movePath(ii.x, ii.y) end
     while true do--UO.ContSizeX..UO.ContSizeY~=gump[1].x..gump[1].y do
           --if openCont(ii.id,1,1)==1 then break end
           if openCont(ii.id, 1)==1 then break end
           --stop()
         --useBee(ii.id, ii.x,ii.y)
         --if UO.ContSizeX..UO.ContSizeY==gump[1].x..gump[1].y
             --and UO.GetPix(UO.ContPosX+78,UO.ContPosY+176)==526344 then break end
     end
     nums,alts,mids=potNum(ii.use, ii.age)
     for iii,iv in pairs(alts) do
         if iv<2 then 
            potcnt=2-iv
            potreq[1+(4*(iii-1))]=potcnt
            end
      end
      for iii, iv in pairs(state) do
         if string.match(ii.name, iv)~= nil and mids[1]<iii then 
            potcnt=potcnt+iii-mids[1]
            potreq[4]=iii-mids[1]break end
      end
      for iii, iv in pairs(beeStatus(ii.id)) do
         if nums[iii]<iv then 
            potcnt=potcnt+iv-nums[iii]
            potreq[iii+1]=iv-nums[iii] break end
      end
      if getbot then checkPot(potreq,potcnt) end
      for iii,iv in pairs(potreq) do
         if iv>0 then feedBee(iii,iv,ii.x,ii.y)
            UO.ExMsg(ii.id, 3,exmess[1],"Bee needs "..iv.." "..potion[iii][2])
            print("H BEE")
            while getDist(ii.x, ii.y)>2 do movePath(ii.x, ii.y) end
            while UO.ContSizeX..UO.ContSizeY~=gump[1].x..gump[1].y do
               useBee(ii.id, ii.x,ii.y)
               if UO.ContSizeX..UO.ContSizeY==gump[1].x..gump[1].y
               and UO.GetPix(UO.ContPosX+78,UO.ContPosY+176)==526344 then break 
               end
            end
            --print(iii)
            --feedBee(iii,iv,ii.x,ii.y)
            end
     end
     --local poxy=UO.ContPosX..UO.ContPosX
 --[[    for iii,iv in pairs(alts) do
         if iv<2 then
             pour=0        
             UO.ExMsg(ii.id, 3,exmess[2-iv],"Bee needs "..2-iv.." "..potion[1+(4*(iii-1))][2])
             while pour<2-iv do
                 pour=pour+feedBee(1+(4*(iii-1)),2-iv-pour,ii.x,ii.y)
--          UO.SysMessage("The bees are not happy. (308)") stop() 
             end
         end
     end
     while getDist(ii.x, ii.y)>2 do movePath(ii.x, ii.y) end
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
while getDist(ii.x, ii.y)>2 do movePath(ii.x, ii.y) end
while UO.ContSizeX..UO.ContSizeY~=gump[1].x..gump[1].y do
    useBee(ii.id, ii.x,ii.y)
    if UO.ContSizeX..UO.ContSizeY==gump[1].x..gump[1].y
        and UO.GetPix(UO.ContPosX+78,UO.ContPosY+176)==526344 then break end
end
    for iii, iv in pairs(beeStatus(ii.id)) do
        if nums[iii]<iv then
            pour=0 
             -- checkPot(iii+1,iii-nums[iii])
            while pour<iv-nums[iii] do
                    print(pour.."poured. iv "..iv.." logged "..nums[iii].." @ "..iii.." array: "..iv-nums[iii])
                    --pause()
              pour=pour+feedBee(iii+1,iv-nums[iii]-pour,ii.x,ii.y)
                  --if feedBee(iii+1,iii-nums[iii],ii.x,ii.y)<0 then
            end
        end
    end
    while getDist(ii.x, ii.y)>2 do
    movePath(ii.x, ii.y)
end ]]--
while UO.ContSizeX..UO.ContSizeY~=gump[1].x..gump[1].y do
    useBee(ii.id, ii.x,ii.y)
    if UO.ContSizeX..UO.ContSizeY==gump[1].x..gump[1].y
        and UO.GetPix(UO.ContPosX+78,UO.ContPosY+176)==526344 then break end
end
   if harvest then beeExtra(ii.id,ii.x,ii.y) end
while true do
      if killBee()==0 then break end
   end
end   
if empty>0 then clean() end
UO.SysMessage("Congradulations, you are the proud owner of happy bees.")
--for i, ii in pairs(bee) do
--     UO.ExMsg(ii.id, 3,exmess[1],"Buzzz buzz thank you!")
--end
local n={1,0,3}
for i,ii in pairs(database) do
    local int=1
    local strng=" is doing good"
    if ii==n[1]..n[2] then int=2 strng=" has slightly too many flowers"
    elseif ii==n[1]..n[1] then int=2 strng=" has slightly too much water"
    elseif ii==n[3]..n[2] then int=3 strng=" has far too many flowers"
    elseif ii==n[3]..n[1] then int=3 strng=" is drowining in water"
    end
    UO.ExMsg(ii[2],3,exmess[int],"Bee "..math.ceil(i/2)..strng)
    print("Bee "..math.ceil(i/2)..strng)
end
UO.SysMessage("A report has been created in the console for your consideration.")
end

function hitButton(mx,my, int)
local pos=UO.ContPosX..UO.ContPosY
timer=getticks()+250
   while timer>getticks() do
      if UO.ContSizeX..UO.ContSizeY==gump[int].x..gump[int].y
      and UO.GetPix(UO.ContPosX+gump[int].cx,UO.ContPosY+gump[int].cy)==gump[int].c then
         UO.Click(UO.ContPosX+mx, UO.ContPosY+my,true,true,true,false)
         return true
      end
   end
return false
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

function killBee()
--local bang,shot,kill=0,0,1 
local bang=0
timer=getticks()+1000
while timer>getticks() do
   for i, ii in pairs(findCont(0)) do
      for int=1,4 do
         if ii.sx==gump[int].x and ii.sy==gump[int].y then
            print("killing "..ii.sx.."x"..ii.sy)
            UO.Click(UO.ContPosX+UO.ContSizeX/2, UO.ContPosY+UO.ContSizeY/2, false, true, true, false)
            if int==2 then bang=bang+1 end
            --elseif int==1 then bang=bang-1
         end
      end
   end
end
--[[
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
end    ]]--
return bang
end

function killCont(int)
   for i=1,int do
      local cur, cursx, curx =UO.ContID, UO.ContSizeX, UO.ContPosX   
      while UO.ContID==cur and UO.ContSizeX==cursx and UO.ContPosX==curx do
         timer=getticks()+250
         UO.Click(UO.ContPosX+UO.ContSizeX/2, UO.ContPosY+UO.ContSizeY/2, false, true, true, false)
         while timer>getticks() do
            if UO.ContID~=cur or UO.ContSizeX~=cursx or UO.ContPosX~=curx then break end
         end
      end
   end
return int
end  

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

function openCont(id,int)
print("OPENC")
local cstate=UO.ContPosX..UO.ContPosY..UO.ContSizeX..UO.ContSizeY
   for i=0, 7 do
       UO.LObjectID=id
      timer=getticks()+250
      UO.Macro(17,0)
      while timer>getticks() do
         --if id then
            --if UO.ContID==id then return 1 end
         --elseif int then
         --print(UO.ContSizeX..UO.ContSizeY)
         --print(gump[1].x..gump[1].y)
         --if int then
         if int>0 then
            if UO.ContSizeX..UO.ContSizeY==gump[int].x..gump[int].y
               and UO.GetPix(UO.ContPosX+gump[int].cx,UO.ContPosY+gump[int].cy)==gump[int].c then
               return 1 
            end
         elseif cstate~=UO.ContPosX..UO.ContPosY..UO.ContSizeX..UO.ContSizeY then return 1 
         end
         --else
        -- end
      end
   end
return false
end

function potNum(u, a)
local u=u or 0
print("PNUM")
   timer=getticks()+500
   while timer>getticks() do
      if UO.ContSizeX..UO.ContSizeY==gump[1].x..gump[1].y
         and UO.GetPix(UO.ContPosX+78,UO.ContPosY+176)==526344 then break
     end
     findCont(gump[1].x, gump[1].y)
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
--table.insert(sub, table.remove(result))
--print(u.." "..a)
--print(mod)
--print(sub[2].." "..sub[1])
--sub[2]= sub[2]+mod
--print(sub[2].." "..sub[1])
table.insert(mid, table.remove(result))
return result,sub,mid
end

function useBee(id,x,y)
print("USE BEE")
   while getDist(x, y)>2 do movePath(x, y) end
   UO.LObjectID=id
   local subtime=getticks()+1000
   while subtime>getticks() do
      timer=getticks()+250
      UO.Macro(17,0)
      while timer>getticks() do
         if UO.ContSizeX..UO.ContSizeY==gump[1].x..gump[1].y then return 1 end
      end
   end
print("timeout")
stop()
return 0
end

function useItem(id, str, f)
UO.LObjectID=id
--print(str[1].." "..f[1])
local tmp
local timeout=getticks()+2000
   while timeout>getticks() do
      timer=getticks()+250
      UO.Macro(17,0)
      while timer>getticks() do
         tmp=journal(str, f)
         if tmp~=0 then return tmp end
    end
end
print("failed to open "..tmp)
return 0
end

function scan(tbl)
local item = {}
   for i=0, UO.ScanItems(true)-1,1 do
      local nid,typ,kind,contid,xu,yu,zu,stck = UO.GetItem(i)
      if nid==UO.BackpackID and not gwt then 
         local nma, inf = UO.Property(nid)
         gwt=math.abs(string.match(inf, "%d%d?", 3)-UO.Weight)
    end
      if typ==2331 then UO.HideItem(nid)
      else 
         for ii,iii in pairs(tbl) do
            if typ==iii then
               flag=true
               local nma, inf = UO.Property(nid) 
               for del,msg in pairs(baditem) do
                  if string.match(nma, msg) then flag=false break end
               end
               if flag then
                  if kind==1 and math.abs(UO.CharPosZ-zu)<=15 and zu>=UO.CharPosZ  then dir=getDist(xu, yu)
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

init()
happyBee()