dofile("resourceslib.lua")
dofile("menulib.lua")
dofile("functions.lua")
dofile("journallib.lua")



--[[
function getTargetTile(cardinalDirection)
	--UO.LTargetKind = 2
	if cardinalDirection == "North" then
		UO.LTargetY = UO.CharPosY-1
		UO.LTargetX = UO.CharPosX
	elseif cardinalDirection == "South" then
		UO.LTargetY = UO.CharPosY+1
		UO.LTargetX = UO.CharPosX
	elseif cardinalDirection == "East" then
		UO.LTargetY = UO.CharPosY
		UO.LTargetX = UO.CharPosX+1
	else
		UO.LTargetY = UO.CharPosY
		UO.LTargetX = UO.CharPosX-1
end
]]--

function Mine()
local success = false
if gump:search():id(UO.BackpackID) == nil then
	--[[UO.Macro(8,7)
	while UO.ContID ~= UO.BackpackID do
		wait(50)
	end--]]
	errorMsg("Please open your backpack and restart.")
	return
end

local tbl ={}
local this = {Type.SHOVEL, Type.PICKAX}
tbl =item:scan():cont(UO.BackpackID):tp(this)
if #tbl == 0 then
	errorMsg("Cannot locate any tools.")
	return
end

repeat
if success = false then
	local t, x, y, z, k= getLoc()
	if t == false then
		errorMsg("Cannot find suitable spot.")
		return
	end
end

while UO.LObjectID ~= tbl[1].id do		UO.LObjectID == tbl[1].id	end
while UO.LTargetX ~= x do				UO.LTargetX == x			end
while UO.LTargetY ~= y do				UO.LTargetY == y			end
while UO.LTargetZ ~= z do				UO.LTargetZ == z			end
while UO.LTargetTile ~= t do			UO.LTargetTile == t			end
while UO.LTargetKind ~= k do			UO.LTargetKind == k			end

repeat
UO.Macro(17,0)
pop:waitTarg()

while UO.TargCurs == true do			UO.Macro(22,0)				end

local success = scan(200)

if success == 0 then
	UO.SysMessage("Please dismount and try again")
	return
end
if wCheck() == true then
	UO.SysMessage("Weight limit reached")
	return
	end
wait(300)
until success == 1

	UO.SysMessage("Area Complete")
	return
end


function scan(timeout)
for i=0, timeout do
local jourRef, jourCnt = UO.ScanJournal(oldRef)
	if oldRef ~= jourRef then
		local lines = UO.GetJournal(0)
		local oldRef = jourRef

		if string.match(lines, "no metal") ~= nil then						return 1
		elseif string.match(lines, "You put some ") ~= nil then			return true
		elseif string.match(lines, "while riding.") ~= nil then			return 0
		elseif string.match(lines, "You loosen some rocks") ~= nil then	return true
		elseif string.match(lines, "You carefully") ~= nil then			return true
		elseif string.match(lines, "That is too far away.") ~= nil then	return false
		elseif string.match(lines, "You can't mine there.") ~= nil then	return false
		elseif string.match(lines, "Target cannot be seen.") ~= nil then	return false
		elseif UO.Weight > oldWgt then										return true
		end
	end
	wait(10)
end
return false
end

function getLoc()
local tileData = UO.TileInit(false)
local x,y=10,10
local oldPos = {}
for i=0, 1000 do
	while x+y > 5 dofile
		x, y = math.random(-2,2), math.random(-2,2)
		for ii=1,#oldPos do
			if x..y == oldPos[ii] then
				x=10
			end
		end
	end
	table.insert(oldPos, x..y)
	local locX, locY = (UO.CharPosX + x), (UO.CharPosY + y)
	local tileCnt = UO.TileCnt(locX, locY)
	for i=0, (tileCnt-1) do
		local TType, ZZ, NName= UO.TileGet(locX ,locY, tileCnt, UO.CursKind)
		if math.abs(ZZ) - math.abs(UO.CharPosZ) < math.abs(13)  then
			for tt in pairs(caveTiles) do
				if TType == cavetiles[tt] or string.match(NName, "cave") ~= nil then
					return TType, ZZ, locX, locY, 3
				end
			end
			for t in pairs(mineTiles) do
				if TType == mineabletiles[t] then
					return TType, ZZ, locX, locY, 2
				end
            end
		end
	end
end
	return false
end

function wCheck()
if UO.Weight == 0 then
	UO.SysMessage("Please open your status bar")
	while UO.Weight == 0 do wait(10) end
--[[UO.Macro(8,2)
	wait(100)
	end
	]]--
end
if UO.Weight > 400 or UO.Weight > UO.MaxWeight then	return false	end
return true
end


mineApp = menu:form(200,200,"Miner's Spellbook")


mineStart = mineApp:button("mine",50,10,100,20,"Start Mining")
--oreSmelt = mineApp:button("smelt",50,35,100,20,"Smelt Ore")
--reStore = mineApp:button("store",50,60,100,20,"Store Resources")

mineStart:onclick(function() Mine() end)
--oreSmelt:onclick(function() Smelt() end)
--reStore:onclick(function() Store() end)

mineApp:show()
Obj.Loop()
mineApp:free()
