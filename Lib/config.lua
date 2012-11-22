dofile("functions.lua")

--|||COMMON ITEM BOOLEAN||--
BOH = true
BOS = false
LOOT_BAG = false
LOOT_GOLD = true
STORAGE_KEYS = true

--||COMMON STAT VARIABLES||--
MAX_WEIGHT = 420

--|||COMMON ITEM IDS||--
BOH_ID = 1076683851
TRASH_ID = "{put your trash bag id here}" --Left in case scanner turns up nil
LOOT_BAG_ID = "{put your loot bag id here}"
BOS_ID = "{put your bag of sending id here}"
DEFAULT_RUNEBOOK_ID = "{put your default runebook id here}"

-- Config  Scanners
-- Trash locater (Also BoS, need type)
for i=0, UO.ScanItems(false)-1,1 do
    local id,typ,kind,contid,x,y,z,stack,rep,col = UO.GetItem(i)
    if (typ == 2482) and (contid == UO.Backpackid) then
       local name = UO.Property(id)
       if string.match(string.lower(name) , "trash") ~= nil then
			TRASH_ID = id
       end
    end
end


-- Resource Key IDs
local a, cnt = functions.AllGumps() --proper syntax?
for i=0, cnt-1 do
	if string.match(a[i].name, "container") ~= nil then -- ensure that a container is open, possibly not needed
		local b ={}
		for i=0, UO.ScanItems(false)-1,1 do
			local id,typ,kind,contid,x,y,z,stack,rep,col = UO.GetItem(i)
			if (typ == 5995) and (kind == 0) then
				if string.match(string.lower(UO.Property(id)), "stone") ~= nil then
					b.st, b.stc = id, contid
				elseif string.match(string.lower(UO.Property(id)), "spell") ~= nil then
					b.sp, b.spc = id, contid
				elseif string.match(string.lower(UO.Property(id)), "metal") ~= nil then
					b.m, b.mc = id, contid
				elseif string.match(string.lower(UO.Property(id)), "wood") ~= nil then
					b.w, b.wc = id, contid
				end
			end
		end
	end
end
