dofile("../Lib/itemlib.lua")
dofile("../Lib/basiclib.lua")
dofile("../Lib/menulib.lua")
dofile("../Lig/config.lua")

function setPrice(price)
	for char in price:gmatch"." do
	    UO.Key(char)
	end
	UO.Key("ENTER")
	wait(500)
end

function stockBODBooks(bod_type)
	if bod_type ~= 5 then
		book_name = "Bulk Order Book"
		if bod_type == 1 then cont_id = 1116991999
		elseif bod_type == 2 then cont_id = 1116991996
		elseif bod_type == 3 then cont_id = 1116992000
		elseif bod_type == 4 then cont_id = 1116991992
		end
	else
		book_name = "Taming Bulk Order Book"
		cont_id = 1116991995
	end
	local books = item:scan():cont(UO.BackpackID):tp(8793):property():name(book_name)
	if next(books) == nil then
   		errorMsg('You have no BOD BOOKS')
		return
	end

	local bodDyeTub = item:scan():cont(UO.BackpackID):tp(4011):property():name("BOD Book Dyetub")
	if next(bodDyeTub) == nil then
   		errorMsg("You don't have a BOD Book Dyetub")
	end
	bodDyeTub = bodDyeTub:pop()

	for i = 1, #books do
    		local book = books:pop(i)
    		bodDyeTub:use()
    		wait(500)
    		book:target()
    		wait(500)
    		book:drop(cont_id)
    		wait(500)
    		setPrice("900")
	end
	UO.ExMsg(UO.CharID,3,60,"Bod Books Stocked")
end

function stockItem(item_tp, container,price)
	local items = item:scan():cont(UO.BackpackID):tp(item_tp)
	if next(items) == nil then
		errorMsg("No Items to stock")
		return
	end
	for i = 1, #items do
		items:pop(i):drop(container)
		wait(500)
	end
	UO.ExMsg(UO.CharID,3,60,"Items Stocked")
end

function stockRunebooks()
	local runebooks = item:scan():cont(UO.BackpackID):tp(8901)
	if next(runebooks) == nil then
		errorMsg("You have no runebooks to restock")
		return
	end
	for i =1, #runebooks do
		local book = runebooks:pop(i)
		book:drop(1100532054)
		wait(500)
    		setPrice("800")
	end
	UO.ExMsg(UO.CharID,3,60,"Runebooks Stocked")
end

function stockEngravers()
         local engravers = item:scan():cont(UO.BackpackID):tp(4031)
         if next(engravers) == nil then
            return
         end
         for i=1,#engravers do
             local engraver = engravers:pop(i):drop(1094551192)
             wait(500)
    	     setPrice("10000")
         end
end
trinApp = menu:form(175,225,"Stock Trinsic")

tameB = trinApp:button("tame",10,10,150,20,"Stock Taming Bod Books") 
bowB = trinApp:button("bow",10,35,150,20,"Stock Bowcraft Bod Books") 
bsB = trinApp:button("bs",10,60,150,20,"Stock Blacksmith Bod Books") 
carpB = trinApp:button("carp",10,85,150,20,"Stock Carpentry Bod Books")
tailorB = trinApp:button("tailor",10,110,150,20,"Stock Tailoring Bod Books")  
runeB = trinApp:button("rune",10,135,150,20,"Stock Runebooks")
engraverB = trinApp:button("engrave",10,160,150,20,"Stock Engravers")

tameB:onclick(function() stockBODBooks(5) end)
bowB:onclick(function() stockBODBooks(1) end)
bsB:onclick(function() stockBODBooks(2) end)
carpB:onclick(function() stockBODBooks(3) end)
tailorB:onclick(function() stockBODBooks(4) end)
runeB:onclick(function() stockRunebooks() end)
engraverB:onclick(function() stockEngravers() end)

trinApp:show()
Obj.Loop()
trinApp:free()
