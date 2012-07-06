------------------------------------
-- Script Name: journal.lua
-- Author: Kal In Ex
-- Version: 2.1
-- Client Tested with: 7.0.18.0 (Patch 56)
-- EUO version tested with: OpenEUO 0.91.0030
-- Shard OSI / FS: OSI
-- Revision Date: September 26,2011
-- Public Release: May 19, 2010
-- Purpose: easier journal scanning
-- Copyright: 2010,2011 Kal In Ex
------------------------------------
-- http://www.easyuo.com/forum/viewtopic.php?t=47299

local Size = 100 -- how far back does the journal history go
local Index = 1000 -- must be a multiple of Size!
local History = {} for i=0,Size-1 do History[i] = {} end
local JRef,JCnt = UO.ScanJournal(0)
local Last = {}
local Journal = {}
Journal.__index = Journal

-- initialize journal history
	for i=JCnt-1,0,-1 do
		Index = Index + 1
		History[Index%Size] = {UO.GetJournal(i)}
	end

-- update journal history
	Journal.Update = function()
		JRef,JCnt = UO.ScanJournal(JRef)
		for i=JCnt-1,0,-1 do
			Index = Index + 1
			History[Index%Size] = {UO.GetJournal(i)}
		end
	end

-- return text relative to journal "bottom"
	Journal.Scan = function(self,i)
		self:Update()
		return unpack(History[(Index-i)%Size])
	end

-- return text in History by index number
--[=[
	Journal.Get = function(self,i)
		if i > Index then
			self:Update()
			if i > Index then -- check if "i" is outside of History bounds
				return
			end
		end
		if Index - i >= Size then  -- check if "i" is outside of History bounds
			return
		end
		if Index - i > Index then -- check if "i" is outside of saved History
			return
		end
		return unpack(History[(Index%Size)-(Index-i)])
	end
--]=]
	Journal.Get = function(self,i)
		return unpack(History[((Index%Size)-(Index-i)+Size)%Size])
	end

--[=[
-- returns the journal objects index followed by the saved journals index
	Journal.Idx = function(self)
		self:Update()
		return self.Index,Index
	end
--]=]

-- return number of un-read messages
	Journal.JIndex = function(self)
		self:Update()
		return Index
	end

-- return next journal entry
	Journal.Next = function(self)
		self:Update()
		if self.Index == Index then
			return
		end
		self.Index = self.Index + 1
		Last = History[(Index%Size)-(Index-self.Index)]
		return unpack(Last)
	end

-- return last read journal entry
	Journal.Last = function(self)
		return unpack(Last)
	end

-- update History and set objects index equal to History index
	Journal.Clear = function(self)
		self:Update()
		self.Index = Index
	end

-- find text in journal
	Journal.Find = function(self,...)
		local varg = {...}
		while self:Next() do
			for i=1,#varg do
				if string.find((self:Last()),varg[i],1,true) then
					return i
				end
			end
		end
	end

-- wait for text in journal
	Journal.Wait = function(self,t,...)
		local TimeOUT = getticks() + t
		repeat
			local Result = self:Find(...)
			if Result then
				return Result
			end
			wait(1)
		until getticks() > TimeOUT
	end

-- return table for new journal object
	NewJournal = function()
		local t = {Index=Index}
		setmetatable(t,Journal)
		return t
	end
