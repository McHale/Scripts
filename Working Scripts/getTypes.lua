dofile("../Lib/itemlib.lua")

function getTypes()
	local allItems = item:scan():ground(10):property()

	if next(allItems) == nil then wait(5000) end

	for i=1,#allItems do
		local newItem = allItems:pop(i)
		local toPrint = string.format("%s, %d",newItem.name,newItem.tp)
		print(toPrint)
	end
end

getTypes()


