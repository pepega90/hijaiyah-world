function Kotak(text, width, height, x, y)
    return {
        text = text,
        width = width,
        height = height,
        x = x,
        y = y,
        state = 3, -- Default state (3 = white)
        matchedHuruf = nil, -- Reference to the matched Huruf (if any)

        show = function(self)
            -- Display the rectangle and text
            local rect = display.newRoundedRect(self.x, self.y, self.width, self.height, 8)
            rect.strokeWidth = 2
            rect:setStrokeColor(1, 1, 0) -- Yellow border
            rect:setFillColor(1, 1, 1) -- Default white background
            
            -- Store the rect in the object for later use
            self.rect = rect

            local textDisplay = display.newText(self.text, self.x, self.y - 40, game_font, 20)
            textDisplay:setFillColor(0, 0, 0)
        end,

        -- Function to set color based on state
        setColor = function(self, newState)
            self.state = newState
            if self.state == 1 then
                self.rect:setFillColor(0, 1, 0) -- Green
            elseif self.state == 2 then
                self.rect:setFillColor(1, 0, 0) -- Red
            else
                self.rect:setFillColor(1, 1, 1) -- White
                self.matchedHuruf = nil -- Reset matched Huruf
            end
        end
    }
end