ScoutHST = class(Module)

function ScoutHST:Name()
	return "ScoutHST"
end

function ScoutHST:internalName()
	return "scouthst"
end

function ScoutHST:Init()
	self.DebugEnabled = true
	self.spotsToScout = {}
	self.lastCount = {}
	self.sameCount = {}
	self.usingStarts = {}
	self.scouts = {}
	self.SCOUTED = {}
	self.perimetralCells = {}
	self:PerimetralCells()
end

function ScoutHST:ScoutTargetAlreadyHandled(X,Z,refScout)
	for id, scout in pairs(self.scouts) do
		if scout.target then
			local scoutX,scoutZ = self.ai.maphst:PosToGrid(scout.target)
			if scoutX == X and scoutZ == Z and refScout ~= id then
				return id
			end
		end
	end
end

function ScoutHST:PerimetralCells()
	for X,cells in pairs(self.ai.maphst.GRID) do
		for Z,cell in pairs(cells) do
			if X == 1 or Z == 1 or X == self.ai.maphst.gridSideX or Z == self.ai.maphst.gridSideZ then
				table.insert(self.perimetralCells,cell.POS)
			end
		end
	end
end

function ScoutHST:ClosestSpot2(scoutbst)
	self:EchoDebug('closestSpot2')
	local scout = scoutbst.unit:Internal()
	local scoutPos = scout:GetPosition()
	local mtype = scoutbst.mtype
	local network = scoutbst.network
	mtype = mtype or 'air'--CAUTION
	network = network or 1--CAUTION
	local networkSpots = self.ai.maphst.networks[mtype][network].allSpots
	local bestPos = nil
	local bestIndex = nil
	local bestDistance = 0
	local spot = networkSpots[math.random(1,#networkSpots)]
	if self.ai.maphst:UnitCanGoHere(scout,spot) then
		local X,Z = self.ai.maphst:PosToGrid(spot)
		if self:TargetAvailable(X,Z,scoutbst.id) then
			bestPos = spot
		end
	end

-- 	for index,spot in pairs(networkSpots) do
--
-- 		if self.ai.maphst:UnitCanGoHere(scout,spot) then
-- 			local X,Z = self.ai.maphst:PosToGrid(spot)
-- 			if self:TargetAvailable(X,Z,scoutbst.id) then
-- 				local d = self.ai.tool:distance(scoutPos,spot)
-- 				if d > bestDistance then
-- 					bestPos = spot
-- 					bestIndex = index
-- 					bestDistance = d
-- 				end
-- 			end
--
-- 		end
-- 	end
	self:EchoDebug('bestpos', bestPos, 'bestIndex',bestIndex)
	if not bestPos then
		local randomPerimeter = self.perimetralCells[math.random(1,#self.perimetralCells)]
		if self.ai.maphst:UnitCanGoHere(scout,randomPerimeter) then
			bestPos = randomPerimeter
		end
	end
	return bestPos
end

function ScoutHST:TargetAvailable(X,Z,scoutID)
	if self.SCOUTED[X] and self.SCOUTED[X][Z] then
		self:EchoDebug('networkSpots', X,Z, 'is in a SCOUTED cell')
	elseif self.ai.loshst.ENEMY[X] and self.ai.loshst.ENEMY[X][Z] then
		self:EchoDebug('networkSpots', X,Z, 'is in a ENEMY cell')
	elseif self.ai.damagehst.DAMAGED[X] and self.ai.damagehst.DAMAGED[X][Z] then
		self:EchoDebug('networkSpots', X,Z, 'is in a DAMAGE cell')
	elseif self.ai.loshst.OWN[X] and self.ai.loshst.OWN[X][Z] then
		self:EchoDebug('networkSpots', X,Z, 'is in a OWN cell')
	elseif self.ai.loshst.ALLY[X] and self.ai.loshst.ALLY[X][Z] then
		self:EchoDebug('networkSpots', X,Z, 'is in a ALLY cell')
	elseif self:ScoutTargetAlreadyHandled(X,Z,scoutID) then
		self:EchoDebug('target already in use by scout',X,Z,'by scout',scoutID)
	else
		self:EchoDebug('target scout ',X,Z,'Available',scoutID)
		return true
	end
end

function ScoutHST:Update()
	if self.ai.schedulerhst.moduleTeam ~= self.ai.id or self.ai.schedulerhst.moduleUpdate ~= self:Name() then return end
	local frame = game:Frame()
	for X, cells in pairs(self.SCOUTED) do
		for Z,cellFrame in pairs(cells) do
			if frame > cellFrame + 3600 then
				cell = nil
			end
		end
	end
end
