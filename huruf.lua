function Huruf(image, text, width, height, x, y)
    return {
        image = image,
        text = text,
        width = width,
        height = height,
        x = x,
        y = y,

        show = function(self,  kotakList)
            -- Create the image
            local rect = display.newImageRect(self.image, self.width, self.height)
            rect.x = self.x
            rect.y = self.y

            -- Store the rect in the object for later use
            self.rect = rect

            -- Add drag-and-drop functionality
            local function onTouch(event)
                if event.phase == "began" then
                    -- Bring the object to the front
                    display.currentStage:setFocus(rect)
                    rect.isFocus = true

                    -- Reset the matched kotak for this Huruf
                    for _, kotak in ipairs(kotakList) do
                        if kotak.matchedHuruf == self then
                            kotak:setColor(3) -- Reset to white
                        end
                    end

                elseif event.phase == "moved" and rect.isFocus then
                    -- Move the object with the touch
                    rect.x = event.x
                    rect.y = event.y

                elseif event.phase == "ended" or event.phase == "cancelled" then
                    if rect.isFocus then
                        -- Reset focus
                        display.currentStage:setFocus(nil)
                        rect.isFocus = nil

                        -- Check if the object is dropped on any kotak
                        local foundKotak = false
                        for _, kotak in ipairs(kotakList) do
                            if math.abs(rect.x - kotak.x) < kotak.width / 2 and math.abs(rect.y - kotak.y) < kotak.height / 2 then
                                -- Check if text matches
                                if self.text == kotak.text then
                                    kotak:setColor(1) -- Set to green
                                    kotak.matchedHuruf = self -- Link this Huruf to the Kotak
                                elseif self.text ~= kotak.text then
                                    kotak:setColor(2) -- Set to red
                                    kotak.matchedHuruf = self
                                end
                                foundKotak = true
                                break
                            end
                        end

                        -- Reset any kotak that no longer has a matching huruf
                        for _, kotak in ipairs(kotakList) do
                            if kotak.matchedHuruf == nil then
                                kotak:setColor(3) -- Reset to white
                            end
                        end

                        -- If no kotak is matched, ensure all kotak remain in the correct state
                        if not foundKotak then
                            for _, kotak in ipairs(kotakList) do
                                if kotak.matchedHuruf == nil then
                                    kotak:setColor(3) -- Reset to white
                                end
                            end
                        end
                    end
                end
            end

            rect:addEventListener("touch", onTouch)
        end
    }
end