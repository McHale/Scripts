dofile("../Lib/itemlib.lua")
dofile("../Lib/menulib.lua")

current = {
--Crimson Cincture
1084527426,
--Royal Hive Robe,
1152168752,
--Kilt
1105066088,
--goc tunic
1075760345,
--shirt
1145859552,
--legs
1080113164,
--batwings
1105732749,
--gloves
1076823635,
--head
1080571469,
--arms
1182939673,
--jackel's
1108192318,
--earrings
1084720119,
--bracelet
1094380044,
--ring
1092332863}


dressApp = menu:form(200,100,"Dress Helper")


currentB = dressApp:button("current",50,10,100,20,"Current") 
--honeyB = dressApp:button("honey",50,35,100,20,"Collect Honey") 
--waxB = beeApp:button("wax",50,60,100,20,"Collect Wax")

currentB:onclick(function() 
for i=1,#current do
UO.Drag(current[i])
wait(150)
UO.DropPD()
wait(1250)
end
end)

dressApp:show()
Obj.Loop()
dressApp:free()