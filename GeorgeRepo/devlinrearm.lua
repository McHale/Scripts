    -- Script: Ability Rearm-er
    -- Author: Devlin / OEUO by Themadxcow
    -- Current Version: 1.0
    -- Purpose: Rearms Prim/Sec Abilities, Momenum Strike and Counter Attack
    -- Read instructions in Forums -> Coding Talk
    --
    
    --Available hotkeys:
                        --'ESC', 'BACK', 'TAB', 'ENTER', 'CAPS', 'SPACE', 'PGDN', 'PGUP',
                        --'END', 'HOME', 'LEFT', 'RIGHT', 'UP', 'DOWN', 'INS', 'DEL',
                        --'NUM', 'SCROLL', 'CTRL', 'ALT', 'SHIFT', 'F1'-'F12', 'A'-'Z'
local ability={{nma='Primary',int=35,key='F10'},
              {nma='Secondary',int=36,key=false},
              {nma='Death Strike',int=246,key=false},
              {nma='Honorable Execution',int=145,key=false},
              {nma='Focus Attack',int=245,key=false},
              {nma='Ki Attack',int=248,key=false},
              {nma='Lightning Strike',int=149,key=false},
              {nma='Momentum Strike',int=150,key=false}}
              
local stance={{nma='Confidence',int=146,key=false},
              {nma='Counter Attack',int=148,key=false},
              {nma='Evasion',int=147,key=false}}
--------------------------
    
    local Stop=false --  Disables last choice.  Script will resume when another hotkey is pressed.
    local chiv=false
    local mana=25    -- This number represents when the script
                     -- will pause and wait for mana.

   -- Do not edit below
local gump={}
local keys={}
local colour={3217556,7041932}
local timer,cnter=0,0
local text={"You exude confidence","You prepare to "}

function init()
for i,ii in pairs(ability) do
    if ii.key then table.insert(keys,{id=ii.key,num=ii.int}) end
end 
cnter=#keys
for i,ii in pairs(stance) do
    if ii.key then  table.insert(keys,{id=ii.key,num=ii.int}) end    
end 
UO.SysMessage("Searching for "..(#keys).." spell icons")
local result=getConts()
timer=getticks()+10000
   local int=0
   while true do
      local int=getIcon(keys[#gump+1].num, result)
      if int>0 then table.insert(gump,{x=result[int].x,y=result[int].y,c=result[int].c}) int=0
         if #gump==#keys then break end
      elseif timer<getticks() then 
         result=getConts()
         timer=getticks()+10000
	 UO.SysMessage("Calibration failed.  Ensure ability icons are directly visible in the top most window. Retrying..")
      end
   end
   if Stop then table.insert(keys,Stop) end
return
end

function getIcon(alt, tbl)
local var=15
local result={}
if alt<100 then var=alt alt=0 end
--timer=getticks()+1000
UO.Macro(var,alt)
   --while timer>getticks() do
      for i,ii in pairs(tbl) do
         if UO.GetPix(ii.x,ii.y)~=ii.c then return i end
      end
   --end
return 0
end


function getConts()
local result,tmp={},{}
   for i=0, 999 do
      local a,nx,ny,nsx,nsy = UO.GetCont(i)
      if not a and not nx and not ny then cnt=i+1 break
      elseif nsx==48 and nsy==44 then
      --print(nx.."x"..ny)
      local bol=true
	--for t,tt in pairs(colour) do
--		if UO.GetPix(nx+3,ny+1)==tt then bol=true break end
	--end
	if bol then table.insert(tmp,{pos=i,x=nx+3,y=ny+1,c=0})
	else UO.SysMessage("Bad gump detected")
		UO.ContTop(i)
		UO.ContPosY=UO.ContPosY-20
		stop()
		end
      end
   end
   if not next(tmp) then UO.SysMessage("No spell icons found.") stop()
   elseif #tmp<#keys then UO.SysMessage("Not enough spell icons found.") stop()
   end
   for i,ii in pairs(tmp) do 
       UO.ContTop(ii.pos)
       --if UO.GetPix(ii.x,ii.y)==colour[1] or UO.GetPix(ii.x,ii.y)==colour[2] then
          --UO.SysMessage("A spell icon is being covered by another gump or external window.  Ignoring icon.") 
          tmp[i].c=UO.GetPix(ii.x,ii.y)
       --end
       
       end
--[[   for i,ii in pairs(tmp) do
         for t,tt in pairs(colour) do
      ---print(UO.GetPix(nx+3, ny+1).." "..i)
            local col=UO.GetPix(ii.x+3, ii.x+1)
             if col==tt then
                table.insert(result, {x=ii.x+3, y=ii.x+1, c=col, pos=i-1})
             end
      end
      --print(i)
   end             ]]--
   
   return tmp
end

function keyLoop()
init()
print("Ready to go.")
UO.SysMessage("Armed and ready.")
if chiv then ctime=getticks()-960*5 end
local hits,int,con,stand=0,0,0,0
   while true do
      if UO.Weight==0 then UO.Macro(8,2) wait(100) UO.Macro(10,2) end 
      for i,ii in pairs(keys) do
         if getkey(tostring(ii.id)) then 
            if i<=cnter then con=i
            else stand=i 
            end
         end
      end
      if UO.Mana>mana then
         if chiv and UO.CharStatus=="G" and ctime<getticks() then
            UO.Macro(15,203)
            wait(500)
            UO.Macro(15,205)
            ctime=ctime+960*12
         end
         if timer<getticks() or UO.EnemyHits~=hits or UO.Mana<int then
            if con>0  then hits,int=reArm(con,keys[con].num,1) end
            if stand>0 then hits,int=reArm(stand,keys[stand].num,3) end
         end
      end
   end
end

function reArm(num,alt,delay)
local var=15
--if UO.GetPix(gump[num].x, gump[num].y)~=colour[1] and UO.GetPix(gump[num].x, gump[num].y)~=colour[2]  then
--   UO.ContTop(gump[num].pos)
--   gump[num].pos=0
--end
--if UO.GetPix(gump[num].x, gump[num].y)~=colour[1] and UO.GetPix(gump[num].x, gump[num].y)==colour[2] then
if UO.GetPix(gump[num].x, gump[num].y)~=colour[1] then
if alt<100 then var=alt alt=0 end
   --local alt=math.max(0,2-int)*150
   --local var=math.min(36,int*20-5) 
   timer=getticks()+500*delay
   UO.Macro(var,alt)
   while timer>getticks() do
      if UO.GetPix(gump[num].x, gump[num].y)==colour[1] then return UO.EnemyHits, UO.Mana end
   end
end
return
end

keyLoop()