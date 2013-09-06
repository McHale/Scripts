local cutex=false
local trashex=false
local smith=false
local loottype={}
local loot={{str="Mana Regen",int=2},
						{str="Damage Increase",int=15},
						{str="Strength",int=7},
						{str="Dexterity",int=7},
						{str="Mana Cost",int=15},
						{str="Reagent Cost",int=15},
						{str="Hit Chance",int=15},
						{str="Defence Chance",int=15},
						{str="Total Resist",int=40},
						{str="Area Damage",int=40},
						{str="Leech",int=40},
						{str="Harm",int=40},
						{str="Fireball",int=40},
						{str="Lightning",int=40},
						{str="Lower Attack",int=40},
						{str="Lower Defense",int=40},
						{str="Swing Speed",int=15}}
local setup={3705,3999,5995,8900}
local tool={2431,3718,3722,3739,3897,3907,3909,3911,3913,3915,3917,3997, 
                  4020,4027,4031,4130,4136,4138,4148,4158,4325,4326,4327,4787,
                  4979,5040,5091,5092,5115,5182,5187,7864}
local wood={7121,7124,7127,7133,7163,3903}
local tailor={3613,3576,4225,5990,5991,9908}
local metal={7154}
local rock={6009}
local magic={2426,3827,3960,3962,3963,3965,3966,3968,3969,3972,
                     3973,3974,3976,3978,3980,3981,3982,3983,4586,7956}
local gem={3873,3877,3878,3885,3859,3861,3862,3865,3856,7847,
                  12690,12691,12692,12693,12694,12695,12696,12697}
local gump={{sx=505, sy=325, ox=290, oy=285},
                     {sx=505, sy=270, ox=290, oy=235},
                     {sx=505, sy=475, ox=290, oy=435},
                     {sx=505, sy=270, ox=290, oy=235},
                     {sx=505, sy=440, ox=290, oy=410},
                     {sx=505, sy=295, ox=290, oy=260},
                     {sx=505, sy=365, ox=290, oy=335},
                     {sx=725, sy=370, ox=560, oy=320},
                     {sx=530, sy=437, ox=30, oy=350}}
local text={"Gem Pouch", "Metal Worker's Keys", "Spell Caster's Keys", 
                  "Stone Worker's Keys", "Tailor's Keys", 
                  "Wood Worker's Keys", "Tool House","Runic House"}
local maglist={{tp=3615,str="Destroying Angel"},
                        {tp=3620,str="Spring Water"},
                        {tp=3854,str="Empty"},
                        {tp=5995,str="Key Ring"},
                        {tp=6464,str="Keg"},
                        {tp=9911,str="Zoogi Fungus"}}
local tralist={{tp=5360,str="Dartboard"},
                     {tp=5356,str="Indecipherable Map"},
                     {tp=5356,str="City Map"},
                     {tp=5356,str="World Map"}}
local bypass={{tp=5110,str="Gargoyle"}}
local filter={{tp=3641,str="Eleven Note"}}
local trash={2504,2600,3307,3309,3310,3311,3312,3313,3314,3535,3568,3570,3571,3572,3573,
             3647,3719,3721,3779,3780,3847,3848,3849,3850,3851,3852,3853,3920,3971,4039,4179,5042,5044,
             5112,5117,5147,5198,5199,5200,5201,5202,5365,5451,6217,6218,
             7033,7034,7583,7584,7585,7587,7588,7848,7947,7964,7981,7982,7983,7984,7985,7986,7987,7988,7989,
             7990,7991,7992,7993,7994,7995,7996,7997,7998,7999,
             8000,8001,8002,8003,8004,8005,8006,8007,8008,8009,
             8010,8011,8013,8014,8015,8016,8017,8018,8019,
             8020,8021,8022,8023,8024,8025,8026,8027,8028,8029,
             8030,8031,8033,8034,8035,8036,8037,8038,8039,
             8040,8041,8042,8043,8044,
             8800,8801,8804,8805,8806,8807,8808,8809,8810,8811,8812,8813,8814,8815,8816,9922,9923,
             10150,10152,10158,10291}    
local smelt={3932,3934,3937,3938,5040,5046,5049,5051,5054,5055,5099,
                     5100,5102,5104,5119,5121,5123,5125,5127,5128,
                     5130,5132,5134,5136,5137,5138,5139,
                     5140,5141,5177,5179,5181,5185,
                     7026,7027,7028,7030,7035,7107,7172,
                     9914,9915,9916,9917,9918,9919,9920,9921,9797,
                     10112,10113,10146,10148,10151,10153,10155,10157,10159,
                     11119}  
local cut={3989,4217,5062,5063,5067,5068,5069,5077,5078,5082,5083,5084,
                  5397,5398,5399,5422,5431,5433,5437,5440,5444,5899,           
                  5901,5903,5905,5907,5908,5909,5910,5912,5913,5914,5915,
                  7168,7170,7174,7176,7178,7180,7609,7933,7937,7939,
                  8059,8097,8189,8970,8972,
                  10102,10110,10114,10122,10126,10127,10129,
                  10130,10131,10132,10134,10135,10136,10145,10182,10183,
                  11124,11125,11127,11128}
local toolc,woodc,magicc,tailorc,metalc,rockc,gemc=0,0,0,0,0,0,0
local trashc,bypassc,maglistc,tralistc,cutc,smeltc=0,0,0,0,0,0
local tbag,key={},{}
local g,m,s,ta,w,sp,tl,r={},{},{},{},{},{},{},{}
local sci,smi,begin=false,false,true
local next=next
local targ,targk,lobj=UO.LTargetID,UO.LTargetKind,UO.LObjectID
             
function init()
local result={}
   for i=0, UO.ScanItems(false)-1,1 do
      local nid,typ,_,contid,_,_,_,stck=UO.GetItem(i)
      if contid==UO.BackpackID then
			local bol=true
         if begin then 
            for t,tt in pairs(setup) do
               if typ==tt then 
                  local nma=UO.Property(nid)
                  for m,mm in pairs(text) do
                     if string.match(nma,mm) then
                        print(m.." "..nid) 
                        key[m]=nid
                        bol=false break
                     end
                  end
						break
               end
               --if not bol then break end
            end
            if bol and typ==2482 then
               local nma=UO.Property(nid)
               if string.match(nma,"Trash") then print("Trashbag found.")
                  table.insert(tbag,nid) 
                  bol=false 
               end
            elseif bol and not sci and typ==3999 then sci=nid bol=false 
            elseif bol and not smi and typ==5092 and smith then smi=nid
            end 
         end
			if bol then table.insert(result,{id=nid,tp=typ,stack=stck}) end
     end
   end
   return result
end

function store(tbl)
print(#tbl)
for i,ii in pairs(tbl) do
	local bol=true
	for t,tt in pairs(tool) do
      if ii.tp==tt then 
			if t<=toolc then print("TL: "..tt)
				table.insert(tl, ii.id)
			elseif t<=woodc then print("W: "..tt)
				table.insert(w, ii.id)
			elseif t<=magicc then print("SP "..tt)
				table.insert(sp, ii.id)
			elseif t<=rockc then print("R "..tt)
				table.insert(s, ii.id)
			elseif t<=metalc then print("M "..tt)
				table.insert(m, ii.id)
			elseif t<=gemc then print("G "..tt)
				table.insert(g, ii.id) bol=false
			elseif t<=tailorc then print("T "..tt)
				table.insert(ta, ii.id)
			end
			bol=false
			break
		end
	end
	if bol then
		for t,tt in pairs(bypass) do
			if ii.tp==tt.tp then
				local nma=UO.Property(ii.id)
				if string.match(string.lower(nma),string.lower(tt.str)) then
					if t<=bypassc then print("TL: "..tt.str)
						table.insert(tl, ii.id)
					else print("SP "..tt)
						table.insert(sp, ii.id) 
					end
				end
				break
			end
		end
	end
--[[ for t,tt in pairs(tool) do
         if ii.tp==tt then
            local nma,inf=UO.Property(ii.id)
            if string.match(nma,"Runic") then print("R:"..tt) 
               table.insert(r, ii.id)
            else print("TL:"..tt) 
               table.insert(tl, ii.id)
            end
            break ]]--
end
if next(g) and key[1]~=nil then storit(1,g) end
if next(m) and key[2]~=nil then storit(2,m) end
if next(sp) and key[3]~=nil then storit(3,sp) end
if next(s) and key[4]~=nil then storit(4,s) end
if next(ta) and key[5]~=nil then storit(5,ta) end
if next(w) and key[6]~=nil then storit(6,w) end
if next(tl) and key[7]~=nil then storit(7,tl) end
if next(r) and key[8]~=nil then storit(8,r) end
if UO.TargCurs then UO.Key("ESC") end
end

function recycle(tbl)
local c,tr,sm={},{},{}
local result=false
for i,ii in pairs(tbl) do
	local bol=true
	for t,tt in pairs(trash) do
      if ii.tp==tt then 
			if t<=trashc then print("TR: "..tt)
				table.insert(tr, {id=ii.id,stck=ii.stack})
			elseif smith and t<=smeltc then print("SM: "..tt)
				table.insert(sm, ii.id)
			elseif t>trashc and t<=cutc then print("CUT "..tt)
				table.insert(c, ii.id)
			end
			bol=false
			break
		end
	end
	if bol then
		for t,tt in pairs(tralist) do
			if ii.tp==tt.tp then 
				local nma=UO.Property(ii.id)
				if string.match(string.lower(nma),string.lower(tt.str)) then
					table.insert(tr, {id=ii.id,stck=ii.stack})
				end
				bol=false
				break
			end
		end  
	end
	if bol and ii.tp==3641 then
		local nma=UO.Property(ii.id)
		if string.match(string.lower(nma),string.lower("Eleven Note")) then
		else print(nma)
			table.insert(tr, {id=ii.id,stck=ii.stack})
		end
	end
end
if next(c) and sci then cutit(c) result=true end
if next(sm) then smeltit(sm) result=true end
if next(tr) then trashit(tr) end
return result
end

function smeltit(tbl)
while true do
UO.LObjectID=smi
wait(200)
UO.Macro(17,0)
wait(200)
if UO.ContSizeX==gump[8].sx and UO.ContSizeY==gump[8].sy then break end
end
for i,ii in pairs(tbl) do
UO.LTargetKind=1
UO.LTargetID=ii
while UO.ContSizeX~=gump[8].sx or UO.ContSizeY~=gump[8].sy do end  
        UO.Click(UO.ContPosX+gump[8].ox, UO.ContPosY+gump[8].oy, true, true,true, false)
        while not UO.TargCurs do end
        while UO.TargCurs do UO.Macro(22,0) end
end
wait(960)
if UO.ContSizeX==gump[8].sx and UO.ContSizeY==gump[8].sy then
    UO.Click(UO.ContPosX+UO.ContSizeX/2,UO.ContPosY+UO.ContSizeY/2, false, true, true, false)
end
return
end

function storit(int, tbl)
local bol=false
local timer=0
UO.LTargetKind=1
UO.LObjectID=key[int]
while true do
   UO.Macro(17,0)
   timer=getticks()+500
   while timer>getticks() do
      if UO.ContSizeX==gump[int].sx and UO.ContSizeY==gump[int].sy then 
      bol=true break 
      end
   end
   if bol then break end
end
UO.Click(UO.ContPosX+gump[int].ox, UO.ContPosY+gump[int].oy, true, true, true, false)
for i,ii in pairs(tbl) do
    UO.LTargetID=ii
    while true do
      if UO.TargCurs then UO.Macro(22,0) break end
    end
end
timer=getticks()+900
while timer>getticks() do end
if UO.ContSizeX==gump[int].sx and UO.ContSizeY==gump[int].sy then
   UO.Click(UO.ContPosX+UO.ContSizeX/2,UO.ContPosY+UO.ContSizeY/2, false, true, true, false)
end
return
end

function trashit(tbl)
local timer=0
for i,ii in pairs(tbl) do
	local bol=true
	while bol do
		UO.Drag(ii.id,ii.stck)
		UO.DropC(tbag[1+(i%(#tbag))])
		timer=getticks()+1000
		while timer>getticks() do
			if string.match(UO.SysMsg, "You have trashed") then bol=false break end
		end
	end
	timer=getticks()+500   
	while timer>getticks() do end
end
if trashex then stop() end
return
end

function cutit(tbl)
local timer=0
UO.LObjectID=sci
   for i, ii in pairs(tbl) do
      UO.LTargetKind=1
      UO.LTargetID=ii
      local bol=false
      while true do
         UO.Macro(17,0) 
         timer=getticks()+500
         while timer>getticks() do
            if UO.TargCurs then bol=true break end
         end
         if bol then break end
      end
   UO.Macro(22,0)
   end
if cutex then stop()  end
return
end

function manager(tbl)

toolc=#tool
--woodc,magicc,rockc,metalc,gemc=,#wood,#magic,#rock,#gem
--local maglistc,bypassc,tralistc=#maglist,#bypass,#tralist
for i,ii in pairs(wood) do table.insert(tool,ii) end
woodc=toolc+#wood
for i,ii in pairs(magic) do table.insert(tool,ii) end
magicc=woodc+#magic
for i,ii in pairs(rock) do table.insert(tool,ii) end
rockc=magicc+#rock
for i,ii in pairs(metal)do table.insert(tool,ii) end
metalc=rockc+#metal
for i,ii in pairs(gem) do table.insert(tool,ii) end
gemc=metalc+#gem
for i,ii in pairs(tailor) do table.insert(tool,ii) end
tailorc=gemc+#tailor

trashc=#trash
for i,ii in pairs(smelt) do table.insert(trash,ii) end
if smith then local smeltc=trashc+#smelt
else trashc=trashc+#smelt
end
for i,ii in pairs(cut) do table.insert(trash,ii) end
if smith then cutc=smeltc+#cut
else cutc=trashc+#cut
end

bypassc=#bypass
for i,ii in pairs(maglist) do table.insert(bypass,{ii.tp,ii.str}) end
maglistc=bypassc+#maglist
begin=false

if recycle(tbl) then store(init())
else store(tbl) end
UO.SysMessage("Sorting complete.")
UO.LTargetID=targ
UO.LTargetKind=targk
UO.LObjectID=lobj
stop()
end

manager(init())

--[[

------TRASHWEP------
bokuto            10152 ++++
butchers knife    5110---- 
bone arms         5198
bone chest        5199
bone gloves       5200
bone hat          5201
bone legs         5202
cleaver           3779
orc hat           7947
orc mask          5147
pitchfork         3719
refresh potion    3851
skinning knife    3780
tear kite shield  7033 
tetsubo           10150
tribal mask       5451
wand 1            3570
wand 2            3571
wand 3            3572
wand 4            3573
wooden shield     7034
------OTHER--------   
agility potion    3848
candle            2600 
clockwork assemb  7848
cure potion       3847
deed - dart board 5360+++
executioners cap  3971
firehorn          4039
gears             4179  
head              7584
heal potion       3852
heating stand on  6217
heating stand off 6218
explostion potion 3853
fancy wind chime  10291
jug of cider      2504
left arm          7585
left leg          7587
lesser poison pot 3850
map               5356+++
poison potion     3850
power crystal     7964
right leg         7588
seed              3535
spyglass          5365
strength potion   3849 
torso             7583
vines 1           3309
vines 1           3310
vines 1           3311
vines 1           3312
vines 1           3313
vines 2           3314
vines 3           3307
local trash={2504,2600,3307,3309,3310,3311,3312,3313,3314,3535,3568,3570,3571,3572,3573,
             3719,3779,3780,3847,3848,3849,3850,3851,3852,3853,3971,4039,4179,
             5110,5117,5147,5198,5199,5200,5201,5202,5365,5451,6217,6218,
             7033,7034,7583,7584,7585,7587,7588,7848,7947,7964,7981,7982,7983,7984,7985,7986,7987,7988,7989,
             7990,7991,7992,7993,7994,7995,7996,7997,7998,7999,
             8000,8001,8002,8003,8004,8005,8006,8007,8008,8009,
             8010,8011,8013,8014,8015,8016,8017,8018,8019,
             8020,8021,8022,8023,8024,8025,8026,8027,8028,8029,
             8030,8031,8033,8034,8035,8036,8037,8038,8039,
             8040,8041,8042,8043,8044,
             8800,8801,8804,8805,8806,8807,8808,8809,8810,8811,8812,8813,8814,8815,8816,
             10150,10152,10158,10291}    
-----SCROLLS----
druid           3641++++
--mage--                       
agility         7989
arch cure       8005
arch prot       8006
blade spirits   8013
bless           7997
chain light     8029
clumsy          7982
create food     7983
cunnin          7990
cure            7991
curse           8007
dispel          8021
disp field      8014
earthquake      8037
energy field    8030
feeblemind      7984
gate travel     8032----
great heal      8009
harm            7992
heal            7985           
energy bolt     8022
energy vortex   8038
explosion       8023
fire field      8008
fireball        7998          
flamestrike     8031
incognito       8015
invisibility    8024
lightning       8010
recall          8012----
magic arrow     7986
magic lock      7999
magic reflect   8016
magic trap      7993
magic untrap    7994
mana drain      8011
mana vampire    8033
mark            8025
mass curse      8026
mass dispel     8034
meteor storm    8035
mind blast      8017
night sight     7987
paralyze        8018
paralyze field  8027
poison          8000
poison field    8019
polymorph       8036
protection      7995
reactive armor  7981
resurrection    8039
reveal          8028
strength        7996
summon air ele  8040 
summon creature 8020
summon daemon   8041
summon earth el 8042
summon fire ele 8043
summon water el 8044
telekenisis     8001
teleport        8002
wall of stone   8004
weaken          7988
unlock          8003       
--necro--
animate dead    8800
blood oath      8801
evil omen       8804
exorcism        8816
horrific beast  8805
lich form       8806
mind rot        8807
pain spike      8808
poison strike   8809
strabgle        8810
summon familier 8811
vampire embrace 8812
vengeful spirit 8813
wither          8814
wraith form     8815

------SMELT--------- 
local smelt={3932,3934,3937,3938,5040,5049,5049,5051,5054,5055,5099,
             5100,5102,5104,5119,
             5121,5123,5125,5127,5128,5130,5132,5134,5136,5137,5138,5139,
             5140,5141,5046,5179,5181,5185,
             7026,7027,7028,7030,7035,7107,7172,9914,9915,9916,9917,9918,9919,9920,9921,9797,
             10112,10113,10146,10148,10151,10153,10155,10157,10159,11119}
bascinet          5132
bladed staff      9917
bone harvester    9915
broadsword        3934
bronze shield     7026
buckler           7027
chain coif        5051
chain legs        5054
chain tunic       5055
chaos shield      7107 
close hat         5128
crescent blade    9921
cutlass           5185
daicho            10153
double blade swrd 9919
fem tunic         7172
hammer pick       5181
helmet            5130
heater shield     7030
lajatang          10151
lance             9920
long sword        3937
light plt jingasa 10113
kama              10157
katana            5119
kite shield       7028
kryss             5121
mace              3932
maul              5179
metal shield      7035
no-dachi          10146
norse hat         5134
pike              9918
plate arms        5136
plate globes      5140
plate gorget      5139
plate hat         5138
plate hiro sode   10112
plate legs        5137
plate tunic       5141
red scale dr helm 9797
ring gloves       5099
ring legs         5104
ring sleeves      5102
ring tunic        5100
royal circlet     11119
scimitar          5046
short spear       5123
tekagi            10155
viking sword      5049
wackizacki        10148
war axe           5040
war fork          5125
war hammer        5177
war mace          5127
sai               10159
scepter           9916
scimitar          5046
spear             3938
sycthe            9914
                       
dagger            3922
-------CUT--------
local cut={3989,4217,5062,5063,5067,5068,5069,5077,5078,5082,5083,5084,
           5397,5398,5399,5422,5431,5433,5437,5440,5444,5899,           
           5901,5903,5905,5907,5908,5909,5910,5912,5913,5914,5915,
           7168,7170,7174,7176,7178,7180,7609,7933,7937,7939,
           8059,8097,8189,8970,8972,
           10102,10110,10114,10122,10126,10127,10129,
           10130,10131,10132,10134,10135,10136,10145,10182,10183,
           11124,11125,11127,11128}
apron             5437
bandana           5440
bolt of cloth     3989
bonnet            5913 
boots             5899
cap               5909
dis flesh - arms  11127
dis flesh - chest 11124
dis flesh - hands 11125
dis flesh - legs  11128
doublet           8059
hides             4217
fancy shirt       7933
feather hat       5914-
fem leather tunic 7174
floppy hat        5907
fur coat          8970
fur sarong        8972
long pants        5433
robe              7939
waraji & taji     10134
cloak             5397
jin-baori         10145
kasa              10136
kilt              5431
kimono male       10114
leather bustier   7178
leather cap       7609
leather do        10182
leather gorget    5063
leather gloves    5062
leather hadiate   10122
leather hiro sode 10110
leather jingasa   10102
leather legs      5067
lrather sleeves   5069
leather skirt     7176
leather shorts    7168
leather tunic     5068
ninja hat 1       10126
ninja hat 2       10127
ninja jacket      10131 10132
ninja mittens     10130
ninja pants       10129
ninja tabi        10135
--oil cloth         5981
plain dress       7937
sandals           5901
shirt             5399
shoes             5903
short pants       5422
skirt             5398
skullcap          5444
studded armor     7170
studded bustier   7180
studded do        10183
studded gloves    5077
studded gorget    5078
studded legs      5082
studded sleeves   5084
studded tunic     5083
surcoat           8189
tall straw hat    5910
thigh boots       5905
tricorn hat       5915
tunic             8097
wide brim hat     5908
wizard hat        5912
--------CARPCHOP---------
club              5044
gnarled staff     5112
nunchuck          10158 ++++
black staff       3568
medium create     3647
quarter staff     3721
shep crook        3713
---FLETCHCHOP------
bow               5042
composite bow     9922
crossbow          3920 ++++
heavy crossbow    5117 ++++
repeating xbow    9923

]]--