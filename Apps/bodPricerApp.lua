dofile("../Lib/itemlib.lua")
dofile("../Lib/basiclib.lua")
dofile("../Lib/menulib.lua")
dofile("../Lib/functions.lua")

---------------VARIABLES TO SET---------------
priceStr = nil
bodbook = nil

function getName(book)
	s,e,name = string.find(book.stats,"Book Name: (.+)")
	if name ~= nil then
           return name
	end
	return "Bod Book Set"
end

function setBodBook()
	UO.ExMsg(UO.CharID,3,50,"Please select a Bulk Order Book to price.")
	UO.Macro(13,3)
	wait(750)
	while UO.TargCurs do
		wait(10)
	end
        local bodbooks = item:scan():id(UO.LTargetID)
	if next(bodbooks) == nil then
	   return -1
        end
        if next(bodbooks:tp(8793)) == nil then
           return -1
        end
 
        bodbooks:property()
        bodbook = bodbooks:pop()
        msgL.ctrl.Caption = getName(bodbook)
end

function setPrice()
	for char in priceStr:gmatch"." do
	    UO.Key(char)
	end
	UO.Key("ENTER")                                            
end

function waitGumpClose(x,y)
         while UO.ContSizeX == x and UO.ContSizeY == y do 
               wait(10)
         end
         wait(500)
end

function waitGumpOpen(x,y)
         while UO.ContSizeX ~= x or UO.ContSizeY ~= y do
               wait(10)
         end
end

function pricePage()	
	local page_end = false
	local count = 0
	local i = UO.ContPosY
	while not page_end do
		if i == UO.ContPosY + UO.ContSizeY then
			page_end = true
			print("Number of Bods Priced")
			print(count)
		        print("Page Completed")
		        print("==============")
			break;
		elseif UO.ContSizeY == 454 and UO.ContSizeX == 615 then
		       local pix = UO.GetPix(UO.ContPosX+585,i)
		       if pix == 15707540 then
		          Click.Gump(585,i-UO.ContPosY)
		          waitGumpClose(615,454)
		          --setTime = getticks()
		          setPrice()
		          waitGumpOpen(615,454)
		          count = count + 1 
		          i = i + 20
                       else
                          i = i+1
                       end
                 else
                     --timeout value?
                 end
	end
	return count
end


function price()
        if bodbook == -1 then
           return
        end
        bodbook:use():waitContSize(531,454)
        s,e,num_deeds = string.find(bodbook.stats,"Deeds In Book: (%d+)")
        local count = 0
        while count < tonumber(num_deeds) do
       	      toAdd = pricePage()			
              count = count + toAdd
              Click.Gump(240, 425)
              wait(1000)
        end
        print("Total Bods Priced:")
        print(count)
end

function run()
	priceStr = priceE.ctrl.Text
	print(priceStr)
	priceInt = tonumber(priceStr)
	if bodbook == nil then
	   errorMsg("Please select a Bod Book")
	elseif priceStr == "" then
	   errorMsg("Please enter a Price")
	elseif priceInt == nil then 
	   errorMsg("Please enter a number for the price")
	elseif priceInt%1 ~= 0 then
	   errorMsg("Please enter an integer for the price")
	else
	    --Everything is okay run the pricing script
	    price() 
        end
end

---------------------------------------------------------
---------------------------GUI---------------------------
---------------------------------------------------------
bodPriceApp = menu:form(210,150,"Bod Pricer")

bodBookB = bodPriceApp:button("bodbook",40,10,120,20,"Set Bulk Order Book")

msgL = bodPriceApp:label("msg",40,40,60,20,"No Bulk Order Book Set")
priceL = bodPriceApp:label("price",40,70,60,20,"Bod Price: ")
priceE = bodPriceApp:edit("input",95,65,60,20,"")

priceB = bodPriceApp:button("run", 40,90,125,20,"Price Bulk Order Deeds")

bodBookB:onclick(function() setBodBook() end)
priceB:onclick(function() run() end)

bodPriceApp:show()
Obj.Loop()
bodPriceApp:free()