--==========================================================
-- Script Name: Common Functions
-- Author: McHale
-- Version: 0.1
-- OpenEUO version tested with: 0.91
-- Purpose: Hold Commonly Used Code Blocks as Functions
-- and to simplifiy the arguments
--==========================================================

function errorMsg(msg)
	UO.ExMsg(UO.CharID,3,33,msg)
end


-- Gump Collection

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

-- Backpack Check
function PackCheck()
local a, cnt = AllGumps()
	for i=0, cnt-1 do
		if a[i].id == UO.BackpackID then
			return true
		end
	end
	return false
end
