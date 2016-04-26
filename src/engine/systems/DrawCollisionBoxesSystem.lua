DrawCollisionBoxesSystem = class("DrawCollisionBoxesSystem", System)

function DrawCollisionBoxesSystem:draw()
    love.graphics.setColor(80,255,80)
    for index, entity in pairs(self.targets) do

        box = entity:get("Collidable").AABB
        love.graphics.rectangle(
            'line',
            box.x1,
            box.y1,
            box.x2 - box.x1,
            box.y2 - box.y1
        )
    end
end

function DrawCollisionBoxesSystem:requires()
    return {"Collidable"}
end