-- Selection box released
QueueCommand = class("QueueCommand", System)

function QueueCommand:fireEvent(evt)
    print("Adding a command to queue")

    if evt ~= nil and evt.rectangle then
        for id, gameObj in pairs(self.targets) do
            local commandQueue = gameObj:get("CommandQueue")

            if (commandQueue) then 
                print("Hello")
            end
        end
    end
end

function QueueCommand:requires()
    return {"PlayerControlled", "CommandQueue"}
end