local item={3973,3636}
local title={"healer","mage","chemist","fortune","herb","scribe","rovisioner","map"}


function main()
local loc=0
local sell={}
while true do
--if getticks()-global>50000 then UO.ExMsg(UO.CharID,3,68,"Reseting")  end
--print(loc.." "..UO.CharPosX+UO.CharPosY+UO.CursKind)
if loc~=UO.CharPosX+UO.CharPosY+UO.CursKind then
   loc=UO.CharPosX+UO.CharPosY+UO.CursKind
   sell=check()
   if next(sell) then
      for i,ii in pairs(sell) do print(i)  vendor(ii) end
   end
end

end
end

function check(old)
local data={}
for i=0, UO.ScanItems(false)-1,1 do
     local nid,typ,kind,contid,xu,yu=UO.GetItem(i)
     if nid==0 then break end
     if kind==1 and getDist(xu,yu)<10 then 
     print(typ)
     if typ==400 or typ==401 or typ==758 then 
     local nma=UO.Property(nid)
        for t,tt in pairs(title) do
            if string.match(string.lower(nma),tt) then print(nma) table.insert(data,nid) break end
        end
     end
     end
end
return data
end
     

function vendor(id)
--while tmp==UO.CharPosX+UO.CharPosY+UO.CursKind do 
                 UO.Popup(id)
                 local timer=getticks()+500
                 while timer>getticks() do
                       if UO.ContKind==4488 then
                          UO.Click(UO.ContPosX+60,UO.ContPosY+35,true,true,true,false)
                          wait(500)
                       end
                       if UO.ContKind==54440 then scan(item) return end
                 end
--end
return
end

function getDist(x,y) return math.max(math.abs(UO.CharPosX-x),math.abs(UO.CharPosY-y)) end

function scan(tbl)
local tmp=0
result={0}
while true do
local bres,npos,ncnt,nid,typ,nmax,_,nma = UO.GetShop()
if npos==tmp then
   UO.Click(UO.ContPosX+45,UO.ContPosY+205,true,true,true,false)
   while UO.ContKind==54440 do  end
   return
end
print(typ.." "..npos)
for i,ii in pairs(tbl) do
    if typ==ii then
       local bol=true
       for t,tt in pairs(result) do
           if tt==nid then bol=false break end
       end
       
       if bol then
       
          UO.Click(UO.ContPosX-50,UO.ContPosY-135,true,true,true,false)
          wait(100)
          UO.Click(UO.ContPosX-50,UO.ContPosY-135,true,true,true,false)
          wait(100)
          UO.Click(UO.ContPosX-50,UO.ContPosY-135,true,true,true,false)
       end
       table.insert(result,nid)
       UO.SetShop(nid,nmax)
       break
    end
end
UO.Click(UO.ContPosX+80,UO.ContPosY-15,true,true,true,false)
tmp=npos
end
return
end

main()