dofile("../Lib/itemlib.lua")
dofile("../Lib/basiclib.lua")

price = "3500"


function setPrice()
	for char in price:gmatch"." do
	    UO.Key(char)
	end
	UO.Key("ENTER")
	wait(500)
end

function pricePage()	
	local page_end = false
	local count = 0
	local i = UO.ContPosY
	while not page_end do
		if i == UO.ContPosY + UO.ContSizeY then
			page_end = true
			break;
		end
		local pix = UO.GetPix(UO.ContPosX+590,i)
		if pix == 8094852 then
			count = count + 1 
			Click.Gump(590,i-UO.ContPosY)
			i = i+20
			wait(500)
			setPrice()
		else
			i = i+1
		end
	end
	return count
end

function setTaming()
	local bod_books = item:scan():cont(UO.BackpackID):property():name("Taming Bulk Order Book")

	if next(bod_books) == nil then
		UO.ExMsg(UO.CharID,3,33,"There are no Taming BOD Books in your Backpack")
		stop()
	end

	for i=1,#bod_books do
		local bod_book = bod_books:pop(i)
		bod_book:use():waitContSize(531,454)
		s,e,num_deeds = string.find(bod_book.stats,"Deeds In Book: (%d+)")
		count = 0
		while count < tonumber(num_deeds) do
			toAdd = pricePage()			
			count = count + toAdd
			Click.Gump(240, 425)
			wait(1000)
		end
	end
end

setTaming()
