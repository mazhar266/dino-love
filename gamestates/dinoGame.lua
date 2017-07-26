bump      = require("libs.bump.bump")
Gamestate = require("libs.hump.gamestate")
local Entities = require("entities.Entities")
local Entity   = require("entities.Entity")

-- Create our Gamestate
local dinoGame = {}

-- Import needed entities
local Dino    = require("entities.dino")
local Ground  = require("entities.ground")
local Barrier = require("entities.barrier")

-- Global vars
dino = nil
ground = nil

function dinoGame:enter()
  -- We need collisions
  self.world = bump.newWorld(16)

  -- Initialize our Entity System
  Entities:enter(world)
  local gWidth, gHeight = love.graphics.getWidth(), 30
  local gX, gY          = 0, love.graphics.getHeight() - gHeight
  ground = Ground(self.world, gX, gY, gWidth, gHeight)
  local dWidth, dHeight = 30, 60
  local dX, dY          = 20, gY - dHeight
  dino = Dino(self.world, dX, dY, dWidth, dHeight)

  -- Initialize some useful vars
  self.groundY = gY

  -- Add dino and ground
  Entities:addMany({dino, ground})

  Entities:getFirstBarrier()
end

function dinoGame:update(dt)
  self:shouldAddBarrier()
  Entities:update(dt)
end

-- This function adds a barrier (if we should)
function dinoGame:shouldAddBarrier()
  lastBarrier = Entities:getLastBarrier()

  -- Add barrier if last barrier is a certain distance from right edge, or
  -- if there are no current barriers.
  if lastBarrier then
    fromEdgeDist = love.graphics.getWidth() - lastBarrier:rightPos()
    if fromEdgeDist > 100 then -- TODO: constant
      self:addBarrier()
    end
  else
    self:addBarrier()
  end
end

-- This function adds a new barrier
function dinoGame:addBarrier()
  local bWidth, bHeight = 30, 60
  newBarrier = Barrier(self.world, love.graphics.getWidth(), self.groundY - bHeight, bWidth, bHeight)
  Entities:add(newBarrier)
end

function dinoGame:draw()
  Entities:draw()
end

function dinoGame:keypressed(key)
  if key == "up" then
    dino:setDirection(dino:keyToDir(key))
  elseif key == "down" then
    dino:setDirection(dino:keyToDir("duck"))
  end
end

function dinoGame:keyreleased(key)
  if key == "up" then
    dino:setDirection(dino:keyToDir("down"))
  elseif key == "down" then
    dino:setDirection(dino:keyToDir("still"))
  end
end

return dinoGame