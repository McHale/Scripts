-- item library

-- SPECIAL FUNCTIONS:
---------------------
--item:scan(b)     scans for items, using this too much can cause lag
--item:property()  uses UO.Property on each item, can be slowish if hundreds of items to scan
--item:getIDs()    returns a list of ids {id1, id2, id3.. } of the items in the list

-- FILTERS: (accept both single parameters (453) or tables of parameters ({123,345,456}) )
-----------
-- item:col(nCol)      filters by color
-- item:cont(nContID)  filters by container id
-- item:ground(range)  filters by range (on ground)
-- item:id(nID)        filters by id
-- item:kind(nKind)    filters by kind
-- item:name(sName)    filters by name (must use :property() before this)
-- item:rep(nRep)      filters by reputation
-- item:tp(nType)      filters by type

-- "POPPERS" (return one item from the list)
--------------------------------------------
-- item:nearest()      returns the nearest item (on ground) --NOTE: not sure if it works properly
-- item:pop(i)         returns the item at index i, i=1 by default

-- ACTIONS (used after a "popper")
----------------------------------
-- pop:drop(contID,bNoWait)      drops the in container contID, by default waits for 500 ms after dropping. bNowait is optional parameter, if bNoWait is true, doesn't wait after drop
-- pop:open(timeout)             for opening containers, d clicks the item and waits for container with corresponding id. Timeout is optional parameter, 2000 ms default.
-- pop:say(msg)                  uses UO.Macro(1,0,msg)
-- pop:use()                     uses UO.Macro(17,0), doesn't change UO.LObjectID
-- pop:target(id)                if target cursor enabled, targets item id. id optional parameter, by default the item's own id
-- pop:wait(t)                   waits for t (ms)
-- pop:waitContSize(x,y,timeout) waits for container of size x-y. timeout optional, by default 2000 ms
-- pop:waitContType(tp,timeout)  waits for container of type tp. timeout optional, by default 2000 ms
-- pop:waitSysMsg(msg,timeout)   waits for system message containing string msg. timeout optional, by default 2000 ms
-- pop:waitTarget(timeout)       waits for target cursor. timeout optional, by default 2000 ms


item = {}
item_meta = {__index = item}
pop = {}
pop_meta = {__index = pop}

-- functions that alter the item list by scanning/filtering
-- return a new list


-- param b: true/false for whether to scan visible items only, false by default
function item:scan(b)
    b = b or false
    
    local cnt = UO.ScanItems(b)
    local a = {}
    
    for i = 1,cnt do 
        local nID,nType,nKind,nContID,nX,nY,nZ,nStack,nRep,nCol = UO.GetItem(i-1)
        a[i] = {id = nID, tp = nType, kind = nKind, cont = nContID, x = nX, y = nY, z = nZ, stack = nStack, rep = nRep, col = nCol, name = "", stats = ""}
    end
    setmetatable(a,item_meta)
    return a
end

-- Does a property check on all the items. Sets the .name and .stats fields
function item:property()
    for i = 1,#self do
        n,s = UO.Property(self[i].id)
        self[i].name = n
        self[i].stats = s
    end
    return self
end

-- returns a list ids of all the items
function item:getIDs()
    local a = {}
    
    for i = 1,#self do
        table.insert(a,self[i].id)
    end
    
    return a
end

-- param nCol: color of the item (int)
function item:col(nCol)
    local a = {}
    
    if type(nCol) ~= "table" then
        nCol = {nCol}
    end
    
    for i = 1,#self do
        for j = 1,#nCol do
            if self[i].col == nCol[j] then
                table.insert(a,self[i])
            end
        end
    end
    
    setmetatable(a,item_meta)
    return a
end

-- param nContID: id of the parent container (int)
function item:cont(nContID)
    local a = {}
    
    if type(nContID) ~= "table" then
        nContID = {nContID}
    end
    
    for i = 1,#self do
        for j = 1,#nContID do
            if self[i].cont == nContID[j] then
                table.insert(a,self[i])
            end
        end
    end
    
    setmetatable(a,item_meta)
    return a
end

-- param range: search range in tiles
function item:ground(range)
    local a = {}
    local x = UO.CharPosX
    local y = UO.CharPosY
    
    for i = 1,#self do
        if self[i].cont == 0 then
            dist = math.max( math.abs(x-self[i].x) , math.abs(y-self[i].y) )
            if dist <= range then
                table.insert(a,self[i])
            end
        end
    end
    
    setmetatable(a,item_meta)
    return a
end

-- param z_start, z_end: z_start from you position on z-axis
-- negative goes below you, positive above you.
function item:z_axis(z_start,z_end)
    local a = {}
    local z = UO.CharPosZ
    
    for i = 1,#self do
        if self[i].cont == 0 then
	    local difference = self[i].z - z
            if difference >= z_start and difference <= z_end then
                table.insert(a,self[i])
            end
        end
    end
    
    setmetatable(a,item_meta)
    return a
end

-- param id: item id to look for
function item:id(nID)
    local a = {}
    
    if type(nID) ~= "table" then
        nID = {nID}
    end
    
    for i = 1,#self do
        for j = 1,#nID do
            if self[i].id == nID[j] then
                table.insert(a,self[i])
            end
        end
    end
    
    setmetatable(a,item_meta)
    return a
end

-- param nKind: item kind to look for
function item:kind(nKind)
    local a = {}
    
    if type(nKind) ~= "table" then
        nKind = {nKind}
    end
    
    for i = 1,#self do
        for j = 1,#nKind do
            if self[i].kind == nKind[j] then
                table.insert(a,self[i])
            end
        end
    end
    
    setmetatable(a,item_meta)
    return a
end

-- looks for items with name sName, note: must use :property() before this
function item:name(sName)
    local a = {}
    
    if type(sName) ~= "table" then
        sName = {sName}
    end
    
    for i = 1,#self do
        for j = 1,#sName do
            if self[i].name:match(sName[j]) then
                table.insert(a,self[i])
            end
        end
    end
    
    setmetatable(a,item_meta)
    return a
end

-- param nRep: item reputation to look for
function item:rep(nRep)
    local a = {}
    
    if type(nRep) ~= "table" then
        nRep = {nRep}
    end
    
    for i = 1,#self do
        for j = 1,#nRep do
            if self[i].rep == nRep[j] then
                table.insert(a,self[i])
            end
        end
    end
    
    setmetatable(a,item_meta)
    return a
end

-- param nType: item type to look for
function item:tp(nType)
    local a = {}
    
    if type(nType) ~= "table" then
        nType = {nType}
    end
    
    for i = 1,#self do
        for j = 1,#nType do
            if self[i].tp == nType[j] then
                table.insert(a,self[i])
            end
        end
    end
    
    setmetatable(a,item_meta)
    return a
end

-- functions that return one item from the list
function item:nearest()
    local index = 0
    local min_dist = 10000
    local x = UO.CharPosX
    local y = UO.CharPosY
    
    for i = 1,#self do
        dist = math.max( math.abs(x-self[i].x) , math.abs(y-self[i].y) )
        if dist < min_dist then
            index = i
            min_dist = dist
        end
    end
    
    local a = self[index]
    setmetatable(a,pop_meta)
    return a
end

function item:pop(i)
    i = i or 1
    local a = self[i]
    setmetatable(a,pop_meta)
    return a
end

-- functions to use after pop
function pop:drop(contID,bNoWait)
    UO.Drag(self.id,self.stack)
    UO.DropC(contID)
    if not bNoWait then wait(500) end
    return self
end

function pop:open(timeout)
    timeout = timeout or 2000
    local loid = UO.LObjectID
    
    UO.LObjectID = self.id
    UO.Macro(17,0)
    
    -- wait for cont
    local start = getticks()
    local passed = 0
    while UO.ContID ~= self.id do
        passed = getticks() - start
        if passed > timeout then break end
    end
    
    UO.LObjectID = loid
    return self
end

function pop:say(msg)
    UO.Macro(1,0,msg)
    return self
end

function pop:use()
    local loid = UO.LObjectID
    
    UO.LObjectID = self.id
    UO.Macro(17,0)
    
    UO.LObjectID = loid
    return self
end

function pop:target(id)
    id = id or self.id -- target self.id as default
    
    local ltid = UO.LTargetID
    local ltkind = UO.LTargetKind
    
    UO.LTargetID = id
    UO.LTargetKind = 1
    
    UO.Macro(22,0)
    
    UO.LTargetID = ltid
    UO.LTargetKind = ltkind
    return self
end

function pop:wait(t)
    local start = getticks()
    while ( getticks() - start ) < t do wait(1) end
    return self
end

function pop:waitContSize(x,y,timeout)
    timeout = timeout or 2000
    local start = getticks()
    local passed = 0
    
    while UO.ContSizeX ~= x and UO.ContSizeY ~= y do
        passed = getticks() - start
        if passed > timeout then break end
    end
    
    return self
end

function pop:waitContType(tp,timeout)
    timeout = timeout or 2000
    local start = getticks()
    local passed = 0
    
    while UO.ContType ~= tp do
        passed = getticks() - start
        if passed > timeout then break end
    end
    
    return self
end

function pop:waitSysMsg(msg,timeout)
    timeout = timeout or 2000
    local start = getticks()
    local passed = 0
    
    while UO.SysMsg ~= msg do
        passed = getticks() - start
        if passed > timeout then break end
    end
    
    return self
end

function pop:waitTarget(timeout)
    timeout = timeout or 2000
    local start = getticks()
    local passed = 0
    
    while not UO.TargCurs do
        passed = getticks() - start
        if passed > timeout then break end
    end
    
    return self
end