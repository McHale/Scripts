    -- BlaZin' HealR
    -- by BlaZe Buddle of Excelsior's ßud ßrothers
    -- v1.1 Completed 12/28/10
    -- OpenEUO version by Mad Martigan 08/17/11
    hp = 75  -- This is the % your HP will be at before the script does a [bandself.
    pause = 1 -- Increase this number if the script doesn't pause
    while true do
          if string.match (UO.CharStatus, "H") == nil and UO.Hits > 0 then
             if (( UO.Hits * 100 ) / UO.MaxHits) <= hp or string.match (UO.CharStatus, "C") ~= nil then
                UO.Macro(1,0,"[bandself")
                time = (11 - (math.floor(UO.Dex / 20))) * 1000
                if time < 250 then
                   time = 250
                end
                wait (time + pause)
             end
          end
          wait (50)
    end