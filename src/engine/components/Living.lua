--[[
Living component, models entity health
]]
Living = Component.create("Living", { "life", "maxLife" }, { life = 1500, maxLife = 1500 })

function Living:initialize(life, maxLife)
    self.life = life
    self.maxLife = maxLife
end

function Living:isAlive()
  return self.life > 0
end

function Living:kill()
  self.life = 0
end