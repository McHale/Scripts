dofile("../Lib/itemlib.lua")

--"sew","bs","bow"

craft_type = "bs"

if craft_type == "sew" then
--sewing_kit 3997, deed 5360
craft={["kit"]=3997,["deed"]=5360}
--tailor deeds container
container_id = 1114148728
elseif craft_type == "bow" then
craft={["kit"]=4130,["deed"]=5359}
container_id = 1114148731
elseif craft_type == "bs" then
craft={["kit"]=5092,["deed"]=5359}
container_id = 1113123491
end

repair_items = item:scan():cont(UO.BackpackID):tp({craft.kit,3827}):property()

toMake = 0
toUse = nil
toTarget = nil

for i=1, #repair_items do
    local repair_item = repair_items:pop(i)
    s,e,num = string.find(repair_item.name, "(%d+) Blank Scroll")
    if num ~= nil then
       toMake = num
       toTarget = repair_item
    end
    if repair_item.tp == craft.kit then
       toUse = repair_item
    end
end



toUse:use():waitContSize(530,437)
for i=1,toMake do
    UO.ExMsg(UO.CharID,3,30,string.format("Deed %d/%d",i,toMake))
UO.Click(UO.ContPosX+290, UO.ContPosY+350,true,true,true,false)
toTarget:waitTarget():target():wait(1000)
repair_deed = item:scan():cont(UO.BackpackID):tp(craft.deed):pop()
repair_deed:drop(container_id)
wait(750)
end