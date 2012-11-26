--==========================================================
-- Script Name: Common Functions
-- Author: McHale
-- Version: 0.1a
-- OpenEUO version tested with: 0.91
-- Purpose: Hold Commonly Used Code Blocks as Functions
-- and to simplifiy the arguments
-- Functions:
-- 		errorMsg(string)

--		Clicks
-- 		C.Left(x,y)
--		C.Right(x,y)
--		C.gumpump(x,y)
--		C.Closegumpump()

--		Gumps	/	Filters
--		gump:search

--		gump:id(val)
--		gump:tp(val)
--		gump:coord(x,y)
--		gump:size(x,y)
--		gump:name(str)
--		gump:kind(val)
--		gump:hp(val)
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

function C.gumpump(x,y)
	C.Left(UO.ContPosX+x,UO.ContPosY+y)
end

function C.Closegumpump()
	C.Right(UO.ContPosX+UO.ContSizeX/2,UO.ContPosY+UO.ContSizeY/2)
end

gump = {}
gump_meta = {__index = gump}

function gump:search()
local a = {}
	for i=0, math.huge do
    local sName,nX,nY,nSX,nSY,nKind,nId,nType,nHP = UO.gumpetCont(i)
		if sName ==nil then
			setmetatable(a, gump_meta)
			return a, i
		else
			table.insert(a, {name=string.lower(sName),x=nX,y=nY,sizex=nSX,sizey=nSY,kind=nKind,id=nId,tp=nType,hp=nHP})
		end
	end
end

function gump:name(str)
local a = {}
    if type(str) ~= "table" then
        str = {str}
    end
    for i = 1,#self do
        for ii = 1,#str do
            if string.match(self[i].name, string.lower(str[ii])) ~= nil then
                table.insert(a,self[i])
            end
        end
    end
    setmetatable(a,gump_meta)
    return a
end

function gump:tp(val)
local a = {}
    if type(val) ~= "table" then
        val = {val}
    end
    for i = 1,#self do
        for ii = 1,#str do
            if self[i].tp == val[ii] ~= nil then
                table.insert(a,self[i])
            end
        end
    end
    setmetatable(a,gump_meta)
    return a
end

function gump:hp(val)
local a = {}
    if type(val) ~= "table" then
        val = {val}
    end
    for i = 1,#self do
        for ii = 1,#str do
            if self[i].hp == val[ii] ~= nil then
                table.insert(a,self[i])
            end
        end
    end
    setmetatable(a,gump_meta)
    return a
end

function gump:size(cx, cy)
local a = {}
    for i = 1,#self do
		if self[i].sizex..self[i].sizey == cx..cy ~= nil then
			table.insert(a,self[i])
        end
    end
    setmetatable(a,gump_meta)
    return a
end

function gump:id(val)
local a = {}
    if type(val) ~= "table" then
        val = {val}
    end
    for i = 1,#self do
        for ii = 1,#str do
            if self[i].id == val[ii] ~= nil then
                table.insert(a,self[i])
            end
        end
    end
    setmetatable(a,gump_meta)
    return a
end

function gump:kind(val)
local a = {}
    if type(val) ~= "table" then
        val = {val}
    end
    for i = 1,#self do
        for ii = 1,#str do
            if self[i].k == val[ii] ~= nil then
                table.insert(a,self[i])
            end
        end
    end
    setmetatable(a,gump_meta)
    return a
end

function gump:coord(cx, cy)
local a = {}
    for i = 1,#self do
		if self[i].x..self[i].y == cx..cy ~= nil then
			table.insert(a,self[i])
        end
    end
    setmetatable(a,gump_meta)
    return a
end
