-- menu lib 1.0

--[[
example:

my_new_form = menu:form(400,200,"My test menu") --creates a 400x200 window with title "My test menu"
my_new_button = my_new_form:button("saysok"0,0,100,20,"click me!") -- adds a button to the form at 0,0 sized 100x20 and with text "click me!" on it

-- these two lines do the same thing
my_new_button:onclick(function() print("ok") end)
my_new_form.saysok:onclick(function() print("ok") end)

--adds a panel to the form and a checkbox to the panel
my_new_form:panel("sidepanel",200,0,200,200):button("button_in_the_panel",0,0,100,20,"panel button")

my_new_form:show()
Obj.Loop()
my_new_form:free()
]]--

menu = {}
menu_meta = {__index=menu}

function menu:form(w,h,name)
    local a = {}
    a.ctrl = Obj.Create("TForm")
    
    a.ctrl.Width = w
    a.ctrl.Height = h
    a.ctrl.Caption = name
    a.ctrl.FormStyle = 3
    a.ctrl.OnClose = function()
                        Obj.Exit()
                    end
    
    setmetatable(a,menu_meta)
    return a
end

function menu:button(id,x,y,w,h,name)
    local a = {}
    a.ctrl = Obj.Create("TButton")
    
    a.ctrl.Parent = self.ctrl
    a.ctrl.Left = x
    a.ctrl.Top = y
    a.ctrl.Width = w
    a.ctrl.Height = h
    a.ctrl.Caption = name
    
    setmetatable(a,menu_meta)
    self[id] = a
    return a
end

function menu:checkbox(id,x,y,w,h,name)
    local a = {}
    a.ctrl = Obj.Create("TCheckBox")
    
    a.ctrl.Parent = self.ctrl
    a.ctrl.Left = x
    a.ctrl.Top = y
    a.ctrl.Width = w
    a.ctrl.Height = h
    a.ctrl.Caption = name
    
    setmetatable(a,menu_meta)
    self[id] = a
    return a
end

function menu:combobox(id,x,y,w,h,items)
    local a = {}
    a.ctrl = Obj.Create("TComboBox")
    
    a.ctrl.Parent = self.ctrl
    a.ctrl.Left = x
    a.ctrl.Top = y
    a.ctrl.Width = w
    a.ctrl.Height = h
    for i = 1 , #tabs do
       a.ctrl.Items.Add(items[i])
    end
    
    setmetatable(a,menu_meta)
    self[id] = a
    return a
end

function menu:edit(id,x,y,w,h,text)
    local a = {}
    a.ctrl = Obj.Create("TEdit")
    
    a.ctrl.Parent = self.ctrl
    a.ctrl.Left = x
    a.ctrl.Top = y
    a.ctrl.Width = w
    a.ctrl.Height = h
    a.ctrl.Text = text
    
    setmetatable(a,menu_meta)
    self[id] = a
    return a
end

function menu:groupbox(id,x,y,w,h,name)
    local a = {}
    a.ctrl = Obj.Create("TGroupBox")
    
    a.ctrl.Parent = self.ctrl
    a.ctrl.Left = x
    a.ctrl.Top = y
    a.ctrl.Width = w
    a.ctrl.Height = h
    a.ctrl.Caption = name
    
    setmetatable(a,menu_meta)
    self[id] = a
    return a
end

function menu:label(id,x,y,w,h,name)
    local a = {}
    a.ctrl = Obj.Create("TLabel")
    
    a.ctrl.Parent = self.ctrl
    a.ctrl.Left = x
    a.ctrl.Top = y
    a.ctrl.Width = w
    a.ctrl.Height = h
    a.ctrl.Caption = name
    
    setmetatable(a,menu_meta)
    self[id] = a
    return a
end

function menu:listbox(id,x,y,w,h,toAdd)
    local a = {}
    a.ctrl = Obj.Create("TListBox")
    
    a.ctrl.Parent = self.ctrl
    a.ctrl.Left = x
    a.ctrl.Top = y
    a.ctrl.Width = w
    a.ctrl.Height = h

    setmetatable(a,menu_meta)
    self[id] = a
    return a
end

function menu:memo(id,x,y,w,h,text)
    local a = {}
    a.ctrl = Obj.Create("TMemo")
    
    a.ctrl.Parent = self.ctrl
    a.ctrl.Left = x
    a.ctrl.Top = y
    a.ctrl.Width = w
    a.ctrl.Height = h
    a.ctrl.Text = text
    
    setmetatable(a,menu_meta)
    self[id] = a
    return a
end

function menu:timer(id, interval, enabled)
    local a = {}
    a.ctrl = Obj.Create("TTimer")
    
   -- a.ctrl.Parent = self.ctrl
    a.ctrl.Interval = interval
    a.ctrl.Enabled = enabled

    setmetatable(a,menu_meta)
    self[id] = a
    return a
end

function menu:panel(id,x,y,w,h)
    local a = {}
    a.ctrl = Obj.Create("TPanel")
    
    a.ctrl.Parent = self.ctrl
    a.ctrl.Left = x
    a.ctrl.Top = y
    a.ctrl.Width = w
    a.ctrl.Height = h
    
    setmetatable(a,menu_meta)
    self[id] = a
    return a
end

function menu:radiobutton(id,x,y,w,h,name)
    local a = {}
    a.ctrl = Obj.Create("TRadioButton")
    
    a.ctrl.Parent = self.ctrl
    a.ctrl.Left = x
    a.ctrl.Top = y
    a.ctrl.Width = w
    a.ctrl.Height = h
    a.ctrl.Caption = name
    
    setmetatable(a,menu_meta)
    self[id] = a
    return a
end

function menu:scrollbar(id,x,y,w,h,minVal,maxVal,pos)
	local a = {}
    a.ctrl = Obj.Create("TScrollBar")
    
    a.ctrl.Parent = self.ctrl
    a.ctrl.Left = x
    a.ctrl.Top = y
    a.ctrl.Width = w
    a.ctrl.Height = h
    a.ctrl.Min = minVal
    a.ctrl.Max = maxVal
    a.ctrl.Position = pos
    
    setmetatable(a,menu_meta)
    self[id] = a
    return a
end

function menu:tabcontrol(id,x,y,w,h,tabs)
    local a = {}
    a.ctrl = Obj.Create("TTabControl")
    
    a.ctrl.Parent = self.ctrl
    a.ctrl.Left = x
    a.ctrl.Top = y
    a.ctrl.Width = w
    a.ctrl.Height = h
    for i = 1 , #tabs do
       a.ctrl.Tabs.Add(tabs[i])
    end
    
    setmetatable(a,menu_meta)
    self[id] = a
    return a
end

function menu:save(id,ext,dir,title)
    local a = {}
    a.ctrl = Obj.Create("TSaveDialog")
    
    a.ctrl.Parent = self.ctrl
    a.crtl.DefaultExt = ext
    a.ctrl.Title  = title
    
    setmetatable(a,menu_meta)
    self[id] = a
    return a 
end

function menu:open()
    local a = {}
    a.ctrl = Obj.Create("TOpenDialog")
    
    a.ctrl.Parent = self.ctrl
    a.crtl.DefaultExt = ext
    a.ctrl.Title  = title
    
    setmetatable(a,menu_meta)
    self[id] = a
    return a 
end

-- functions to customize created menu objects

function menu:back() -- sends object to background
    self.ctrl.SendToBack()
    return self
end

function menu:caption(c)
    self.ctrl.Caption = c
    return self
end

function menu:checked(b) -- if no arguments, switches between checked/unchecked
    self.ctrl.Checked = b or ( not self.ctrl.Checked )
    return self
end

function menu:color(c)
    self.ctrl.Color = c
    return self
end

function menu:enabled(b) -- if no arguments, switches between enabled/disabled
    self.ctrl.Enabled = b or ( not self.ctrl.Enabled )
    return self
end

function menu:front() -- brings the object to front
    self.ctrl.BringToFront()
    return self
end


function menu:free() -- frees the object, NOTE: doesn't remove it from the table
    Obj.Free(self.ctrl)
end

function menu:hint(s) -- sets the hint of the object
    self.ctrl.Hint = s
    return self
end

function menu:onchange(f)
    self.ctrl.OnChange = f
    return self
end

function menu:onclick(f)
    self.ctrl.OnClick = f
    return self
end

function menu:ontimer(f)
    self.ctrl.OnTimer = f
    return self
end

function menu:pos(x,y)
    self.ctrl.Left = x
    self.ctrl.Top = y
    return self
end

function menu:size(w,h)
    self.ctrl.Width = w
    self.ctrl.Height = h
    return self
end

function menu:show()
    self.ctrl.Show()
    return self
end

function menu:text(s)
    self.ctrl.text = s
    return self
end
