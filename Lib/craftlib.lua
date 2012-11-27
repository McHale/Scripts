dofile("itemlib.lua")
dofile("functions.lua")
dofile("resourcelib.lua")

    Craft = {}

    local C = Craft

    local CategoryX = 30
    local CategoryY = {90,110,130,150,170,190,210,230,250,270,290,310}
    local ItemX = 230
    local ItemY = {70,90,110,130,150,170,190,210,230,250}
    local NextPageX = 380
    local NextPageY = 270
    local MakeLastX = 290
    local MakeLastY = 410
    local SelectMaterialX = 30
    local SelectMaterialY = 370
    local SelectMaterialNextPageX = 500
    local SelectMaterialNextPageY = 270
    local SmeltItemX = 30
    local SmeltItemY = 350
    local CraftGumpSizeX = 530
    local CraftGumpSizeY = 437

    C.LastItemType = nil
    C.CraftedID = {}
    C.ItemsInBackpack = {}

    C.Material = {
    Iron = 1,
    DullCopper = 2,
    ShadowIron = 3,
    Copper = 4,
    Bronze = 5,
    Gold = 6,
    Agapite = 7,
    Verite = 8,
    Valorite = 9,
    BlazeIngot = 10,
    Ice = 11,
    Toxic = 12,
    Electrum = 13,
    Platinum = 14,
    Board = 1,
    Pine = 2,
    Ash = 3,
    Mohogany = 4,
    Yew = 5,
    Oak = 6,
    Zircote = 7,
    Ebony = 8,
    Bamboo = 9,
    PurpleHeart = 10,
    Redwood = 11,
    Petrified = 12,
    Leather = 1,
    Spined = 2,
    Horned = 3,
    Barbed = 4,
    Polar = 5,
    Synthetic = 6,
    BlazeLeather = 7,
    Daemonic = 8,
    Shadow = 9,
    Frost = 10,
    Ethereal = 11
    }

    function C.MakeLast(a)
       if a == nil then
          a = 1
       end
       for i = 1,a do
          print("Makelast: " .. i .. "/" .. a)
          Click.Gump(MakeLastX,MakeLastY)
          pop:waitContSize(CraftGumpSizeX,CraftGumpSizeY)
       end
    end

    function C.SelectCategory(a)
       Click.Gump(CategoryX,CategoryY[a])
       pop:waitContSize(CraftGumpSizeX,CraftGumpSizeY)
    end

    function C.SelectItem(a)
       while a > 10 do
          Click.Gump(NextPageX,NextPageY)
          pop:waitContSize(CraftGumpSizeX,CraftGumpSizeY)
          a = a - 10
       end
       Click.Gump(ItemX,ItemY[a])
       pop:waitContSize(CraftGumpSizeX,CraftGumpSizeY)
    end

    function C.SelectMaterial(a)
       Click.Gump(SelectMaterialX,SelectMaterialY)
       pop:waitContSize(CraftGumpSizeX,CraftGumpSizeY)
       if a > 10 then
          Click.Gump(SelectMaterialNextPageX,SelectMaterialNextPageY)
          pop:waitContSize(CraftGumpSizeX,CraftGumpSizeY)
          a = a - 10
       end
       Click.Gump(ItemX,ItemY[a])
       pop:waitContSize(CraftGumpSizeX,CraftGumpSizeY)
    end

    function C.OpenTool(sProf)
       if sProf == "smith"     then toolType = Type.SMITHSHAMMER end
       if sProf == "tailor"    then toolType = Type.SEWINGKIT end
       if sProf == "bowyer"    then toolType = Type.ARROWFLETCHING end
       if sProf == "carpenter" then toolType = Type.SAW end
       if sProf == "tinker"    then toolType = Type.TOOLKIT end
       if sProf == "scribe"    then toolType = Type.SCRIBESPEN end
       if sProf == "alchemist" then toolType = Type.MORTARANDPESTLE end
	   local a = {}
	   local a = item:scan():cont(UO.BackpackID):tp(toolType)
       if #a >0  then
	--UO.BackpackID  ? 1094105666
          UO.LObjectID = a[1].id
          UO.Macro(17,0)
          pop:waitContSize(CraftGumpSizeX,CraftGumpSizeY)
          return true
       end

       return false
    end

    function C.Smelt(itemID)
       Click.Gump(SmeltItemX,SmeltItemY)
       pop:waitTarget(5000)
       UO.LTargetID = itemID
       UO.LTargetKind = 1
       UO.Macro(22,0)
       pop:waitContSize(CraftGumpSizeX,CraftGumpSizeY)
    end

    function C.Cut(itemID)
       UO.LObjectID = cutToolID
       UO.Macro(17,0)
       pop:waitTarget(5000)
       UO.LTargetID = itemID
       UO.LTargetKind = 1
       UO.Macro(22,0)
       wait(500)
    end

    function C.DestroyItem(sProf,itemID)
       if sProf == "smith" then C.Smelt(itemID) end
       if sProf == "tailor" then C.Cut(itemID) end
       if sProf == "bowyer" then C.Smelt(itemID) end
       if sProf == "carpenter" then C.Smelt(itemID) end
    end

    function C.Make(sProf,nCat,nItem,nMat,nAmnt)
       if C.OpenTool(sProf) then
          C.ItemsInBackpack = {}
          C.CraftedID = {}
		  local a = {}
		  local a = item:scan():cont(UO.BackpackID)
          if #a >0  then
             for i=1,#a do
                table.insert(C.ItemsInBackpack,a.id[i])
             end
          end
          backpackString = table.concat(C.ItemsInBackpack,"_")
          if nMat and sProf ~= "scribe" and sProf ~= "alchemist" then
             C.SelectMaterial(nMat)
          end
          C.SelectCategory(nCat)
          C.SelectItem(nItem)
          -- Set LastItemType
		  local a = item:scan():cont(UO.BackpackID)
          if #a >0 then
             backpackString = table.concat(C.ItemsInBackpack,"_")
             for i = 1,#a do
                IDstr = ""..a.id[i]
                if not string.find(backpackString,IDstr) then
                   C.LastItemType = a.tp[i]
                   break
                end
             end
          end
          C.MakeLast(nAmnt-1)
		  local a = item:scan():cont(UO.BackpackID):tp(C.LastItemType)
          for i=1,#a do
             if not string.match(backpackString,""..a.id[i]) then
                table.insert(C.CraftedID,a.id[i])
             end
          end
          Click.CloseGump()
          UO.SysMessage("Craft done!")
       end
       return true
    end

    function C.MakeExc(sProf,nCat,nItem,nMat,nAmnt)
	   local a = {}
       C.ItemsInBackpack = {} -- Saving the IDs of the items in Backpack, so they won't be destroyed
       if sProf == "tinker" or sProf == "scribe" or sProf == "alchemist" then
          C.Make(sProf,nCat,nItem,nMat,nAmnt)
          return
       end
       if sProf == "tailor" then
		  local a = item:scan():cont(UO.BackpackID):tp(Type.SCISSORS)
          cutToolID = a.id[1]
       end
	   local a = item:scan():cont(UO.BackpackID)
       if #a>0  then
          for i=1,#a do
             table.insert(C.ItemsInBackpack,a.id[i])
          end
       end
       -- Make one item
       if C.OpenTool(sProf) then
          C.SelectMaterial(nMat)
          C.SelectCategory(nCat)
          C.SelectItem(nItem)
       end
       -- Get the item type
		local a = item:scan():cont(UO.BackpackID)
       if #a >0  then
          backpackString = table.concat(C.ItemsInBackpack,"_")
          for i = 1,#a do
             IDstr = ""..a.id[i]
             if not string.find(backpackString,IDstr) then
                 C.LastItemType = a.tp[i]
                 break
             end
          end
       end
       if UO.ContSizeX ~= CraftGumpSizeX then
          print("reopened!")
          C.OpenTool(sProf)
       end
       C.MakeLast(nAmnt-1)
       print("nAmnt: "..nAmnt)
       notDone = true
       print("Looking for non-exceptionals")
       while notDone do
			local a = item:scan():cont(UO.BackpackID):tp(C.LastItemType)
          for i=1,#a do
             if not string.match(backpackString,""..a.id[i]) then
                name,stats = UO.Property(a.id[i])
                wait(100)
                if stats == "" then
                   wait(1000)
                   print("Failed to get property, trying again..")
                   name,stats = UO.Property(a.id[i])
                end
                if not string.match(name,"Exceptional") and not string.match(stats,"Exceptional") then
                   print("Non-exc found, printing properties: ",name,stats)
                   C.DestroyItem(sProf,a.id[i])
                end
             end
          end
          print("Smelting/cutting done, counting items")
          -- Count Items
          local a = item:scan():cont(UO.BackpackID):tp(C.LastItemType)
          print("Total amount found:",#a)
          checkAmnt = 0
          C.CraftedID = {}
          for i=1,#a do
             if not string.match(backpackString,""..a.id[i]) then
                checkAmnt = checkAmnt + 1
                table.insert(C.CraftedID,a.id[i])
             end
          end
          print("Amount of items found for BOD:",checkAmnt)
          amntToMake = nAmnt - checkAmnt
          print("Amount to make:",amntToMake)
          if amntToMake == 0 then
             notDone = false
          else
             C.MakeLast(amntToMake)
          end
       end
       print("C.CraftedID length: " .. # C.CraftedID)
       print("Crafting done")
       Click.CloseGump()
       UO.SysMessage("Craft done!")
    end
