--==========================================================
-- Script Name: Common Functions
-- Author: McHale
-- Version: 0.1a
-- OpenEUO version tested with: 0.91
-- Purpose: Hold Commonly Used Code Blocks as Functions
-- and to simplifiy the arguments
-- Functions:
-- 		errorMsg(string)

-- 		C.Left(x,y)
--		C.Right(x,y)
--		C.Gump(x,y)
--		C.CloseGump()

--		Packcheck(id)
--		AllGumps()
--==========================================================
-- Declarations
Click = {}
local C = Click

function errorMsg(msg)
	UO.ExMsg(UO.CharID,3,33,msg)
end

function C.Left(x,y)
	UO.Click(x,y,true,true,true,false)
end

function C.Right(x,y)
	UO.Click(x,y,false,true,true,false)
end

function C.Gump(x,y)
	C.Left(UO.ContPosX+x,UO.ContPosY+y)
end

function C.CloseGump()
	C.Right(UO.ContPosX+UO.ContSizeX/2,UO.ContPosY+UO.ContSizeY/2)
end

function Packcheck(nid)
local a, cnt = AllGumps()
	for i=0, cnt-1 do
		if a[i].id == nid then
			return true
		end
	end
	return false
end

function AllGumps()
local a = {}
	for i=0, math.huge do
    local sName,nX,nY,nSX,nSY,nKind,nId,nType,nHP = UO.GetCont(i)
		if sName ==nil then
			return a, i
		else
			a[i] = string.lower({name=sName,x=nX,y=nY,sizex=nSX,sizey=nSY,kind=nKind,id=nId,type=nType,hp=nHP})
		end
	end
end

function getTrashID
	for i=0, UO.ScanItems(false)-1,1 do
		local id,typ,kind,contid,x,y,z,stack,rep,col = UO.GetItem(i)
		if (typ == 2482) and (contid == UO.Backpackid) then
		   local name = UO.Property(id)
		   if string.match(string.lower(name) , "trash") ~= nil then
				TRASH_ID = id
		   end
		end
	end
end
--[[ === Already in .itemslib ==
function WaitForGump(x,y)
timeout = 1000
start = getticks()
	while not (UO.ContSizeX==x and UO.ContSizeY==y and current < timeout) do
		wait(5)
		current = getticks() - start
		print(current)
	end
end


function WaitForTarget()
	while not UO.TargCurs do wait(1) end
end
--]]
