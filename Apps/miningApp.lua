//to target a mining spot


function getTargetTile(cardinalDirection)
	UO.LTargetKind = 2
	if cardinalDirection == "North" then
		UO.LTargetY = UO.CharPosY-1
		UO.LTargetX = UO.CharPosX
	elseif cardinalDirection == "South" then
		UO.LTargetY = UO.CharPosY+1
		UO.LTargetX = UO.CharPosX
	elseif cardinalDirection == "East" then
		UO.LTargetY = UO.CharPosY
		UO.LTargetX = UO.CharPosX+1
	else
		UO.LTargetY = UO.CharPosY
		UO.LTargetX = UO.CharPosX-1
end


