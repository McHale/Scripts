function scan(tbl)
local item = {}
for i=0, UO.ScanItems(true)-1,1 do
    local nid,typ,kind,contid,xu,yu,zu,stck = UO.GetItem(i)
          if typ==2331 then UO.HideItem(nid) end
end
end

scan(2331)