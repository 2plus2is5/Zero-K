function widget:GetInfo()
  return {
    name      = "Custom Markers",
    desc      = "Alternative to Spring map markers",
    author    = "Evil4Zerggin (adapted by KingRaptor)",
    date      = "29 December 2008",
    license   = "GNU LGPL, v2.1 or later",
    layer     = -100000.5,	-- lower than minimap but higher than epic (this doesn't actually do anything for the implied purpose)
    enabled   = true  --  loaded by default?
  }
end

----------------------------------------------------------------
--config
----------------------------------------------------------------
--negative to disable blinking
local blinkPeriod = -1
local ttl = 15
local highlightSize = 32
local highlightLineMin = 24
local highlightLineMax = 40
local edgeMarkerSize = 16
local lineWidth = 2
local maxAlpha = 1
local fontSize = 24
local fontSizeLarge = 32
local circleFreq = 1
local circleUpdateFreq = 0.01
local circleRadius = 150
local circleRadiusMin = 50
local circleAlpha = 0.9
--local circleAlphaMin = 0.1
local circleTTL = 3

local minimapHighlightSize = 8
local minimapHighlightLineMin = 6
local minimapHighlightLineMax = 10

local useFade = false
local circleDrawList
----------------------------------------------------------------
--speedups
----------------------------------------------------------------
local ArePlayersAllied = Spring.ArePlayersAllied
local GetPlayerInfo = Spring.GetPlayerInfo
local GetTeamColor = Spring.GetTeamColor
local GetSpectatingState = Spring.GetSpectatingState
local WorldToScreenCoords = Spring.WorldToScreenCoords
local glColor = gl.Color
local glRect = gl.Rect
local glLineWidth = gl.LineWidth
local glShape = gl.Shape
local glPolygonMode = gl.PolygonMode
local glText = gl.Text
local max = math.max
local abs = math.abs
local strSub = string.sub
local GL_LINES = GL.LINES
local GL_TRIANGLES = GL.TRIANGLES
local GL_LINE = GL.LINE
local GL_FRONT_AND_BACK = GL.FRONT_AND_BACK
local GL_FILL = GL.FILL

----------------------------------------------------------------
--Lups definition
----------------------------------------------------------------
local smokeFX = {
	layer     = 1,
	alwaysVisible = true,
	speed        = 0.65,
	count        = 2,
	    
	colormap     = { {0, 0, 0, 0.01},
			 {0.4, 0.4, 0.4, 0.01},
			 {0.35, 0.15, 0.15, 0.20},
			 {0, 0, 0, 0.01} },
	delaySpread  = 10,
	life         = 45,
	lifeSpread   = 15,
	rotSpeed     = 1,
	rotSpeedSpread = -2,
	rotSpread    = 360,	
	size = 30,
	sizeSpread   = 5,
	sizeGrowth   = 0.2,
	emitVector   = {0,1,0},
	emitRotSpread = 60,
	texture      = 'bitmaps/smoke/smoke01.tga',
}

local Lups
----------------------------------------------------------------
--vars
----------------------------------------------------------------
local mapPoints = {}
local circles = {}
local timeNow, timePart
local on = false
local mapX = Game.mapX * 512
local mapY = Game.mapY * 512

local vsx, vsy, sMidX, sMidY

----------------------------------------------------------------
--local functions
----------------------------------------------------------------
local function GetPlayerColor(playerID)
	local _, _, isSpec, teamID = GetPlayerInfo(playerID)
	if (isSpec) then return GetTeamColor(Spring.GetGaiaTeamID()) end
	if (not teamID) then return nil end
	return GetTeamColor(teamID)
end

local function StartTime()
	local viewSizeX, viewSizeY = widgetHandler:GetViewSizes()
	widget:ViewResize(viewSizeX, viewSizeY)
	timeNow = 0
	timePart = 0
	on = true
end

local function SetUseFade(bool)
	useFade = bool
end

local function RemovePoint(id)
	local point = mapPoints[id]
	if point and point.fx then
		point.fx:Destroy()
	end
	mapPoints[id] = nil
end

local function AddPoint(id, x, z, text, color)
	if mapPoints[id] then
		RemovePoint(id)
	end
	
	color = color or {1, 1, 1}
	local expiration = (timeNow or 0) + ttl
	local y = Spring.GetGroundHeight(x, z)
	
	mapPoints[id] = {color = color, x = x, y = y, z = z, text = text, expiration = expiration, fx = fx}
end

local function ClearPoints()
	for id in pairs(mapPoints) do
	      RemovePoint(id) 
	end
end

-- makes a color char from a color table
-- explanation for string.char: http://springrts.com/phpbb/viewtopic.php?f=23&t=24952
local function GetColorChar(colorTable)
	if colorTable == nil then return string.char(255,255,255,255) end
	local col = {}
	for i=1,4 do
		col[i] = math.ceil((colorTable[i] or 1)*255)
	end
	return string.char(col[4],col[1],col[2],col[3])
end

local function CreateCircle(point)
	circles[#circles + 1] = {
		point = point,
		x = point.x,
		y = point.y,
		z = point.z,
		color = point.color,
		alpha = 0,
		radius = circleRadius,
		time = 0,
	}
end

-- from gfx_commands_fx.lua
local function CircleVertices(circleDivs)
	for i = 1, circleDivs do
		local theta = 2 * math.pi * i / circleDivs
		gl.Vertex(math.cos(theta), math.sin(theta), 0)
	end
end

local function DrawCircle(circle)
	if not Spring.IsSphereInView(circle.x, circle.y, circle.z, circle.radius) then
		return
	end
	gl.PushMatrix()
	gl.Translate(circle.x, circle.y + 10, circle.z)
	gl.Rotate(90, 1, 0, 0)
	gl.Scale(circle.radius, circle.radius, 1)
	gl.Color(circle.color[1], circle.color[2], circle.color[3], circle.alpha)
	gl.CallList(circleDrawList)
	gl.PopMatrix()
end

----------------------------------------------------------------
--callins
----------------------------------------------------------------

function widget:Initialize()
	timeNow = nil
	timePart = nil
	
	Lups = WG.Lups
	
	WG.CustomMarker = {
		AddPoint = AddPoint,
		RemovePoint = RemovePoint,
		ClearPoints = ClearPoints,
		SetUseFade = SetUseFade
	}
	
	circleDrawList = gl.CreateList(gl.BeginEnd, GL.LINE_LOOP, CircleVertices, 48)
	
	-- debug
	--WG.CustomMarker.AddPoint("newPoint", Game.mapSizeX/2, Game.mapSizeZ/2, "Custom marker", {0, 1, 0.5, 1})
end

function widget:Shutdown()
	ClearPoints()
	WG.CustomMarker = nil
	gl.DeleteList(circleDrawList)
end

function widget:GameFrame(f)
	if Lups and f%10 == 0 then
		local wx, wy, wz = Spring.GetWind()
		wx, wy, wz = wx*0.05, wy*0.05, wz*0.05
		smokeFX.force = {wx,wy+2,wz}
		for id,point in pairs(mapPoints) do
			local color = point.color
			smokeFX.pos     = {point.x, point.y, point.z}
			smokeFX.partpos = "r*sin(alpha),0,r*cos(alpha) | alpha=rand()*2*pi, r=rand()*20"
			smokeFX.colormap[2] = { color[1], color[2], color[3], smokeFX.colormap[2][4]}
			smokeFX.colormap[3] = { color[1], color[2], color[3], smokeFX.colormap[3][4]}
			smokeFX.texture = "bitmaps/smoke/smoke0" .. math.random(1,9) .. ".tga"
			Lups.AddParticles('SimpleParticles2',smokeFX)
		end
	end
end

function widget:DrawWorldPreUnit()
	glLineWidth(4)
	gl.DepthTest(false)
	--gl.LineStipple(true)
	for i=1,#circles do
		local circle = circles[i]
		DrawCircle(circle)
	end
	glLineWidth(1)
	gl.DepthTest(true)
	gl.Color(1,1,1,1)
	--gl.LineStipple(false)
end

function widget:DrawScreen()
	if (not on) then return end
	
	glLineWidth(lineWidth)
	
	for id,point in pairs(mapPoints) do
		local alpha = maxAlpha * (point.expiration - timeNow) / ttl
		if (alpha <= 0) then
			mapPoints[id] = nil
		else
			local sx, sy, sz = WorldToScreenCoords(point.x, point.y, point.z)
			glColor(point.color[1], point.color[2], point.color[3], alpha)
			if (sx >= 0 and sy >= 0
					and sx <= vsx and sy <= vsy) then
				--in screen
				--[[
				local vertices = {
					{v = {sx, sy - highlightLineMin, 0}},
					{v = {sx, sy - highlightLineMax, 0}},
					{v = {sx, sy + highlightLineMin, 0}},
					{v = {sx, sy + highlightLineMax, 0}},
					{v = {sx - highlightLineMin, sy, 0}},
					{v = {sx - highlightLineMax, sy, 0}},
					{v = {sx + highlightLineMin, sy, 0}},
					{v = {sx + highlightLineMax, sy, 0}},
				}
				glPolygonMode(GL_FRONT_AND_BACK, GL_LINE)
				glRect(sx - highlightSize, sy - highlightSize, sx + highlightSize, sy + highlightSize)
				glShape(GL_LINES, vertices)
				glPolygonMode(GL_FRONT_AND_BACK, GL_FILL)
				]]
				if point.text then
					glText(GetColorChar(point.color)..point.text.."\008", sx, sy + 16, fontSizeLarge, 'cno')
				end
			else
				--out of screen
				glPolygonMode(GL_FRONT_AND_BACK, GL_FILL)
				--flip if behind screen
				if (sz > 1) then
					sx = sMidX - sx
					sy = sMidY - sy
				end
				local xRatio = sMidX / abs(sx - sMidX)
				local yRatio = sMidY / abs(sy - sMidY)
				local edgeDist, vertices, textX, textY, textOptions
				if (xRatio < yRatio) then
					edgeDist = (sy - sMidY) * xRatio + sMidY
					if (sx > 0) then
						vertices = {
							{v = {vsx, edgeDist, 0}},
							{v = {vsx - edgeMarkerSize, edgeDist + edgeMarkerSize, 0}},
							{v = {vsx - edgeMarkerSize, edgeDist - edgeMarkerSize, 0}},
						}
						textX = vsx - edgeMarkerSize
						textY = edgeDist - fontSize * 0.5
						textOptions = "rn"
					else
						vertices = {
							{v = {0, edgeDist, 0}},
							{v = {edgeMarkerSize, edgeDist - edgeMarkerSize, 0}},
							{v = {edgeMarkerSize, edgeDist + edgeMarkerSize, 0}},
						}
						textX = edgeMarkerSize
						textY = edgeDist - fontSize * 0.5
						textOptions = "n"
					end
				else
					edgeDist = (sx - sMidX) * yRatio + sMidX
					if (sy > 0) then
						vertices = {
							{v = {edgeDist, vsy, 0}},
							{v = {edgeDist - edgeMarkerSize, vsy - edgeMarkerSize, 0}},
							{v = {edgeDist + edgeMarkerSize, vsy - edgeMarkerSize, 0}},
						}
						textX = edgeDist
						textY = vsy - edgeMarkerSize - fontSize
						textOptions = "cn"
					else
						vertices = {
							{v = {edgeDist, 0, 0}},
							{v = {edgeDist + edgeMarkerSize, edgeMarkerSize, 0}},
							{v = {edgeDist - edgeMarkerSize, edgeMarkerSize, 0}},
						}
						textX = edgeDist
						textY = edgeMarkerSize
						textOptions = "cn"
					end
				end
				glShape(GL_TRIANGLES, vertices)
				if point.text then
					glText(GetColorChar(point.color)..point.text.."\008", textX, textY, fontSize, textOptions .. 'o')
				end
			end
		end
	end
	
	glColor(1, 1, 1)
	glLineWidth(1)
	glPolygonMode(GL_FRONT_AND_BACK, GL_FILL)
end

function widget:ViewResize(viewSizeX, viewSizeY)
	vsx = viewSizeX
	vsy = viewSizeY
	sMidX = viewSizeX * 0.5
	sMidY = viewSizeY * 0.5
end

local ringPeriod = 0
local ringUpdatePeriod = 0
function widget:Update(dt)
	if (not timeNow) then
		StartTime()
	else
		if useFade then
			timeNow = timeNow + dt
		end
		timePart = timePart + dt
		if (timePart > blinkPeriod and blinkPeriod > 0) then
			timePart = timePart - blinkPeriod
			on = not on
		end
	end
	
	ringPeriod = ringPeriod + dt
	if ringPeriod > circleFreq then
		for id, point in pairs(mapPoints) do
			CreateCircle(point)	
		end
		ringPeriod = 0
	end
	
	ringUpdatePeriod = ringUpdatePeriod + dt
	if ringUpdatePeriod > circleUpdateFreq then
		local notRemoved = {}
		local delta = ringUpdatePeriod/circleTTL
		for i=1,#circles do
			local circle = circles[i]
			local age = circle.time / circleTTL
			if age > 1 then
				
			else
				circle.time = circle.time + ringUpdatePeriod
				circle.radius = circleRadius - (circleRadius - circleRadiusMin) * age
				local alphaMult = 0.5 - math.abs(0.5 - age)
				circle.alpha = circleAlpha * alphaMult * 2
				notRemoved[#notRemoved + 1] = circle
			end
			
		end
		circles = notRemoved
		ringUpdatePeriod = 0
	end
end

function widget:DrawInMiniMap(sx, sy)
	if (not on) then return end
	glLineWidth(lineWidth)
	
	local ratioX = sx / mapX
	local ratioY = sy / mapY
	
	for id,point in pairs(mapPoints) do
		local alpha = maxAlpha * (point.expiration - timeNow) / ttl
		if (alpha <= 0) then
			mapPoints[id] = nil
		else
			local x = point.x * ratioX
			local y = sy - point.z * ratioY
			glColor(point.color[1], point.color[2], point.color[3], alpha)
			local vertices = {
					{v = {x, y - minimapHighlightLineMin, 0}},
					{v = {x, y - minimapHighlightLineMax, 0}},
					{v = {x, y + minimapHighlightLineMin, 0}},
					{v = {x, y + minimapHighlightLineMax, 0}},
					{v = {x - minimapHighlightLineMin, y, 0}},
					{v = {x - minimapHighlightLineMax, y, 0}},
					{v = {x + minimapHighlightLineMin, y, 0}},
					{v = {x + minimapHighlightLineMax, y, 0}},
				}
				glPolygonMode(GL_FRONT_AND_BACK, GL_LINE)
				glRect(x - minimapHighlightSize, y - minimapHighlightSize, x + minimapHighlightSize, y + minimapHighlightSize)
				glShape(GL_LINES, vertices)
		end
	end
	
	glColor(1, 1, 1)
	glLineWidth(1)
	glPolygonMode(GL_FRONT_AND_BACK, GL_FILL)
end
