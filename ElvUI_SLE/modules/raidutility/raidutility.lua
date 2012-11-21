local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local RU = E:GetModule('RaidUtility');
local M = E:GetModule('Misc');

E.RaidUtility = RU

--Moved RU down cause of top datatext panels
function RU:MoveButton()
	RaidUtility_ShowButton:ClearAllPoints()
	RaidUtility_ShowButton:Point("CENTER", E.UIParent, "BOTTOMLEFT", E.db.sle.raidutil.xpos, E.db.sle.raidutil.ypos)
end

--For moving raid utility button
M.InitializeSLE = M.Initialize
function M:Initialize()
	M.InitializeSLE(self)
	E:CreateMover(RaidUtility_ShowButton, "RaidUtility_Mover", "Raid Utility", nil, nil, nil, "ALL,S&L")
	local mover = RaidUtility_Mover
	
	mover:HookScript("OnDragStart", function(self) 
		local frame = RaidUtility_ShowButton
		frame:ClearAllPoints()
			frame:SetPoint("CENTER", self)
	end)
	
	mover:HookScript("OnDragStop", function(self) 
		local point, anchor, point2, x, y = self:GetPoint()
		local frame = RaidUtility_ShowButton
		frame:ClearAllPoints()
		if string.find(point, "BOTTOM") then
			frame:SetPoint(point, anchor, point2, x, y)
		else
			frame:SetPoint(point, anchor, point2, x, y)		
		end
	end)
	
	do
		local point, anchor, point2, x, y = mover:GetPoint()
		local frame = RaidUtility_ShowButton
		if string.find(point, "BOTTOM") then
			frame:SetPoint(point, anchor, point2, x, y)
		else
			frame:SetPoint(point, anchor, point2, x, y)		
		end
	end
end

function RU:ToggleButton()
	if RaidUtility_ShowButton:IsShown() then
		RaidUtility_ShowButton:Hide()
	else
		RaidUtility_ShowButton:Show()
	end
end


RaidUtility_ShowButton:RegisterForDrag("") --Unregister any buttons for dragging. 

