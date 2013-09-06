local tool={2431,3718,3739,3897,3907,3909,3911,3913,3915,3997, 
             4027,4031,4130,4136,4138,4148,4158,4325,4326,4327,
             4787,4979,5040,5091,5092,5115,5187,7864}
local wood={7121,7124,7127,7133,7163,3903}
local tailor={3613,3576,4225,5990,5991}
local metal={7154}
local rock={6009}
local magic={3827,3960,3962,3963,3965,3966,3968,3969,
             3972,3973,3974,3976,3978,3980,3981,3982,3983,
             4586,7956,9911}
local gem={3873,3877,3878,3885,3859,3861,3862,3865,3856,12690,12691,12697}
local key={}
local text={"Gem Pouch", "Metal Worker's Keys", "Spell Caster's Keys", 
             "Stone Worker's Keys", "Tailor's Keys", 
            "Wood Worker's Keys", "Tool House"}
local gooditem={"Empty", "Key Ring"}
local gump={{sx=505, sy=325, ox=290, oy=285},
            {sx=505, sy=270, ox=290, oy=235},
            {sx=505, sy=475, ox=290, oy=435},
            {sx=505, sy=270, ox=290, oy=235},
            {sx=505, sy=440, ox=290, oy=410},
            {sx=505, sy=295, ox=290, oy=260},
            {sx=505, sy=365, ox=290, oy=335},
            {sx=530, sy=437, ox=30, oy=350}}
local trash={2504,2600,3641,3719,3721,3779,3920,4039,5042,5044,
             5110,5112,5117,5198,5199,5200,5201,5202,5365,6217,6218,
             7033,7034,7947,7981,7982,7983,7984,7985,7986,7987,7988,7989,
             7990,7991,7992,7993,7994,7995,7996,7997,7999,
             8000,8001,8002,8003,8004,8005,8006,8007,8008,8009,
             8010,8011,8012,8013,8014,8015,8016,8017,8018,8019,
             8020,8021,8022,8023,8024,8025,8026,8027,8028,8029,
             8031,8032,8033,8034,8035,8036,8041,8042,
             8806,8808,8809,8810,8814,8811,9923,10152,10158}       
local cut={3989,5062,5063,5067,5068,5069,5077,5078,5083,5084,5397,5399,5433,5901,5905,
           7168,7170,7174,7176,7178,7939,
           10110,10122,10126,10129,10130,10131,10134,10135,10182}
local smelt={3932,3934,3937,5040,5049,5049,5051,5054,5055,5099,5100,5102,5119,
             5121,5123,5125,5127,5128,5130,5132,5134,5136,5137,5139,
             5140,5141,5046,5177,5181,5182,5185,
             7026,7027,7030,7035,7172,9914,9915,9918,9919,9920,
             10112,10113,10148,10153,10155,10157,10159}
local sci,smi=false,false
local tbag={}
local next=next
             
function init()
local result={}
   for i=0, UO.ScanItems(true)-1,1 do
       local bol=true
     local nid,typ,kind,contid,_,_,_,stck=UO.GetItem(i)
     if contid==UO.BackpackID then
     if typ==2482 then
        local nma=UO.Property(nid)
        if string.match(nma,"Trash") then 
           table.insert(tbag,nid) 
           bol=false 
        end
     elseif not sci and typ==3999 then sci=nid bol=false 
     elseif not smi and typ==5092 then smi=nid 
     end 
     if typ==5995 or typ==8900 or typ==3705 then
        local nma=UO.Property(nid)
        if next(key) then
           if #key<8 then
              for t,tt in pairs(text) do
                 if string.match(nma, tt) then print(t.." "..nid) key[t]=nid bol=false break end
              end
           else
               for t,tt in pairs(key) do
                   if tt==nid then bol=false break end
               end
           end
        elseif not next(key) then
            for t,tt in pairs(text) do
                if string.match(nma, tt) then print(t.." "..nid) key[t]=nid bol=false break end
            end
        end
     end
     if bol then
     table.insert(result, {id=nid, tp=typ, k=kind, cont=contid, stack=stck})
     end
     end
   end
   return result
end

function store(tbl)
local g,m,s,ta,w,sp,tl={},{},{},{},{},{},{}
local scissor=0
for i,ii in pairs(tbl) do
    for t,tt in pairs(gem) do
        if ii.tp==tt then
           table.insert(g, ii.id) break end
    end
    for t,tt in pairs(metal) do
         if ii.tp==tt then table.insert(m, ii.id) break end
    end
    for t,tt in pairs(magic) do 
        if ii.tp==3854 or ii.tp==5995 or ii.tp==6464 then
           local nma=UO.Property(ii.id)
           if string.match(nma,gooditem[1]) or string.match(nma,gooditem[2]) then
              table.insert(sp, ii.id) print("M:"..UO.Property(ii.id))
              break
           end   
        elseif ii.tp==tt then print("M:"..UO.Property(ii.id))
         table.insert(sp, ii.id) break 
        end   
    end
    for t,tt in pairs(rock) do
        if ii.tp==tt then
        table.insert(s, ii.id) break end
    end
    for t,tt in pairs(tailor) do   
        if ii.tp==tt then print("T:"..UO.Property(ii.id))
        table.insert(ta, ii.id) break end
    end
    for t,tt in pairs(wood) do
        if ii.tp==tt then
        table.insert(w, ii.id) break end
    end
    for t,tt in pairs(tool) do
         if ii.tp==tt then print("TL:"..UO.Property(ii.id))
         table.insert(tl, ii.id) break end
    end
end
if next(g) and key[1]~=nil then storit(1,g) end
if next(m) and key[2]~=nil then storit(2,m) end
if next(sp) and key[3]~=nil then storit(3,sp) end
if next(s) and key[4]~=nil then storit(4,s) end
if next(ta) and key[5]~=nil then storit(5,ta) end
if next(w) and key[6]~=nil then storit(6,w) end
if next(tl) and key[7]~=nil then storit(7,tl) end
if UO.TargCurs then UO.Key("ESC") end
end

function recycle(tbl)
local c,tr,sm={},{},{}
for i,ii in pairs(tbl) do
    if smi then
    for t,tt in pairs(smelt) do
        if ii.tp==tt then UO.SysMessage("SMELT:"..UO.Property(ii.id))
        table.insert(sm, ii.id) break end
    end
    end
    if sci then
    for t,tt in pairs(cut) do
        if ii.tp==tt then UO.SysMessage("CUT:"..UO.Property(ii.id))
        table.insert(c, ii.id) break end
    end
    end
    if next(tbag) then
    for t,tt in pairs(trash) do
        if ii.tp==tt then print("G:"..UO.Property(ii.id).." "..ii.stack)
        table.insert(tr, {id=ii.id,stck=ii.stack}) break end
    end
    end
end
if next(tr) then trashit(tr) end
if next(c) and sci then cutit(c) end
if next(sm) then smeltit(sm) end
return
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
print(UO.Property(key[int]))
UO.LObjectID=key[int]
UO.Macro(17,0)
while true do
UO.LObjectID=key[int]
wait(200)
UO.Macro(17,0)
wait(200)
if UO.ContSizeX==gump[int].sx and UO.ContSizeY==gump[int].sy then break end
end
UO.Click(UO.ContPosX+gump[int].ox, UO.ContPosY+gump[int].oy, true, true, true, false)
for i,ii in pairs(tbl) do
    UO.LTargetKind=1
    UO.LTargetID=ii
    while not UO.TargCurs do wait(100) end
    UO.Macro(22,0)
end
wait(960)
if UO.ContSizeX==gump[int].sx and UO.ContSizeY==gump[int].sy then
    UO.Click(UO.ContPosX+UO.ContSizeX/2,UO.ContPosY+UO.ContSizeY/2, false, true, true, false)
end
return
end

function trashit(tbl)
for i,ii in pairs(tbl) do
    repeat 
        UO.Drag(ii.id,ii.stck)
        wait(500)
        UO.DropC(tbag[1+(i%(#tbag))])
        local timer=getticks()+1000
        while timer>getticks() do
        if string.match(UO.SysMsg, "You have trashed") then break end
        end
    until string.match(UO.SysMsg, "You have trashed")
end
return
end

function cutit(tbl)
UO.LObjectID=sci
     for i, ii in pairs(tbl) do
        UO.LTargetKind=1
        UO.LTargetID=ii
        while not UO.TargCurs do UO.Macro(17,0) wait(100) end
        while UO.TargCurs do
        UO.Macro(22,0)
        end   
end
return
end

recycle(init())
store(init())
stop()

--[[

------TRASHWEP------
bokuto            10152
butchers knife    5110 
cleaver           3779
shep crook        3713
bone arms         5198
bone chest        5199
bone gloves       5200
bone hat          5201
bone legs         5202
bow               5042
club              5044
crossbow          3920
gnarled staff     5112
heavy crossbow    5117
nunchuck          10158
orc hat           7947
pitchfork         3719
quarter staff     3721
repeating xbow    9923
tear kite shield  7033
wooden shield     7034
------OTHER--------
candle            2600
firehorn          4039
heating stand on  6217
heating stand off 6218
jug of cider  2504
spyglass          5365 
-----SCROLLS----
druid           3641
--mage--
local trash={2504,2600,3641,3719,3721,3779,3920,4039,5042,5044,
             5110,5112,5117,5198,5199,5200,5201,5202,5365,6217,6218,
             7033,7034,7947,7981,7982,7983,7984,7985,7986,7987,7988,7989,
             7990,7991,7992,7993,7994,7995,7996,7997,7999,
             8000,8001,8002,8003,8004,8005,8006,8007,8008,8009,
             8010,8011,8012,8013,8014,8015,8016,8017,8018,8019,
             8020,8021,8022,8023,8024,8025,8026,8027,8028,8029,
             8031,8032,8033,8034,8035,8036,8041,8042,
             8806,8808,8809,8810,8814,9923,8811,10152,10158}    
             
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
feeblemind      7984
gate travel     8032
great heal      8009
harm            7992
heal            7985           
energy bolt     8022
explosion       8023
fire field      8008          
flamestrike     8031
incognito       8015
invisibility    8024
lightning       8010
recall          8012
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
reveal          8028
strength        7996 
summon creature 8020
summon earth el 8042
summon daemon   8041
telekenisis     8001
teleport        8002
wall of stone   8004
weaken          7988
unlock          8003       
--necro--
lich form       8806
pain spike      8808
poison strike   8809
strabgle        8810
summon familier 8811
wither          8814

------SMELT--------- 
local smelt={3932,3934,3937,5040,5049,5049,5051,5054,5055,5099,5100,5102,5119,
             5121,5123,5125,5127,5128,5130,5132,5134,5136,5137,5139,
             5140,5141,5046,5177,5181,5182,5185,
             7026,7027,7030,7035,7172,9914,9915,9918,9919,9920,
             10112,10113,10148,10153,10155,10157,10159}
bascinet          5132
bone harvester    9915
broadsword        3934
bronze shield     7026
buckler           7027
chain coif        5051
chain legs        5054
chain tunic       5055 
close hat         5128
cutlass           5185
daicho            10153
double blade swrd 9919
fem tunic         7172
hammer pick       5181
helmet            5130
heater shield     7030
lance             9920
long sword        3937
light plt jingasa 10113
kama              10157
katana            5119
kryss             5121
mace              3932
metal shield      7035
norse hat         5134
pike              9918
plate arms        5136
plate globes      5140
plate gorget      5139
plate hiro sode   10112
plate legs        5137
plate tunic       5141
ring gloves       5099
ring sleeves      5102
ring tunic        5100
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
scimitar          5046
sycthe            9914
                       
dagger            3922
halberd           5182
-------CUT--------
local cut={3989,5062,5063,5067,5068,5069,5077,5078,5083,5084,5901,5397,5399,5433,5905,
           7168,7170,7174,7176,7178,7939,
           10110,10122,10126,10129,10130,10131,10134,10135,10182}
           
bolt of cloth     3989
fem leather tunic 7174
long pants        5433
robe              7939
waraji & taji     10134
cloak             5397
leather bustier   7178
leather do        10182
leather gorget    5063
leather gloves    5062
leather hadiate   10122
leather hiro sode 10110
leather legs      5067
lrather sleeves   5069
leather skirt     7176
leather shorts    7168
leather tunic     5068
ninja hat         10126
ninja jacket      10131
ninja mittens     10130
ninja pants       10129
ninja tabi        10135
sandals           5901
shirt             5399
studded armor     7170
studded gloves    5077
studded gorget    5078
studded sleeves   5084
studded tunic     5083
thigh boots       5905

]]--