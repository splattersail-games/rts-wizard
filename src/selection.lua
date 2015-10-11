

Selection = class('Selection')

function Selection:initialize()
	self.selected = {}
	self.selected.primarySelection = nil
	self.selected.size = 0
end

function Selection:add(objId)
	if not self.selected[objId] then
		self.selected[objId] = true
		self.selected.size = self.selected.size + 1
	end
	if not self.selected.primarySelection then
		self.selected.primarySelection = objId
	end
end

-- If multiple units are selected, one is considered the primary
-- The primary should be able to be changed by pressing tab
function Selection:getPrimarySelected()
	return self.selected.primarySelection
end

function Selection:addSelection(selection)
	if not selection.selected.size == 0 then 
		return
	end
	for key, value in pairs(selection.selected) do --pseudocode
    	if value then
			self:add(key)
		end
	end

	print("The selection now has " .. self.selected.size .. " objects")
end

function Selection:deselect(objects)
	self.selected.size = 0
	for gameObj = 0, (objects.size-1) do
		self.selected[gameObj] = false
	end
	if not self.selected[self.selected.primarySelection] then
		self.selected.primarySelection = nil
	end
end

CGSelection = class('CGSelection', Selection)

function CGSelection:initialize()
	Selection.initialize(self)
	self.lastControlGroup = -1 -- if the same control group is pressed more than once in quick succession, center on screen
	self.controlGroups = {}
end

function Selection:createControlGroup(ctrlGrp)
	local toAdd = Selection:new()
	toAdd:addSelection(self)
	self.controlGroups[ctrlGrp] = toAdd
	print("added control group " .. ctrlGrp .. ". It contains " .. self.controlGroups[ctrlGrp].selected.size .. " objects")
end

function Selection:addToControlGroup(ctrlGrp)
	if not self.controlGroups[ctrlGrp] then
		self:createControlGroup(ctrlGrp)
	else
	   	self.controlGroups[ctrlGrp]:addSelection(self)
	end
end

function Selection:recallControlGroup(ctrlGrp)
	if not self.controlGroups[ctrlGrp] then
		return false
	end
	if self.selected == self.controlGroups[ctrlGrp].selected then
		Game:centerOnSelected()
	end
	self.selected = {}
	self.lastControlGroup = ctrlGrp
	for k, v in pairs(self.controlGroups[ctrlGrp].selected) do
		self.selected[k] = v
	end

	return self.selected.size > 0
end