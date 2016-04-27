local quadtree = {}
quadtree.__index = quadtree
local xtable = {}
local ytable = {}
local wtable = {}
local htable = {}
local node = {}
local objectT = {
  xtable,
  ytable,
  wtable,
  htable,
  node,
}

-- new quadtree
local function new (self, x0, y0, w, h, capacity, maxlevel)
  local newlevel
  if self._level then
    newlevel = self._level + 1
  else
    newlevel = 1
  end
  local node = {
    _x0 = x0,
    _y0 = y0,
    _w = w,
    _h = h,
    _obj = {},
    _capacity = capacity or self._capacity or 4,
    _amtObj = 0,
    _maxlevel = maxlevel or self._maxlevel or 4,
    _level = newlevel
  }
  return setmetatable(node,quadtree)
end

-- each node has subnodes at index 1-4
local function createSubNodes (self)
  local x0 = self._x0
  local y0 = self._y0
  local w = self._w/2
  local h = self._h/2
  self[1] = self:new (x0 + w,y0 + h,w,h)
  self[2] = self:new (x0 ,y0 + h,w,h)
  self[3] = self:new (x0 ,y0 ,w,h)
  self[4] = self:new (x0 + w,y0 ,w,h)
end

-- level starts at 1
local function checkMaxLevel(node)
  if node._level >= node._maxlevel then
    return true
  end
end

local function checkIfFull (node)
  if node._amtObj >= node._capacity then
    return true
  end
end

local function returnSidesCoord (node,id)
  local ox1 = objectT[1][id]
  local oy1 = objectT[2][id]
  local ox2 = objectT[3][id] + ox1
  local oy2 = objectT[4][id] + oy1
  local nx1 = node._x0
  local ny1 = node._y0
  local nx2 = node._w + nx1
  local ny2 = node._h + ny1
  return ox1,oy1,ox2,oy2,nx1,ny1,nx2,ny2
end

local function checkIfBounded (node,id)
  local ox1,oy1,ox2,oy2,nx1,ny1,nx2,ny2 = returnSidesCoord(node,id)
  return ox1 >= nx1 and ox2 <= nx2 and oy1 >= ny1 and oy2 <= ny2
end

local function checkIfOverlap(node,id)
  local ox1,oy1,ox2,oy2,nx1,ny1,nx2,ny2 = returnSidesCoord(node,id)
  return ox1 < nx2 and ox2 > nx1 and oy1 < ny2 and oy2 > ny1
end

local function findEnclosingSubNode (self,id)
  local subnode
  for node = 1,4 do
    subnode = self[node]
    if checkIfBounded(subnode,id) then return subnode end
  end
end

-- find biggest available node or smallest node if all nodes are full
-- respects max level
local function findNodeForObj (self,id)
  local node = self
  -- don't move to subnode if conditions aren't satisfied
  if checkIfFull(node) and not checkMaxLevel(node) then
    if not node[1] then createSubNodes(node) end
    local subnode = findEnclosingSubNode(node,id)
    if subnode then
      node = findNodeForObj(subnode,id)
    end
  end
  return node
end

local function checkNodeOverlap (self,id)
  local nodeCollided = checkIfOverlap(self,id)
  if nodeCollided then
    return true
  end
end

-- recurse into all overlappable child nodes
local function findAllOverlap (self,id,count,nodelist)
  if checkNodeOverlap(self,id) then
    count = count + 1
    nodelist[count] = self
    if self[1] then
      for i = 1,4 do
        nodelist, count = findAllOverlap(self[i],id,count,nodelist)
      end
    end
  end
  return nodelist, count
end

local function reinsertObj(self,id)
  local newNode = findNodeForObj(self,id)
  newNode._obj[id] = true
  newNode._amtObj = newNode._amtObj + 1
  objectT[5][id] = newNode
end

local function updateNodePos (self,id)
  local oldNode = objectT[5][id]
  if checkIfFull(oldNode) or not checkIfBounded(oldNode,id) then
    oldNode._obj[id] = nil
    oldNode._amtObj = oldNode._amtObj - 1
    reinsertObj(self,id)
  end
end

-- public interface --------
local function addObj (self,newId,x0,y0,w,h)
  assert(not objectT[1][newId],'ID is already in use')
  local t = {x0,y0,w,h}
  -- add obj stats to object table
  for i = 1,4 do
    objectT[i][newId] = t[i]
  end
  reinsertObj(self,newId)
end

local function delObj (self,id)
  -- delete obj from node and obj table
  local node = objectT[5][id]
  for i = 1,5 do
    objectT[i][id] = nil
  end
  node._obj[id] = nil
  node._amtObj = node._amtObj - 1
end

local function moveAbs (self,id,xnew,ynew)
  objectT[1][id] = xnew
  objectT[2][id] = ynew
  updateNodePos(self,id)
end

local function moveDelta (self,id,xd,yd)
  objectT[1][id] = objectT[1][id] + xd
  objectT[2][id] = objectT[2][id] + yd
  updateNodePos(self,id)
end

local function queryCollidables (self,id)
  local nodelist = findAllOverlap(self,id,0,{})
  local objectlist = {}
  local count = 0
  local idNode = objectT[5][id]
  idNode._obj[id] = nil
  for _,node in pairs(nodelist) do
    for obj,_ in pairs(node._obj) do
      count = count + 1
      objectlist[count] = obj
    end
  end
  idNode._obj[id] = true
  return objectlist
end

-- return list of occupied nodes
local function queryNodes (self)
  local function recursive (node,count,list)
    if node._amtObj > 0 then
      count = count + 1
      list[count] = node
    end
    if node[1] then
      for i = 1,4 do
        list,count = recursive(node[i],count,list)
      end
    end
    return list,count
  end
  return recursive(self,0,{})
end

quadtree.new = new
quadtree.addObj = addObj
quadtree.delObj = delObj
quadtree.moveAbs = moveAbs
quadtree.moveDelta = moveDelta
quadtree.queryCollidables = queryCollidables
quadtree.queryNodes = queryNodes
-----------------------------
return quadtree
