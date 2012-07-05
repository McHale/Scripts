dofile("../Lib/itemlib.lua")
dofile("../Lib/basiclib.lua")

lgAnimals =
{
{"Drake","Dragon","White Wyrm","Snake","Mongbat","Imp"},
{"Swamp Dragon","Ridgeback","Kirin","Unicorn","Nightmare","Fire Steed","Horse","Rideable Llama","Forest Ostard","Desert Ostard","Frenzied Ostard","Beetle"},
{"Dog","White Wolf","Timber Wolf","Grey Wolf","Hell Hound","Dire Wolf"},
{"Chicken","Sheep","Goat","Cow","Bull","Pig"},
{"Giant Spider","Frost Spider","Scorpion"},
{"Rat","Sewer Rat","Giant Rat"},
{"Cat","Panther","Cougar","Hell Cat"},
{"Brown Bear","Grizzly Bear","Black Bear","Polar Bear"},
{"Forest Ostard","Desert OStard","Bird","Chicken","Eagle"}
}

standAlone = 
{"Skittering Hopper","Alligator","Lava Lizard","Llama","Giant Toad",
"Snow Leopard","Walrus","Jack Rabbit","Slime","Rabbit","Hind","Great Hart",
"Mountain Goat","Predator HellCat","Boar"}


------------------------------------------------------------
------------------------------------------------------------
------------------------------------------------------------	

tame = {}
tame_meta = {__index = tame}

tames = {}
tames_meta = {__index = tames}

function tame:scanTamingBod(bod_index, book_name)
	bod_index = bod_index or 0
	book_name = book_name or ""
	local bods = item:scan():cont(UO.BackpackID):tp(8792):property():name("A Bulk Order Deed")
	local next = next
	if next(bods) ~= nil then
		local b = bods:pop(i)
		setmetatable(b,bod_meta)
		b["bod_type"] = 5
		b["bod_index"] = bod_index
		b["book_name"] = book_name
		b["base"] = b:Base()
		b["size"] = b:Size()
		b["items"] = b:Items()
		b["complete"] = b:Complete()
		b["largeFitting"] = b:LargeFitting()
		return b
	end
end

function tame:scanAllTaming()
	local bods = item:scan():cont(UO.BackpackID):tp(8792):property():name("A Bulk Order Deed")
	local next = next
	local a = {}
	for i=1,#bods do
		local b = bods:pop(i)
		setmetatable(b,bod_meta)
		b["bod_index"] = bod_index
		b["book_name"] = book_name
		b["items"] = b:Items()
		b["bod_type"] = b:bodType()
		b["items_values"] = b:ItemsValues()
		b["size"] = b:Size()
		b["base"] = b:Base()
		b["complete"] = b:Complete()
		b["largeFitting"] = b:LargeFitting()
		if b.bod_type ~= -1 then
			table.insert(a,b)
		end
	end
	return a
end
	

function tame:BodType()
	local items = self:Items()
	local next = next
	if next(items) == nil then 
		UO.ExMsg(UO.CharID,3,33,"Could not get type- setting to -1")
		return -1
	end
	local rightType = false
	for i = 1, #lgAnimals do
		local largeBod = lgAnimals[i]
		for i = 1, #largeBod do
			local animal = largeBod[i]
			if animal == items[1] then
				table.insert(self.largeFitting, largeBod)
			end
		end
	end
	for i = 1, #standAlone do
		local animal = standAlone[i]
		if animal == items[1] then
			self.largeFitting = false
		end
	end
	if self.largeFitting ~= nil then return -1 end
end
	
	
end
	
function tame:Items()
	smDeeds = {}
	for piece,amt in string.gmatch(self.stats,"(%a+%p?%a*%s*%a*%s?%a*): (%d+)") do
     		if piece ~= "Amount To Tame" then
       			table.insert(smDeeds, piece)	
    		end
	end
	return smDeeds
end

function tame:ItemsValues()
	values = {}
	for piece,amt in string.gmatch(self.stats,"(%a+%p?%a*%s*%a*%s?%a*): (%d+)") do
     		if piece ~= "Amount To Tame" then
       			table.insert(values, amt)	
    		end
	end
	return values
end

function tame:Complete()
	smDeeds = {}
	for piece,amt in string.gmatch(self.stats,"(%a+%p?%a*%s*%a*%s?%a*): (%d+)") do
     		if piece ~= "Amount To Tame" then
       			if amt ~= self.base then return false end
    		end
	end
	return true
end

function tame:Base()
	s,e,base = string.find(self.stats,"Amount To %a+: (%d+)")
	if base == nil then
		UO.ExMsg(UO.CharID,3,33,"Couldn't Grab Base")
		return "Error - didn't get a base number"
	end
	return base
end

function tame:Size()
	count = 0
	for piece,amt in string.gmatch(self.stats,"(%a+%p?%a*%s*%a*%s?%a*): (%d+)") do
     		if piece ~= "Amount To Tame"  then
       			count = count + 1
    		end
	end
	if count == 1 then
   		return "Small Bod"
	else
   		return string.format("%d-piece",count)
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
	if not self.standAlone then
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
function standAloneTamingSort()
	local taming_books = item:scan():cont(UO.BackpackID):tp(8793):property():name("Taming Bulk Order Book")
	local next = next
	if next(taming_books) == nil then
		UO.ExMsg(UO.CharID,3,33,"There are no Taming BOD books in your main pack.")
	end
	for i=1,#taming_books do
		local book = taming_books:pop(i)
		s,e = string.find(book.stats,"Book Name: Stand Alone")
		if s ~= nil then
			standalone = book
			standalone_index = i
		end
	end
	if standalone == nil then
		UO.ExMsg(UO.CharID,3,33,"There is no Stand Alone Book")
		 stop()
	end
	for i=1,#taming_books do
		local book = taming_books:pop(i)
		if i ~= standalone_index then
			s,e,count = string.find(book.stats,"Deeds In Book: (%d+)")
			if count == 0 then
				UO.ExMsg(UO.CharID,3,33,"There are no deeds in your book of small bods")
				stop()
			end
				for i=1, count do
					book:use():waitContSize(615,454)
					Click.Gump(40,105)
					wait(1000)
					local b = bod:scanTamingBod()
					wait(500)
					if b.standAlone then
					UO.Drag(b.id,b.stack)
    						UO.DropC(standalone.id)
						wait(500)
					else
					UO.Drag(b.id,b.stack)
						UO.DropC(book.id)
						wait(1000)
					end
				end
		end
	end
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
