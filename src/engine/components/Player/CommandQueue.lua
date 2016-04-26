CommandQueue = Component.create("CommandQueue")

function CommandQueue:initialize()
    self.queue = Queue.new()
end