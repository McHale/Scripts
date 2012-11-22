gloNext, gloAdd= false, 0

function steal()
repeat
for i=0, UO.ScanItems(false)-1,1 do
       local id,typ,kind,contid,x,y,z,stack,rep,col = UO.GetItem(i)
       if typ == 4011 and contid ~= UO.BackpackID then
          gloCont = contid
          UO.LTargetID = 1
          while UO.LTargetID ~= id do
                UO.LTargetID = id
          end
          repeat
          wait(200 + gloAdd)
          UO.Macro(13,33)
          for ii=0, 10 do
              if UO.TargCurs == true then
                 break
              end
              wait(50)
          end
          wait(200)
          UO.Macro(22,0)
          local oldRef = 0
             for iii=0,150 do
                 local jourRef, jourCnt = UO.ScanJournal(oldRef)
                 if oldRef ~= jourRef then
                    local lines = UO.GetJournal(0)
                    local oldRef = jourRef
                    if string.match(lines, "successful") ~= nil then
                       gloNext, gloAdd = true, 8800
                       break
                    elseif string.match(lines, "fail") ~= nil then
                       gloNext, gloAdd = true, 8800
                       wait(9000)
                       break
                    elseif string.match(lines, "wait") ~= nil then
                       gloNext, gloAdd = false, 0
                       wait(1000)
                       break
                    end
                 end
                 gloNext = false
                 wait(10)
             end
          until gloNext == true
       x, rSkill, cSkill, y = UO.GetSkill("STEA")
       if rSkill == cSkill then 
          break
       end
       end
   end
      replace()
until rSkill == cSkill
end

function replace()
for i=0, UO.ScanItems(false)-1,1 do
       local id,typ,kind,contid,x,y,z,stack,rep,col = UO.GetItem(i)
       if typ == 4011 and contid == UO.BackpackID then
       UO.Drag(id)
       for ii=0,10 do
           if UO.LLiftedID == id then
              break
           end
           wait(50)
       end
       wait(200)
       UO.DropC(gloCont)
       wait(200)
       end
   end
end
       
steal()
          