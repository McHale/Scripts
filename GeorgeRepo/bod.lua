--Written by Themadxcow 
local password=""
--------------------------------------------------------------------
local title={"Tailor","Animal Trainer","Blacksmith","Carpenter","Bowyer"}
local msg={"offer may be available in"}
--
local timer=0
local total=5
local char=0
local fn=""
oldRef=UO.ScanJournal(0)

function main()
fn=status()
local old,result={},{}
old=loader()
if next(old) then
   local tmp=gettime()
   for i,ii in pairs(old) do
       local cur=tmp-ii[1]-3
       if cur>0 then
          UO.SysMessage(title[ii[2]].." is due.")
       else
           UO.SysMessage(title[ii[2]].." will be available in "..math.abs(tonumber(string.sub(cur,1,5))).." hours.")
       end
   end
end
local loc=0
local sell,result={},{}
while true do
   sell=check(sell)
   if next(sell) then
      for i,ii in pairs(sell) do  
          local str=vendor(ii[1],ii[2])
          if str>0 then
             local a,b,c,d=gettime()
             table.insert(result,{a+(b/60)+((c/60)/60)+(((d/1000)/60)/60),str})
          else total=total-1
          end
      end
   end
   if #result>=total then 
      if total>0 then store(result)
      else UO.ExMsg(UO.CharID,3,34,"No BODs available!")
      end
      return 1
   end
end
end

function journal()
oldRef, jourCnt = UO.ScanJournal(oldRef)
   for i=jourCnt-1,0,-1 do
      local lines= UO.GetJournal(i)
      for ii,iii in pairs(msg) do
         if string.match(lines, iii)~=nil then return true end
      end             
   end  
   return false
end

function status()
if UO.Weight==0 then
   UO.Macro(8,2)
   timer=getticks()+500
   while true do
      if UO.Weight>0 then break
      elseif timer<getticks() then
         UO.Macro(8,2)
         timer=getticks()+500
      end
   end
end
UO.Macro(10,2)
return UO.CharName
end
   
     

function vendor(id,int)
UO.Popup(id)
timer=getticks()
   while true do
      if journal() then return 0 end
      if UO.ContKind==4488 and getticks()>timer then
         if int==2 then UO.Click(UO.ContPosX+94,UO.ContPosY+90,true,true,true,false)
         else UO.Click(UO.ContPosX+94,UO.ContPosY+70,true,true,true,false)
         end
         timer=getticks()+500 --90
      end
      if UO.ContSizeX==460 and UO.ContSizeY>=279 then 
         UO.Click(UO.ContPosX+115,(UO.ContPosY+UO.ContSizeY)-25,true,true,true,false)
         wait(500)
         if UO.ContSizeX~=460 then return int end
       end
   end
return 0
end

function getDist(x,y) return math.max(math.abs(UO.CharPosX-x),math.abs(UO.CharPosY-y)) end

function check(old)
local data={}
for i=0, UO.ScanItems(false)-1,1 do
     local nid,typ,kind,contid,xu,yu,zu=UO.GetItem(i)
     --if nid==0 then break end
     
     if nid~=UO.CharID and kind==1 and getDist(xu,yu)<10 and math.abs(zu-UO.CharPosZ)<=9 then 
        if typ==400 or typ==401 or typ==758 then 
           local nma=UO.Property(nid)
           for t,tt in pairs(title) do
              if string.match(string.lower(nma),string.lower(tt)) then table.insert(data,{nid,t}) break end
           end
        end
     end
end
return data
end

function logger(int)
UO.Macro(8,1)
while UO.ContID~=UO.CharID do  
UO.Macro(8,1)
wait(500)
end
UO.Click(UO.ContPosX+210,UO.ContPosY+110,true,true,true,false)
--UO.Key("X",false,true,false)
while UO.ContKind~=6356 do end
UO.Click(UO.ContPosX+125,UO.ContPosY+85,true,true,true,false)
while UO.ContKind~=8108 do end
UO.Msg(password..string.char(13))
while UO.ContKind~=53156 do end
UO.Click(UO.ContPosX+185,UO.ContPosY+420,true,true,true,false)
while UO.ContKind~=34972 do end
UO.Click(UO.ContPosX+345,UO.ContPosY+165+(int*40),true,true,true,false)
while not UO.CliLogged do UO.Click(UO.ContPosX+345,UO.ContPosY+165+(int*40),true,true,true,false) end
wait(960*3)
return
end

function store(tbl)
local f,e = openfile("_"..fn..".log","w")
for i,ii in pairs(tbl) do
if f then
   f:write(ii[1]," ",ii[2],"\n")
   UO.SysMessage("Saving "..title[ii[2]].." at time: "..ii[1])
else
    error(e,2) 
end
end
f:close()
UO.ExMsg(UO.CharID,3,68,"Save complete.")
return
end


function loader()
status()
local tbl={}
local f,e = openfile("_"..fn..".log","rb")         --r means read-only (default)
  if f then 
     while true do                           --anything other than nil/false evaluates to true
        local cx=f:read("*n")
        local str=f:read("*n")
        if str then table.insert(tbl, {cx,str})
        else f:close() break
        end
     end
     UO.SysMessage("Loaded "..#tbl.." time tables for "..fn)
     return(tbl)
else 
     f,e = openfile("_"..fn..".log","w")
     if f then
     f:write("")
     f:close()                              --if openfile fails it returns nil plus an error message
     end               
end 
UO.SysMessage("Creating new time table for "..fn)    
return tbl          --stack level 2, error should be reported 
end

function manage()
while char<4 do
char=char+main()
logger(char)
end
end

manage()