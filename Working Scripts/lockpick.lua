dofile("../Lib/itemlib.lua")

local lockpicks = item:scan():cont(UO.BackpackID):tp(5372)

if next(lockpicks) == nil then
	UO.ExMsg(UO.CharID,3,33,"You have no lockpicks")
end

lockpicks = lockpicks:pop()

lockpicks:use()
wait(750)
while UO.TargCurs do
	wait(50)
end

while true do
	lockpicks:use():waitTarget():target(UO.LTargetID)
	wait(350)
end