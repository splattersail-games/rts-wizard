Menu = {}
Menu.current = nil

Menu.available = {}
Menu.selectSound = nil
Menu.backSound = nil

function string.ends(String,End)
   return End=='' or string.sub(String,-string.len(End))==End
end

function Menu:load() 
	sfx = love.audio.newSource("resources/sounds/music/silly.wav", "static")
	--love.audio.play(sfx)
	Menu.selectSound = love.audio.newSource("resources/sounds/derp.wav", "static")
	Menu.backSound = love.audio.newSource("resources/sounds/menu_back.wav", "static")

	Menu.list = List:new()
    Menu.smallfont = love.graphics.newFont(love._vera_ttf,12)
    Menu.bigfont = love.graphics.newFont(love._vera_ttf, 40)
    Menu.list.font = Menu.smallfont

    love.graphics.draw(resources.UI.textbox)

    -- Find available demos.
    local files =  love.filesystem.getDirectoryItems("src/levels")
	local n = 0

    for i, v in ipairs(files) do
		if string.ends(v, "json") then
			n = n + 1
			table.insert(Menu.available, v);
		    local file = love.filesystem.newFile(v, love.file_read)
		    local title = Menu.getn(n) .. " " .. v
		    Menu.list:add(title, v)
		end
    end

    Menu.list:done()
    Menu.resume()
end

function Menu.empty() end

function Menu.update(dt)
    Menu.list:update(dt)
end

function Menu.draw()
	love.graphics.setColor(48, 48, 48)
	love.graphics.rectangle("fill", 0, 0, love.window.getWidth(), love.window.getHeight())

    love.graphics.setColor(255, 255, 255, 191)
    love.graphics.setFont(Menu.bigfont)
    love.graphics.print("Levels:", 50, 50)

    love.graphics.setFont(Menu.smallfont)
    love.graphics.print("Browse and click on the level you \nwant to run. To return the the level \nselection screen, press escape.", 500, 80)

    Menu.list:draw()
	love.graphics.setColor(255, 255, 255)
end

function Menu.keypressed(k)
end

function Menu.keyreleased(k)
end

function Menu.mousepressed(x, y, b)
    Menu.list:mousepressed(x, y, b)
end

function Menu.mousereleased(x, y, b)
    Menu.list:mousereleased(x, y, b)
end

function Menu.getn(n)
    local s = ""
    n = tonumber(n)
    local r = n
    if r <= 0 then error("Example IDs must be bigger than 0. (Got: " .. r .. ")") end
    if r >= 10000 then error("Example IDs must be less than 10000. (Got: " .. r .. ")") end
    while r < 1000 do
        s = s .. "0"
        r = r * 10
    end
    s = s .. n
    return s
end

function Menu.intable(t, e)
    for k, v in ipairs(t) do
        if v == e then return true end
    end
    return false
end

function Menu.start(item, file)
	local e_id = string.sub(item, 1, 4)
	local e_rest = string.sub(item, 5)
	local unused1, unused2, n = string.find(item, "(%s)%.json")

	if Menu.intable(Menu.available, file) then
		if not love.filesystem.exists("src/levels/" .. file) then
			print("Could not load level .. " .. file)
		else

		-- Clear all callbacks.
		love.load = Menu.empty
		love.update = Menu.empty
		love.draw = Menu.empty
		love.keypressed = Menu.empty
		love.keyreleased = Menu.empty
		love.mousepressed = Menu.empty
		love.mousereleased = Menu.empty

		world = love.filesystem.read("src/levels/" .. file)
		love.audio.play(Menu.selectSound)
		Menu.clear()
		Game:init(world)

		--love.window.setTitle(e_rest)

		-- Redirect keypress
		local o_keypressed = love.keypressed
		love.keypressed =
		function(k)
			if k == "escape" then
				Game:unload()
				love.audio.play(Menu.backSound)
				Menu.resume()
			end
			o_keypressed(k)
		end

		love.load()
		end
	else
		print("Example ".. e_id .. " does not exist.")
	end
end

function Menu.clear()
    love.graphics.setBackgroundColor(0,0,0)
    love.graphics.setColor(255, 255, 255)
	love.graphics.setLineWidth(1)
	love.graphics.setLineStyle("smooth")
    --love.graphics.setLine(1, "smooth")
    --love.graphics.setColorMode("replace")
    love.graphics.setBlendMode("alpha")
    love.mouse.setVisible(true)
end

function Menu.resume()
    load = nil
    love.update = Menu.update
    love.draw = Menu.draw
    love.keypressed = Menu.keypressed
    love.keyreleased = Menu.keyreleased
    love.mousepressed = Menu.mousepressed
    love.mousereleased = Menu.mousereleased

    love.mouse.setVisible(true)
    love.window.setTitle("Swag")
end

function inside(mx, my, x, y, w, h)
    return mx >= x and mx <= (x+w) and my >= y and my <= (y+h)
end



----------------------
-- List object
----------------------

List = {}

function List:new()
    o = {}
    setmetatable(o, self)
    self.__index = self

    o.items = {}
	o.files = {}

    o.x = 50
    o.y = 70

    o.width = 400
    o.height = 500

    o.item_height = 23
    o.sum_item_height = 0

    o.bar_size = 20
    o.bar_pos = 0
    o.bar_max_pos = 0
    o.bar_width = 15
    o.bar_lock = nil

    return o
end

function List:add(item, file)
	table.insert(self.items, item)
	table.insert(self.files, file)
end

function List:done()
    self.items.n = #self.items

    -- Recalc bar size.
    self.bar_pos = 0

    local num_items = (self.height/self.item_height)
    local ratio = num_items/self.items.n
    self.bar_size = self.height * ratio
    self.bar_max_pos = self.height - self.bar_size - 3

    -- Calculate height of everything.
    self.sum_item_height = (self.item_height+1) * self.items.n + 2
end

function List:hasBar()
    return self.sum_item_height > self.height
end

function List:getBarRatio()
    return self.bar_pos/self.bar_max_pos
end

function List:getOffset()
    local ratio = self.bar_pos/self.bar_max_pos
    return math.floor((self.sum_item_height-self.height)*ratio + 0.5)
end

function List:update(dt)
    if self.bar_lock then
	local dy = math.floor(love.mouse.getY()-self.bar_lock.y+0.5)
	self.bar_pos = self.bar_pos + dy

	if self.bar_pos < 0 then
	    self.bar_pos = 0
	elseif self.bar_pos > self.bar_max_pos then
	   self.bar_pos = self.bar_max_pos
	end

	self.bar_lock.y = love.mouse.getY()

    end
end

function List:mousepressed(mx, my, b)
    if self:hasBar() then
	if b == "l" then
	    local x, y, w, h = self:getBarRect()
	    if inside(mx, my, x, y, w, h) then
		self.bar_lock = { x = mx, y = my }
	    end
	end

	local per_pixel = (self.sum_item_height-self.height)/self.bar_max_pos
	local bar_pixel_dt = math.floor(((self.item_height)*3)/per_pixel + 0.5)

	if b == "wd" then
	    self.bar_pos = self.bar_pos + bar_pixel_dt
	    if self.bar_pos > self.bar_max_pos then self.bar_pos = self.bar_max_pos end
	elseif b == "wu" then
	    self.bar_pos = self.bar_pos - bar_pixel_dt
	    if self.bar_pos < 0 then self.bar_pos = 0 end
	end
    end

    if b == "l" and inside(mx, my, self.x+2, self.y+1, self.width-3, self.height-3) then
	local tx, ty = mx-self.x, my + self:getOffset() - self.y
	local index = math.floor((ty/self.sum_item_height)*self.items.n)
	local i = self.items[index+1]
	local f = self.files[index+1]
	if f then
	    Menu.start(i, f)
	end
    end
end

function List:mousereleased(x, y, b)
    if self:hasBar() then
	if b == "l" then
	    self.bar_lock = nil
	end
    end
end

function List:getBarRect()
    return
	self.x+self.width+2, self.y+1+self.bar_pos,
	self.bar_width-3, self.bar_size
end

function List:getItemRect(i)
	return
	    self.x+2, self.y+((self.item_height+1)*(i-1)+1)-self:getOffset(),
	    self.width-3, self.item_height
end

function List:draw()
    love.graphics.setLineWidth(2)
	love.graphics.setLineStyle("rough")
    love.graphics.setFont(self.font)

    love.graphics.setColor(48, 156, 225)

    local mx, my = love.mouse.getPosition()

    -- Get interval to display.
    local start_i = math.floor( self:getOffset()/(self.item_height+1) ) + 1
    local end_i = start_i+math.floor( self.height/(self.item_height+1) ) + 1
    if end_i > self.items.n then end_i = self.items.n end


    love.graphics.setScissor(self.x, self.y, self.width, self.height)

    -- Items.
    for i = start_i,end_i do
		local x, y, w, h = self:getItemRect(i)
		local hover = inside(mx, my, x, y, w, h)

		if hover then
			love.graphics.setColor(0, 0, 0, 127)
		else
			love.graphics.setColor(0, 0, 0, 63)
		end

		love.graphics.rectangle("fill", x+1, y+i+1, w-3, h)

		if hover then
			love.graphics.setColor(255, 255, 255)
		else
			love.graphics.setColor(255, 255, 255, 127)
		end

		local e_id = string.sub(self.items[i], 1, 5)
		local e_rest = string.sub(self.items[i], 5)

		love.graphics.print(e_id, x+10, y+i+6)  --Updated y placement -- Used to change position of Example IDs
		love.graphics.print(e_rest, x+50, y+i+6) --Updated y placement -- Used to change position of Example Titles
    end

    love.graphics.setScissor()

    -- Bar.
    if self:hasBar() then
	local x, y, w, h = self:getBarRect()
	local hover = inside(mx, my, x, y, w, h)

	if hover or self.bar_lock then
	    love.graphics.setColor(0, 0, 0, 127)
	else
	    love.graphics.setColor(0, 0, 0, 63)
	end
	love.graphics.rectangle("fill", x, y, w, h)
    end

    -- Border.
    love.graphics.setColor(0, 0, 0, 63)
    love.graphics.rectangle("line", self.x+self.width, self.y, self.bar_width, self.height)
    love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
end
