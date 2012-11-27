
dofile("../Lib/itemlib.lua")
dofile("../Lib/journallib.lua")


local conc_time = getticks()
local conc_delay = 15000

local prim_time = getticks()
local prim_delay = 1250

local second_time = getticks()
local second_delay = 1250

local momentum_time = getticks()
local momentum_delay = 1250

--if 1 use primary, if 2 use secondary, if 3 use momentum
local ability = 1
local myjournal = journal:new()
local ignore = {}


------------------------------------------------------
----------------FUNCTIONS-----------------------------
------------------------------------------------------

---------FINDING MOB RELATED FUNCTIONS----------------
   function range(from, to, step)
      step = step or 1
      return function(_, lastvalue)
        local nextvalue = lastvalue + step
        if step > 0 and nextvalue <= to or step < 0 and nextvalue >= to or
           step == 0
        then
          return nextvalue
        end
      end, nil, from - step
    end

function rangeList(to,from)
	local a = {}
	for i in range(to,from,1) do
		if i ~= 123 then
  			table.insert(a,i)
		end
	end
	return a
end


function remove(list, element)
	for i = 1, #list do
		if list[i].id == element then
			table.remove(list,i)
			return list
		end
	end
	return list
end


function removeIgnores(list)
	for i = 1, #ignore do
		list = remove(list,ignore[i])
	end
	return list
end

function findMob()
	local mob_list = rangeList(1,350)
	local mobs = item:scan(true):ground(10):tp({241,243,72, 11,48,28,71,70,776,757,795,756,796,763,304,752}):rep({3,4,5})
	if next(mobs) == nil then
	        print("No Mobs")
		return false
	else
		mobs = removeIgnores(mobs)
		if next(mobs) == nil then
		   print("No Reachable Mobs")
                   return false end
		return mobs:nearest()
	end
end

--^^^^^^^^^FINDING MOB RELATED FUNCTIONS^^^^^^^^^^^^^     }
------------------------------------------------------


-----------------ACTION/ABILITY FUNCTIONS-------------------
function sendGold()
	local gold = item:scan():cont(UO.BackpackID):tp(3821)
	if next(gold) == nil then return end
	for i=1,#gold do
		local pile = gold:pop(i)
		BOS:use()
		wait(500)
		pile:target()
		wait(250)
	end
end

function moveGold()
	local gold = item:scan():cont(UO.BackpackID):tp({3821,3903})
	if next(gold) == nil then return end
	for i=1,#gold do
		local pile = gold:pop(i)
		pile:drop(BOH)
	end
end


function conc_weap()
	if getticks() - conc_time > conc_delay then
		UO.Macro(15,203)
		conc_time = getticks()
		wait(250)
	end
end


function primary_ability()
	if getticks() - prim_time > prim_delay and UO.Mana > 35 then
		UO.Macro(35,0)
		prim_time = getticks()
	end
end

function secondary_ability()
	if getticks() - second_time > second_delay and UO.Mana > 20 then
		UO.Macro(36,0)
		second_time = getticks()
	end
end


function momentum_strike()
	if getticks() - momentum_time > momentum_delay and UO.Mana > 10 then
		UO.Macro(15,150)
		momentum_time = getticks()
	end
end

function use_Ability()
	if ability == 1 then
		primary_ability()
	elseif ability == 2 then
		secondary_ability()
	else
		momentum_strike()
	end
end

--^^^^^^^^^^^^^^^ACTION/ABILITY FUNCTIONS^^^^^^^^^^^^^^^^^^^^
-------------------------------------------------------------


--------------------ERROR/ITEM CHECKING FUNCTIONS---------------
function WaitForTarget()
	local timeout = 4000
	local current = getticks()
	while not UO.TargCurs do
		wait(1)
		if getticks() - current > timeout then return end
	end
end

function read_journal()
	if myjournal:next() ~= nil then
		if myjournal:find("Can't get there") ~= nil then
		      myjournal:clear()
		      wait(750)
                      return true
               end
	end
	return false
end

function pathfind(mob)
	UO.LTargetID = mob.id
	mob = item:scan():id(mob.id):property()
        if next(mob) == nil then
           return false
	else
            mob = mob:pop()
        end
	UO.Pathfind(mob.x,mob.y,mob.z)
	wait(500)
	errors = read_journal()
	if errors then
		table.insert(ignore, mob.id)
		return false
	end
	return mob
end

function checkDurability()
	local my_items = item:scan():cont(1091810):property()

	for i=1,#my_items do
	   local my_item = my_items:pop(i)
    	   local s,e,durability = string.find(my_item.stats,"Durability (%d+) / %d+")
           if durability ~= nil and tonumber(durability) <= 10 then
    	        print(my_item.name)
       		UO.Macro(15,210)
		WaitForTarget()
		runebook:target()
		stop()
    	   end
	end
end

--123 Angels, 744 Male Vamp, 745 Female Vamp, 400 Male, 401 female, 118 Mule, 190 Noble, 217 Imp Dog not shifted, 279 Imp Ferret, 278 Imp Squirrel
function findFriendlies()
	local friendlies = item:scan():tp({118, 123, 190, 217, 748, 278, 279, 400, 401, 744, 745, }):property()
	if #friendlies > 1 then
           return true
        end
	return false
end

---------------------YOM----------------------------------------------------
---------------------All your fun stuff will happen here-----------------
-------------------------------------------------------------------------
function attack(mob)
         use_Ability()
	UO.LTargetID = mob.id
	UO.Macro(27,0)
	wait(150)
	UO.Macro(13,15)
	wait(200)
	UO.LTargetID = mob.id
	UO.Macro(22,0)
	wait(150)
	if pathfind(mob) then
		conc_weap()
		use_Ability()
		UO.Macro(27,0)
		while pathfind(mob) do
			if UO.Stamina < 150 then
				UO.Macro(1,0,"[cs divinefury")
				wait(250)
			end
			conc_weap()
			UO.Macro(27,0)
			use_Ability()
			wait(1250)
		end
	end
	return findMob()
end

--------The loop
conc_weap()

mob = findMob()
while true do
        while type(mob) == "boolean" do
           wait(150)
           mob = findMob()
        end
	mob = attack(mob)
end
