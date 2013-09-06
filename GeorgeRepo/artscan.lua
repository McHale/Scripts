--local data={}
--local next=next
function start()
while true do
for i=0, UO.ScanItems(false)-1,1 do
    --local bol=true
     local nid,typ,kind,contid,xu,yu=UO.GetItem(i)
      
     --if kind==1 then
        local nma,inf=UO.Property(nid)
              if string.match(inf,"Pug") then 
              local dir=""
                  if xu==UO.CharPosX then dir=""
                  elseif xu< UO.CharPosX then dir="west "
                  elseif xu>UO.CharPosX then dir="east " end
                  if yu==UO.CharPosY then dir=""..dir 
                  elseif yu<UO.CharPosY then dir="North "..dir          
                  elseif yu> UO.CharPosX then dir="South "..dir end
         UO.SysMessage(nma)
	      UO.ExMsg(UO.CharID,3,68,dir.." "..math.abs(UO.CharPosX-xu).." "..math.abs(UO.CharPosY-yu).." "..nid)
	      UO.ExMsg(nid,3,68,nma)
              end  
     --end      
     
end            
end
end

function getDist(x,y) return math.max(math.abs(UO.CharPosX-x),math.abs(UO.CharPosY-y)) end

start()