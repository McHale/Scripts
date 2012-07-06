--[[
;----------------------------------
; Script Name: GetHitBarLife.txt
; Author: Kal In Ex
; Version: 2.0
; Client Tested with: 7.0.10.1 (Patch 62)
; EUO version tested with: OpenEUO
; Shard OSI / FS: OSI
; Revision Date: November 29, 2010
; Public Release: December 2, 2007
; Purpose: get pet health 0-100%
; Copyright: 2007,2010 Kal In Ex
;----------------------------------]]

local GetCont = function(i)
	local t = {Index = i}
	t.Name,t.X,t.Y,t.SX,t.SY,t.Kind,t.ID,t.Type,t.HP = UO.GetCont(i)
	return t
end

GetHitBarLife = function(ID)
	local hitbar
	for i=0,999 do
		hitbar = GetCont(i)
		if hitbar.Kind == nil then
			return nil, nil
		end
		if hitbar.ID == ID and hitbar.Name == "status gump" then
			index = i
			break
		end
	end
	local x = 38 + hitbar.X
	local y = 43 + hitbar.Y
	local c = UO.GetPix(x,y)
	local b  = math.floor(c/65536)
	local g = math.floor((c%65536)/256)
	local r   = math.floor((c%65536)%256)
	print(b,g,r)
	local color = "blue"
	if b > r and b > g then color = "blue"  end
	if g > b and g > r then color = "green" end
	if r > b and r > g then color = "red" end
	return hitbar.HP,color
end
