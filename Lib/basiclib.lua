     -- Version 1.1
    -- Basic Library for functions:

    -- Finditem.Ground(arg1, arg2)
    -- ** arg1 = item type or ID, or a table containing item types and IDs
    -- ** arg2 = search range
    -- -- returns true if items found, false if not

    -- Finditem.Cont(arg1,arg2)
    -- ** arg1 = item type or ID, or a table containing item types and IDs
    -- ** arg2 = ID of the container that we are searching from
    -- -- returns true if items found, false if not

    -- FindItem.All(arg1)
    -- ** arg1 = item type or ID, or a table containing item types and IDs
    -- -- returns true if items found, false if not
    --
    -- These store results in:
    --   FindItem.ID
    --   FindItem.Type
    --   FindItem.Kind 
    --   FindItem.ContID 
    --   FindItem.X 
    --   FindItem.Y 
    --   FindItem.Z
    --   FindItem.Stack 
    --   FindItem.Rep 
    --   FindItem.Col
    --   FindItem.N <- number of found items

    -- e.g. the ID of 'n'th item found can be accessed by FindItem.ID[n] 

    -- Click.Left(x,y)   -- Left click at x,y
    -- Click.Right(x,y)  -- Right click at x,y
    -- Click.Gump(x,y)   -- Clicks at x,y with respect to top-most gump
    -- Click.CloseGump() -- Closes top-most gump, should work fine

    -- Journal.Latest()  -- returns the last line in journal

    -- WaitForGump(x,y)  -- waits for gump, size x y
    -- WaitForTarget()   -- waits for target cursor

    -- FindItem:

    FindItem =  {}
    local F = FindItem

    local function AddFindItem(nID,nType,nKind, nContID, nX, nY, nZ, nStack, nRep, nCol)
       table.insert(F.ID,nID)
       table.insert(F.Type,nType)
       table.insert(F.Kind,nKind)
       table.insert(F.ContID,nContID)
       table.insert(F.X,nX)
       table.insert(F.Y,nY)
       table.insert(F.Z,nZ)
       table.insert(F.Stack,nStack)
       table.insert(F.Rep,nRep)
       table.insert(F.Col,nCol)
    end
    local function ClearFindItem()
       F.ID = {}
       F.Type = {}
       F.Kind = {}
       F.ContID = {}
       F.X = {}
       F.Y = {}
       F.Z = {}
       F.Stack = {}
       F.Rep = {}
       F.Col = {}
       F.N = 0
    end

    function F.Ground(typeOrID,range)
       ClearFindItem()
       n = 0
       if type(typeOrID) ~= "table" then
          typeOrID = {typeOrID}
       end
       typeOrID = table.concat(typeOrID,"_")
       for nIndex=1,UO.ScanItems(true) do
          nID,nType,nKind, nContID, nX, nY, nZ, nStack, nRep, nCol = UO.GetItem(nIndex)
          if ((( string.find(typeOrID,""..nID) or string.find(typeOrID,""..nType) ) or typeOrID == "all" )and nContID == 0 ) then
             dist = math.max(math.abs(UO.CharPosX - nX),math.abs(UO.CharPosY - nY))
             if dist <= range then
                AddFindItem(nID,nType,nKind, nContID, nX, nY, nZ, nStack, nRep, nCol)
                n = n + 1
             end
          end   
       end
       F.N = n
       if n > 0 then
          return true
       end
       return false
    end

    function F.Cont(typeOrID,cont)
       ClearFindItem()
       n = 0
       
       if type(typeOrID) ~= "table" then
          typeOrID = {typeOrID}
       end
       typeOrID = table.concat(typeOrID,"_")
       for nIndex=1,UO.ScanItems(true) do
          nID,nType,nKind, nContID, nX, nY, nZ, nStack, nRep, nCol = UO.GetItem(nIndex)
          if ((( string.find(typeOrID,""..nID) or string.find(typeOrID,""..nType) )or typeOrID == "all") and nContID == cont) then
             AddFindItem(nID,nType,nKind, nContID, nX, nY, nZ, nStack, nRep, nCol)
             n = n + 1
          end   
       end
       F.N = n
       if n > 0 then
          return true
       end
       return false
    end

    function F.All(typeOrID)
       ClearFindItem()
       n = 0
       if type(typeOrID) ~= "table" then
          typeOrID = {typeOrID}
       end
       typeOrID = table.concat(typeOrID,"_")
       for nIndex=1,UO.ScanItems(false) do
          nID,nType,nKind, nContID, nX, nY, nZ, nStack, nRep, nCol = UO.GetItem(nIndex)
          if ( string.find(typeOrID,""..nID) or string.find(typeOrID,""..nType) ) or typeOrID == "all" then
             AddFindItem(nID,nType,nKind, nContID, nX, nY, nZ, nStack, nRep, nCol)
             n = n + 1
          end   
       end
       F.N = n
       if n > 0 then
          return true
       end
       return false
    end

    -- Click:
    Click = {}
    local C = Click

    function C.Left(x,y)
       UO.Click(x,y,true,true,true,false)
    end

    function C.Right(x,y)
       UO.Click(x,y,false,true,true,false)
    end

    function C.Gump(x,y)
       C.Left(UO.ContPosX+x,UO.ContPosY+y)
    end
    function C.CloseGump()
       C.Right(UO.ContPosX+UO.ContSizeX/2,UO.ContPosY+UO.ContSizeY/2)
    end

    -- Journal
    Journal = {}
    local J = Journal

    function J.Latest()
       UO.ScanJournal(0)
       s,n = UO.GetJournal(0)
       return s
    end

    -- WaitFor

    function WaitForGump(x,y)
       timeout = 1000
       start = getticks()
       while not (UO.ContSizeX==x and UO.ContSizeY==y and current < timeout) do
          wait(5)
	  current = getticks() - start
	  print(current)
       end
    end

    function WaitForTarget()
       while not UO.TargCurs do wait(1) end
    end

    -- Item types:
    Type = {
    RUNEBOOK = 8901,
    CRAFTERKEYS = 5995,
    SMITHSHAMMER = 5092,
    FORGE = 4017,
    ANVIL = 4015,
    SKILLET = 2431,
    BRUSH = 4979,
    ENGRAVER = 4031,
    PROSPECTORSTOOL = 4020,
    TOOLKIT = 7864,
    ARROWFLETCHING = 4130,
    SAW = 4148,
    MALLETANDCHISEL = 4787,
    SCRIBESPEN = 4031,
    SEWINGKIT = 3997,
    MORTARANDPESTLE = 3739,
    BOOKOFCHIVALRY = 8786,
    ORE = 6585,
    INGOT = 7154,
    GEMPOUCH = 3705,
    KEG = 6464,
    CUTLEATHER = 4225,
    NECROMANCERSPELLBOOK = 8787,
    SHOVEL = 3897,
    BOOKOFNINJITSU = 9120,
    RECALLRUNE = 7956,
    LOCKPICK = 5372,
    ARROW = 3903,
    BANKSTONE = 3796,
    BEEHIVE = 2330,
    BOLT = 7163,
    FERTILEDIRT = 3969,
    MOBILEFORGE = 3634,
    SCISSORS = 3999,
    FISHINGPOLE = 3520,
    SPELLBOOK = 3834,
    BOD = 8792
    }
