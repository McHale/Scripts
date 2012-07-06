---Jack Penny's Item Library
dofile("../Lib/itemlib.lua")
--Jack Penny's Menu Library
dofile("../Lib/menulib.lua")
dofile("../Lig/config.lua")

function getFollowers()
	--Scans the ground in a radius of 1, and grabs 1-Innocent[for unguilded] 
	--2-Friends[green/guilded] this is using the item library
	local followers = item:scan():ground(1):rep({1,2}):property()
	for i=1,#followers do
            local follower = followers:pop(i)
            if follower.id == UO.CharID then
               table.remove(followers, i)
               break
            end
        end
       	if #followers == 0 then 
           errorMsg("Followers are not out, or not close enough")
	   stop()
	end
	return followers
end 

function heal(follower)
	UO.Macro(1,0,"[cs touchoflife")
	while not UO.TargCurs do
		wait(150)
	end
	follower:target()
end
	
function rez(follower)
	--UO.Macro(1,0,string.format("%s follow me",follower.name))
	--wait(250)
	UO.Macro(1,0,"[band")
	while not UO.TargCurs do
		wait(150)
	end
	follower:target()
end

function cure(follower)
         UO.Macro(1,0,"[cs purge")
         while not UO.TargCurs do
               wait(150)
         end
         follower:target()
end 

function regen(follower)
	UO.Macro(1,0,"[cs sacredboon")
	while not UO.TargCurs do
		wait(150)
	end
	follower:target()
end

function singleComeCall(follower)
	UO.Macro(1,0,string.format("%s come",follower.name))
end

function singleStayCall(follower)
	UO.Macro(1,0,string.format("%s stay",follower.name))
end

function singleKillCall(follower)
         UO.Macro(1,0,string.format("%s kill",follower.name))
end

function setTarget()
	UO.Macro(13,4)
        wait(750)
        while UO.TargCurs do
		wait(100)
        end
	monster = UO.LTargetID
	return monster
end

function petButtons(index, follower, app)
	if index == 1 then
		line = app:label("newLabel",10,50,190,5,"-------------------------------------------------------")
		theLabel = app:label("theLabel",10,60,100,20,follower.name)
 		healB = app:button("healB",10,75,35,20,"Heal")
		healB:onclick(function() heal(follower) end)
		rezB = app:button("rezB",55,75,35,20,"Rez")
		rezB:onclick(function() rez(follower) end)
		cureB = app:button("cureB",100,75,35,20,"Cure")
		cureB:onclick(function() cure(follower) end)
		regenB = app:button("regenB",145,75,40,20,"Regen")
		regenB:onclick(function() regen(follower) end)
		--Next Row
		comeB = app:button("comeB",25,100,40,20,"Come")
		comeB:onclick(function() singleComeCall(follower) end)
		stayB = app:button("stayB",75,100,40,20,"Stay")
		stayB:onclick(function() singleStayCall(follower) end)
		killB = app:button("killB",125,100,40,20,"Kill")
                killB:onclick(function() singleKillCall(follower) end)
	else
		local offset = index-1
		local y = 60+offset*75
		local rowOne = y+15
		local rowTwo = rowOne+25
		line = app:label("newLabel",10,y-10,190,5,"-------------------------------------------------------")
		theLabel = app:label("theLabel",10,y,100,20,follower.name)
		healB = app:button("healB",10,rowOne,35,20,"Heal")
		healB:onclick(function() heal(follower) end)
		rezB = app:button("rezB",55,rowOne,35,20,"Rez")
		rezB:onclick(function() rez(follower) end)
		cureB = app:button("cureB",100,rowOne,35,20,"Cure")
		cureB:onclick(function() cure(follower) end)
		regenB = app:button("regenB",145,rowOne,40,20,"Regen")
		regenB:onclick(function() regen(follower) end)
		--Next Row
		comeB = app:button("comeB",25,rowTwo,40,20,"Come")
		comeB:onclick(function() singleComeCall(follower) end)
		stayB = app:button("stayB",75,rowTwo,40,20,"Stay")
		stayB:onclick(function() singleStayCall(follower) end)
		killB = app:button("killB",125,rowTwo,40,20,"Kill")
                killB:onclick(function() singleKillCall(follower) end)
	end
end


followers = getFollowers()
length = 60 + 70*#followers + 20*(#followers-1)

petApp = menu:form(200,length,"Pet Wrangler")


allL = petApp:label("all",10,10,100,20,"All Commands:")
allKillB = petApp:button("Kill",10,25,55,20,"Kill Target")
allKillB:onclick(function() 
UO.Macro(1,0,"All kill") 
wait(750)
UO.LTargetID = monster
UO.Macro(22,0)
end)
setB = petApp:button("Set",70,25,55,20,"Set Target")
setB:onclick(function() setTarget() end)
allFollowB = petApp:button("allFollow",130,25,50,20,"Follow")
allFollowB:onclick(function() UO.Macro(1,0,"All Follow Me") end)


for i=1, #followers do
	local follower = followers:pop(i)
	petButtons(i,follower,petApp)
end

petApp:show()
Obj.Loop()
petApp:free()
