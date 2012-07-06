dofile("../Lib/itemlib.lua")
dofile("../Lib/basiclib.lua")
dofile("../Lib/menulib.lua")
dofile("../Lib/journallib.lua")
dofile("../Lib/craftlib.lua")
dofile("../Lig/config.lua")

tHour, tMinute, tSecond, tMillisec = gettime()

----------------------DRUID FUNCTIONS----------------------
function castTrees()
	myjournal = journal:new()
	UO.Macro(1,0,"[cs enchantedgrove")
	WaitForTarget()
	UO.Macro(23,0)
	wait(250)
	if myjournal:next() ~= nil then
		if myjournal:find("The spell Fizzles.", 
                "Your concentration is disturbed, thus runing thy spell."
                ,"Insufficient mana for this spell.") ~= nil then	
                      castTrees()
               end
	end
	tHour, tMinute, tSecond, tMillisec = gettime()
end

function needTrees()
	nHour,nMinute,nSecond,nMillisec = gettime()	
	dSecond = math.abs(nSecond - tSecond)
	if dSecond >= 20 then 
	   castTrees()
        end
end	
--------------------------------------------
--------------------------------------------

----------------------MAGE S.BOOK----------------------
function dropScrolls(spellBookID)
	local scroll_types = {}
	for i=7981,8044 do
		table.insert(scroll_types, i)
	end
	local scrolls = item:scan():cont(UO.BackpackID):tp(scroll_types)
	for i=1,#scrolls do
		local scroll = scrolls:pop(i)
		scroll:drop(spellBookID) 
		wait(100)
	end
end

function getSpellBookID()
	local spellbooks = item:scan():cont(UO.BackpackID):tp(3834)
	spellbooks:property()
	spellbooks = spellbooks:name("Spellbook")
	for i=1,#spellbooks do
    		spellbook = spellbooks:pop(i)
    		if string.find(spellbook.stats, "64 Spells") ~= nil then
      			print("Whoo not what i want")
    		else 
			return spellbook.id
		end
	end
	return 0
end

function spellBook()
sb_id = getSpellBookID()
for i=1,8 do
	for j=1,8 do
		if i > 5 then
			needTrees()
		end
    	        Craft.Make("scribe",i,j,nil,1)
		wait(100)
	end
	UO.SysMessage(string.format("%s %i %s","Circle",i,"completed." ))
	dropScrolls(sb_id)
end
dropScrolls(sb_id)
end
--------------------------------------------
--------------------------------------------


----------------------NECRO S.Book----------------------
function dropScrolls2(spellBookID)
	local scroll_types = {}
	for i=8800,8817 do
		table.insert(scroll_types, i)
	end
	local scrolls = item:scan():cont(UO.BackpackID):tp(scroll_types)
	for i=1,#scrolls do
		local scroll = scrolls:pop(i)
		scroll:drop(spellBookID) 
	end
end

function getSpellBookID2()
	local spellbooks = item:scan():cont(UO.BackpackID):tp(8787)
	spellbooks:property()
	spellbooks = spellbooks:name("Necromancer Spellbook")
	for i=1,#spellbooks do
    		spellbook = spellbooks:pop(i)
    		if string.find(spellbook.stats, "16 Spells") ~= nil or  string.find(spellbook.stats,"17 Spells") then
      			print("Whoo not what i want")
    		else 
			return spellbook.id
		end
	end
	return 0
end

function necroBook()
	sb_id = getSpellBookID2()
	for i=1,16 do
		if i > 6 then
			needTrees()
		end
	 	Craft.Make("scribe",9,i,nil,1)
		wait(100)
	end
	dropScrolls(sb_id)
	dropScrolls(sb_id)
	Craft.Make("scribe",9,16,nil,1)
end






 --creates a 400x200 window with title "My test menu"
spellApp = menu:form(200,100,"S.Book Maker")

-- adds a button to the form at 0,0 sized 100x20 and with text "click me!" on it
spellB = spellApp:button("mage",50,10,100,20,"Make SpellBook") 
dropMB = spellApp:button("dropM",50,35,100,20,"Drop Mage Spells")
necroB = spellApp:button("necro",50,60,100,20,"Make NecroBook") 
dropNB = spellApp:button("dropN",50,80,100,20,"Drop Necro Spells")



spellB:onclick(function() spellBook() end)
dropMB:onclick(function() 
sb_id = getSpellBookID()
dropScrolls(sb_id)
end)
necroB:onclick(function() necroBook() end)
dropMB:onclick(function() 
sb_id = getSpellBookID2()
dropScrolls2(sb_id)
end)


spellApp:show()
Obj.Loop()
spellApp:free()
