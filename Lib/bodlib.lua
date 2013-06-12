-------------------------------------------------------------------
-----------------BULK ORDER DEED LIBRARY---------------------------
-------------------------------------------------------------------
-------------------------------------------------------------------
-------BODS ARE IDENTIFIED AS DEEDS IN YOUR BACKPACK
-------------------------------------------------------------------
-------------------------------------------------------------------
-------BOD IDENTIFYING FUNCTIONS
----
----bod:Caliber()  returns a string "Normal" or "Exceptional"
----
----bod:Resource(bod_type) returns a string containing resource type
--or an Error String If one was failed to be found.
----
----bod:Base() returns a number/string of 10,15,or 20 or error string
----
----bod:Item(deed) returns a list of item name - either {name} if its a small
--bod or {name1,name2..nameN} if its a large bulk order deed
----
----bod:Size(bod_type) returns a string denoting bod size
----
----bod:RewardValue(resource,base,size,caliber,bod_type) returns calculated reward value
----
----bod:RewardTier(value,bod_type) returns the tier/ranking of the reward to be returned
----
----bod:Reward(tier,bod_type) returns string listing bod reward
----
-------------------------------------------------------------------
-------------------------------------------------------------------
-------------------------------------------------------------------

dofile("itemlib.lua")
dofile("basiclib.lua")
dofile("..\..\data\bod_data.lua")

bod = {}
bod_meta = {__index = bod}

bods = {}
bods_meta = {__index = bods}

function bod:scanBod(bod_index,book_name,scan)
    bod_index = bod_index or 0
    book_name = book_name or ""
    local bods = item:scan():cont(UO.BackpackID):tp(8792):property():name("A Bulk Order Deed")
    if next(bods) ~= nil then
	local b = bods:pop(i)
	b["bod_index"] = bod_index
	b["book_name"] = book_name
	setmetatable(b,bod_meta)
	b["bod_type"] = b:BodType()
	b["items"] = b:Items()
	b["size"] = b:Size()
	b["caliber"] = b:Caliber()
	b["base"] = b:Base()
	b["resource"] = b:Resource()
	b["largeFits"] = b:LargeFitting()
	b["value"] = b:RewardValue()
	b["tier"] = b:RewardTier()
	b["reward"] =  b:Reward()
	--b:ExMsgAll()
	--wait(2000)
	--b:ExCrossRef()
    	return b
    end
    return false
end



----Crafting Related functions
function bod:craftCategory()
	for k,v in pairs(Craft_Gump[self.bod_type]) do
		for i = 1, #v do
			if v[i] == self.items[1] then
				return k
			end
		end
	end
end

function bod:craftIndex()
	for k,v in pairs(Craft_Gump[self.bod_type]) do
		for i = 1, #v do
			if v[i] == self.items[1] then
				return i
			end
		end
	end
end

function bod:getProfession()
	if self.bod_type == 1 then return "bowyer"
	elseif self.bod_type == 2 then return "smith"
	elseif self.bod_type == 3 then return "carpenter"
	else return "tailor" end
end

function bod:BodType()
	local items = self:Items()
	local next = next
	if next(items) == nil then
		UO.ExMsg(UO.CharID,3,33,"Could not get type- stopping script")
		stop()
	end
	local toCheck = items[1] --only need to find one item
	for i=1,#Bowcraft_Items do
		if toCheck == Bowcraft_Items[i] then
			return 1
		end
	end
	for i=1,#Blacksmith_Items do
		if toCheck == Blacksmith_Items[i] then
			return 2
		end
	end
	for i=1,#Carpentry_Items do
		if toCheck == Carpentry_Items[i] then
			return 3
		end
	end
	return 4
end


function bod:Caliber()
	s,e = string.find(self.stats,"All Items Must Be Exceptional")
	if s == nil then
		return "Normal"
	else
		return "Exceptional"
	end
end

function bod:Resource()
	s,e,resource = string.find(self.stats,"All Items Must Be Crafted With (%a+%s?%a+)")
	if resource == nil then
		if self.bod_type == 2 then return "Iron Ingots"
		elseif self.bod_type ==1 or self.bod_type == 3 then
			return "Natural Wood"
		elseif self.bod_type==4 then
			return "Cloth/Leather"
		end
	end
	return resource
end

function bod:Items()
	smDeeds = {}
	for piece,amt in string.gmatch(self.stats,"(%a+%p?%a*%s*%a*%s?%a*): (%d+)") do
     		if piece ~= "Amount To Make" then
       			table.insert(smDeeds, piece)
    		end
	end
	return smDeeds
end

function bod:ItemsValues()
	values = {}
	for piece,amt in string.gmatch(self.stats,"(%a+%p?%a*%s*%a*%s?%a*): (%d+)") do
     		if piece ~= "Amount To Make" then
       			table.insert(values, amt)
    		end
	end
	return values
end

function bod:Update()
	self["complete"] = self:Complete()
end

function bod:Complete()
	smDeeds = {}
	for piece,amt in string.gmatch(self.stats,"(%a+%p?%a*%s*%a*%s?%a*): (%d+)") do
     		if piece ~= "Amount To Make" then
       			if amt ~= self.base then return false end
    		end
	end
	return true
end

function bod:Base()
	s,e,base = string.find(self.stats,"Amount To %a+: (%d+)")
	if base == nil then
		UO.ExMsg(UO.CharID,3,33,"Couldn't Grab Base")
		return "Error - didn't get a base number"
	end
	return base
end

function bod:Size()
	count = 0
	for piece,amt in string.gmatch(self.stats,"(%a+%p?%a*%s*%a*%s?%a*): (%d+)") do
     		if piece ~= "Amount To Make" then
       			count = count + 1
    		end
	end
	if count == 1 then
   		return "Small Bod"
	else
		if self.bod_type ~= 2 then
   			return string.format("%d-piece",count)
		else
			if count == 6 then return "Platemail"
			elseif count == 4 then return "Ringmail"
			else return "Chainmail" end
		end
	end
end

function bod:LargeFitting()
	local lgItems = LgItems[self.bod_type]
	if #self.items > 1 or self.size ~= "Small Bod" then
		return true
	end
	local a = {}
	for i=1,#lgItems do
		lgBod = lgItems[i]
		for i=1,#lgBod do
			---must be small only 1 item
			if self.items[1] == lgBod[i] then
				table.insert(a,lgBod)
			end
		end
	end
	if next(a) ~= nil then
		return a
	end
	return false
end

function bod:ExMsgBod()
	size = self.size
	base = self.base
	resource = self.resource
	caliber = self.caliber
	if not self.largeFits then
		standAlone = "--Stands Alone"
	else
		standAlone = ""
	end
--	UO.Macro(1,0,string.format("%s: %s %s [%s]%s",size,resource,base,caliber,standAlone))
	UO.ExMsg(UO.CharID, 3, 40,string.format("%s: %s %s [%s]%s",size,resource,base,caliber,standAlone))
end

function bod:ExCrossRef()
	if self.size == "Small Bod" and self.largeFits then
		UO.ExMsg(UO.CharID,3,65,"Cross-Referencing....")
		for i = 1, #self.largeFits do
			if self.bod_type ~= 2 then
				local a = {}
				setmetatable(a,bod_meta)
				a["base"] = self.base
				a["size"] = string.format("%d-piece",#self.largeFits[i])
				a["bod_type"] = self.bod_type
				a["largeFits"] = true
				a["caliber"] = self.caliber
				a["resource"] = self.resource
				a["value"] = a:RewardValue()
				a["tier"] = a:RewardTier()
				a["reward"] = a:Reward()
				a:ExMsgAll()
				wait(3000)
				UO.ExMsg(UO.CharID,3,65,"--------------------")
			elseif self.bod_type == 2 then
				local a = {}
				setmetatable(a,bod_meta)
				a["base"] = self.base
				armor_type = ""
				if #self.largeFits[i] == 3 then armor_type = "Chainmail"
				elseif #self.largeFits[i] == 4 then armor_type = "Ringmail"
				else armor_type = "Platemail" end
				if armor_type == "" then
					UO.ExMsg(UO.CharID,3,33,"Error cross referencing")
					return
				end
				a["size"] = armor_type
				a["bod_type"] = self.bod_type
				a["largeFits"] = true
				a["caliber"] = self.caliber
				a["resource"] = self.resource
				a["value"] = a:RewardValue()
				a["tier"] = a:RewardTier()
				a["reward"] = a:Reward()
				a:ExMsgAll()
				wait(3000)
				UO.ExMsg(UO.CharID,3,65,"--------------------")
			end
	end
	end
end


function bod:RewardValue()
	local b_tp = self.bod_type
	local baseVal = Base[self.base]
	local sizeVal = Size[b_tp][self.size]
	local exceptionalVal = Exceptional[b_tp][self.caliber]
	local resourceVal = Resource[b_tp][self.resource]

	return baseVal + sizeVal + exceptionalVal + resourceVal
end

function bod:RewardTier()
	toReturn = -1
	local b_tp = self.bod_type
	reward_range = Reward_Range[b_tp]
	for i = 1, #reward_range do
		if i == #reward_range then return i end
		if self.value >= reward_range[i] and self.value < reward_range[i+1] then
			return i
		end
	end
	return toReturn
end

function bod:Reward()
	return Reward[self.bod_type][self.tier]
end

function bod:ExMsgReward()
--	UO.Macro(1,0,string.format("%d - %s",self.value, self.reward))
	UO.ExMsg(UO.CharID, 3, 50,string.format("%d - %s",self.value, self.reward))
end

function bod:ExMsgAll()
	self:ExMsgBod()
	self:ExMsgReward()
end

function bod:compare(otherBod)
	nameA, nameB = self.name, otherBod.name
	baseA, baseB = self.base, otherBod.base
	expA, expB = self.caliber, otherBod.caliber
	resourceA, resourceB = self.resource, otherBod.resource
	if nameA == nameB and baseA == baseB and expA == expB and resourceA == resourceB then
		return true
	end
	return false
end

function bod:SubBod(smBod)
	if self.size == "Small Bod" or smBod.size ~= "Small Bod" then
		return false
	end
	if self.base == smBod.base and self.resource == smBod.resource then
		if self.caliber == "Normal" or self.caliber == smBod.caliber then
			return true
		end
	end
end

--------------------------------------------------------------
-----------------------BOD BOOK FUNCTIONS---------------------
function bods:scanBooks()
    local bod_books = item:scan():cont(UO.BackpackID):tp(8793):property():name("Bulk Order Book")
    local next = next
    if next(bod_books) == nil then
	UO.ExMsg(UO.CharID,3,33,"There are no BOD books in your main pack.")
    end
    local deeds = {}
    for i = 1,#bod_books do
	book = bod_books:pop(i)
	s,e,count = string.find(book.stats,"Deeds In Book: (%d+)")
	if count == 0 then
		UO.ExMsg(UO.CharID,3,33,"There are no deeds in your book of small bods")
		stop()
	end
	s,e,name = string.find(book.stats,"Book Name: (%a+%s?%a+)")
	if name ~= nil then
		book["book_name"] = name
	end
	for i=1, count do
		book:use():waitContSize(615,454)
		Click.Gump(40,105)
		wait(1000)
		b = bod:scanBod(i,name)
		table.insert(deeds, b)
		if not b.standAlone then
    			UO.Drag(b.id,b.stack)
    			UO.DropC(book.id)
			wait(1000)
		end
	end
    end
    setmetatable(deeds,bods_meta)
    return deeds
end

function bods:tier(nTier)
    local a = {}
    if type(nTier) ~= "table" then
        nTier = {nTier}
    end

    for i = 1,#self do
        for j = 1,#nTier do
            if self[i].tier == nTier[j] then
                table.insert(a,self[i])

            end
        end
    end

    setmetatable(a,bods_meta)

    return a
end

function bods:size(nSize,keep)
    keep = keep or true
    local a = {}
    if type(nSize) ~= "table" then
        nSize = {nSize}
    end
    for i = 1,#self do
	if keep then
		if contains(nSize, self[i].size) then
			table.insert(a,self[i])
		end
	else
		if not contains(nSize, self[i].size) then
                	table.insert(a,self[i])
       	 	end
	end
    end

    setmetatable(a,bods_meta)
    return a
end

function bods:bod_tp(nType)
    local a = {}

    if type(nType) ~= "table" then
        nType = {nType}
    end

    for i = 1,#self do
        for j = 1,#nType do
            if self[i].tp == nType[j] then
                table.insert(a,self[i])
            end
        end
    end

    setmetatable(a,bods_meta)
    return a
end

function bods_setmetatable(theList)
	setmetatable(theList,bods_meta)
end

function contains(theList, theItem)
	local next = next
	if next(theList) == nil then
		return false
		--empty list
	end
	for i=1, #theList do
		if type(theList[i]) == "table" then
			 return theList[i]:compare(theItem)
		else
			return theList[i] == them
		end
	end
	return false
end
