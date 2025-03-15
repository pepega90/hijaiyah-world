
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------




-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
    game_font = "./assets/MouseMemoirs-Regular.ttf"

    bg = display.newImageRect(sceneGroup,"assets/template/menu.png",display.actualContentWidth, display.actualContentHeight + 100);
    bg.x = display.contentCenterX
    bg.y = display.contentCenterY
	
	title_text = display.newText(sceneGroup,"Hijaiyah World", 347, 50, game_font, 60)
	title_text:setFillColor(1,1,0)

	play_text = display.newText(sceneGroup,"Play", 347, 145, game_font, 35)
	play_text:setFillColor(0,0,0)

	local function goto_game(event) 
		if event.phase == "ended" then
			composer.gotoScene("game",{ effect = "fade", time = 500 });
		end
	end

	play_text:addEventListener("touch", goto_game)

	credit_text = display.newText(sceneGroup,"created by aji mustofa @pepega90", 10, 265, game_font, 20)
	credit_text:setFillColor(0,0,0)

end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
		-- helper untuk menampilkan posisi cursor
		local function PositionCursor()
			-- Create a text object for displaying coordinates
			local positionText = display.newText(
				"X: 0, Y: 0", -- Initial text
				display.contentCenterX, -- Starting X position
				display.contentCenterY, -- Starting Y position
				native.systemFont, -- Font
				20 -- Font size
			)
			positionText:setFillColor(0,0,0) -- Set text color (white)

			-- Create a visual marker (circle) for the cursor

			-- Function to update position on screen
			local function updateCursor(event)
				-- Update text position and content
				positionText.x = event.x + 50 -- Offset text to avoid overlap with cursor
				positionText.y = event.y
				positionText.text = "X: " .. math.floor(event.x) .. ", Y: " .. math.floor(event.y)
			end

			-- Add a Runtime listener to track touch or mouse movement
			Runtime:addEventListener("mouse", updateCursor)
		end

		-- Call the PositionCursor function to enable the helper
		-- PositionCursor()

	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen

	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view

end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene
