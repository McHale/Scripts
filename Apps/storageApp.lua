    -- Storage
    -- by McHale of Excelsior's Orphan Mafia Guild
    -- openEUO

dofile("../Lib/storagelib.lua")
dofile("../Lib/menulib.lua")
dofile("../Lib/config.lua")

 --creates a 400x200 window with title "My test menu"
storeApp = menu:form(200,250,"Storage")

spellB = storeApp:button("spell",50,10,100,20,"Spell Caster Items") 
metalB = storeApp:button("metal",50,35,100,20,"Ingots") 
woodB = storeApp:button("wood",50,60,100,20,"Wood Worker Items") 
gemsB = storeApp:button("gems",50,85,100,20,"Gems") 
tailorB = storeApp:button("tailor",50,110,100,20,"Tailoring Items") 
toolsB = storeApp:button("tools",50,135,100,20,"Tools") 
runicB = storeApp:button("runic",50,160,100,20,"Runic Tools") 
stoneB = storeApp:button("stone",50,185,100,20,"Stone") 

spellB:onclick(function() Storage.storeSpell() end)
metalB:onclick(function() Storage.storeMetal() end)
gemsB:onclick(function() Storage.storeGems() end)
tailorB:onclick(function() Storage.storeTailor() end)
toolsB:onclick(function() Storage.storeTools() end)
woodB:onclick(function() Storage.storeWood() end)
runicB:onclick(function() Storage.storeRunics() end)
stoneB:onclick(function() Storage.storeStone() end)

storeApp:show()
Obj.Loop()
storeApp:free()