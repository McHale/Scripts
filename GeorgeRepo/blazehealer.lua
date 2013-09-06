    -- BlaZin' HealR
    -- by BlaZe Buddle of Excelsior's ßud ßrothers
    -- v1.1 Completed 12/28/10
    local hp=75
    -- This is the % your HP will be at before the script does a [bandself.
    local gwait=1
    -- Increase this number if the script doesn't pause
    -- long enough before applying more bandages. (1000 = 1 second)
    ---------- ---------- ---------- ---------- ----------
function heal()
  repeat
   while UO.Weight==0 do UO.Macro(8,2) end
	if UO.Hits*100/UO.MaxHits <= hp or string.match(UO.CharStatus, "C") then
	   UO.Macro(1,0,"[bandself") 
	   local time=math.max((11 - ( UO.Dex / 20 )) * 20, 5)*50+getticks()
	   while time+gwait>getticks() do end
        end
  until true==false
end

--20=1s
--1000=1s

heal()