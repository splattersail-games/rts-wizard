DrawImageSystem = class("DrawImageSystem", System)

function DrawImageSystem:draw()
    love.graphics.setColor(255,255,255)
    for index, entity in pairs(self.targets) do
        local drawableData = entity:get("Drawable")
        local positionData = entity:get("Position")
        if (drawableData and positionData) then
            love.graphics.draw(
                drawableData.image,
                positionData.x,
                positionData.y,
                drawableData.r,
                drawableData.sx,
                drawableData.sy,
                drawableData.ox,
                drawableData.oy 
            )
        end
    end
end

function DrawImageSystem:requires()
    return {"Drawable", "Position"}
end