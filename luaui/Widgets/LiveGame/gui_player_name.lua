function widget:GetInfo()
	return {
		name = "Live Player Name",
		desc = "Displays player name above tower.",
		author = "eqd",
		date = "12 August 2024",
		license = "-",
		layer = -2,
		enabled = true,
	}
end

local fontSize = 18
local hideBelowGameframe = 10
local scaleFontAmount = 120
local nameScaling = true
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local GetUnitTeam = Spring.GetUnitTeam
local GetPlayerInfo = Spring.GetPlayerInfo
local GetTeamInfo = Spring.GetTeamInfo
local GetPlayerList = Spring.GetPlayerList
local GetTeamColor = Spring.GetTeamColor
local GetUnitDefID = Spring.GetUnitDefID
local GetAllUnits = Spring.GetAllUnits
local IsUnitVisible = Spring.IsUnitVisible
local IsUnitIcon = Spring.IsUnitIcon
local GetCameraPosition = Spring.GetCameraPosition
local GetUnitPosition = Spring.GetUnitPosition
local GetUnitExperience = Spring.GetUnitExperience
local GetUnitRulesParam = Spring.GetUnitRulesParam
local IsUnitInView = Spring.IsUnitInView

local glTexture = gl.Texture
local glTexRect = gl.TexRect
local glDepthTest = gl.DepthTest
local glAlphaTest = gl.AlphaTest
local glColor = gl.Color
local glTranslate = gl.Translate
local glBillboard = gl.Billboard
local glDrawFuncAtUnit = gl.DrawFuncAtUnit
local GL_GREATER = GL.GREATER
local GL_SRC_ALPHA = GL.SRC_ALPHA
local GL_ONE_MINUS_SRC_ALPHA = GL.ONE_MINUS_SRC_ALPHA
local glBlending = gl.Blending
local glScale = gl.Scale
local glCallList = gl.CallList

local diag = math.diag

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local vsx, vsy = Spring.GetViewGeometry()

local fontfile = "fonts/" .. Spring.GetConfigString("bar_font2", "Exo2-SemiBold.otf")
local fontfileScale = (0.5 + (vsx * vsy / 5700000))
local fontfileSize = 50
local fontfileOutlineSize = 6
local fontfileOutlineStrength = 8
local font = gl.LoadFont(fontfile, fontfileSize * fontfileScale, fontfileOutlineSize * fontfileScale, fontfileOutlineStrength)

local usedFontSize

local drawList = {}
local players = {}
local unitMap = {}


local function RemoveLists()
	for _, list in pairs(drawList) do
		gl.DeleteList(list)
	end
	drawList = {}
end

function widget:Initialize()
    Spring.Echo("Live Player Name UI init");
end

local function CreateDrawNameList(attributes,id)
	local key = id..'name';
	if drawList[key] ~= nil then
		gl.DeleteList(drawList[key])
	end
	drawList[key] = gl.CreateList(function()
		local x,y = 0,0
		local outlineColor = { 0, 0, 0, 1 }
		if (attributes.color[1] + attributes.color[2] * 1.2 + attributes.color[3] * 0.4) < 0.65 then
			outlineColor = { 1, 1, 1, 1 }		-- try to keep these values the same as the playerlist
		end
		local name = attributes.name
		font:Begin()
		font:SetTextColor(attributes.color)
		font:SetOutlineColor(outlineColor)
		font:Print(name, x, y, fontSize, "con")
		font:End()
	end)
end

local function DrawName(attributes,id)
	local key = id..'name';
	if drawList[key] == nil then
		CreateDrawNameList(attributes,id)
	end
	glTranslate(0, attributes.height, 0)
	glBillboard()
	if nameScaling then
		glScale(usedFontSize / fontSize, usedFontSize / fontSize, usedFontSize / fontSize)
	end
	glCallList(drawList[key])
	if nameScaling then
		glScale(1, 1, 1)
	end
end

function widget:NeedDraw()
	return #players > 0;
end

function widget:DrawWorld()
	if Spring.IsGUIHidden() then return end
	if Spring.GetGameFrame() < hideBelowGameframe then return end
	if not widget:NeedDraw() then return end

	glDepthTest(true)
	glAlphaTest(GL_GREATER, 0)
	glBlending(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)

	local camX, camY, camZ = GetCameraPosition()
	local camDistance
	for id, player in pairs(players) do
		local unitID = player.unitId;
		if IsUnitVisible(unitID, 50) and IsUnitInView(unitID) then
			local x, y, z = GetUnitPosition(unitID)
			camDistance = diag(camX - x, camY - y, camZ - z)
			usedFontSize = (fontSize * 0.5) + (camDistance / scaleFontAmount)
			glDrawFuncAtUnit(unitID, false, DrawName, player.drawNameAttr,id)
		end
	end

	glAlphaTest(false)
	glColor(1, 1, 1, 1)
	glDepthTest(false)
end

function widget:CreateDrawNameAttr(unitId,name,color,hoff)
	local team = GetUnitTeam(unitId)
	local unitDefID = GetUnitDefID(unitId)
	if color == nil then
		local r, g, b, a = GetTeamColor(team)
		color = { r,g,b,a };
	end
	local height =  UnitDefs[unitDefID].height + (hoff or 0);
	return {
		color = color,
		name = name,
		height = height
	}
end

function widget:RemoveDrawList(key)
	if drawList[key] ~= nil then
		gl.DeleteList(drawList[key])
		drawList[key] = nil;
	end
end

function widget:AddPlayerName(unitId,name,id,color)
	if players[id] ~= nil then
		widget:RemoveDrawList(id..'name')
	else
		players[id] = {}
	end
	players[id].unitId = unitId;
	players[id].drawNameAttr = widget:CreateDrawNameAttr(unitId,name,color);
	unitMap[unitId] = id;
end


function widget:Shutdown()
	RemoveLists()
	gl.DeleteFont(font)
end

function widget:RecvLuaMsg(msg,playerId)
	local start_pos,end_pos = string.find(msg,"ShowLivePlayerName")
	if start_pos ~= nil then
		local args = string.sub(msg, end_pos + 1);
		args = Json.decode(args);
		if args and args.unitId and args.name and args.id then
			self:AddPlayerName(args.unitId,args.name,args.id,args.color);
		end
		return
	end

end


function widget:UnitDestroyed(unitID, unitDefID, unitTeam)
	if unitMap[unitID] ~= nil then
		local id = unitMap[unitID];
		local nameKey = id..'name';
		widget:RemoveDrawList(nameKey);
		drawList[nameKey] = nil;
		players[id] = nil;
		unitMap[unitID] = nil;
	end
end