local composer = require("composer")
local scene = composer.newScene()

-- Require modules
local kotak = require("kotak")
local huruf = require("huruf")

-- Local variables for this scene
local game_font, bg, score_text, nextButton, restartButton
local hurufList, choice, kotak_list, gap = 20
local get_scored = false
local score = 0

-- -----------------------------------------------------------------------------------
-- Helper functions
-- -----------------------------------------------------------------------------------

local function removeButton(button)
    if button then
        if button.text then
            button.text:removeSelf()
            button.text = nil
        end
        button:removeSelf()
        button = nil
    end
end

local function isHurufInChoice(huruf)
    for _, h in ipairs(choice) do
        if h.text == huruf.text then
            return true
        end
    end
    return false
end

local function loadHurufAssets()
    local hurufList = {}
    local assetPath = "./assets/huruf/"
    local texts = {
        "alif", "ba", "ta", "tsa", "jim", "ha", "kho", "dal", "dzal", "ro",
        "dza", "sin", "syin", "shod", "dhod", "tho", "dho", "ain", "ghoin", "fa",
        "qof", "kaf", "lam", "lam alif", "mim", "nun", "haa", "wau", "hamzah", "ya"
    }

    for i = 1, #texts do
        local fileName = "huruf_" .. i .. ".png"
        local xPos = (i - 1) % 4 * 200 -- Horizontal spacing for 4 items per row
        local yPos = math.floor((i - 1) / 4) * 200 + 200 -- Vertical spacing
        table.insert(hurufList, Huruf(assetPath .. fileName, texts[i], 100, 100, xPos, yPos))
    end

    return hurufList
end

local function checkAllKotak(kotak_list)
    local ht = { green = 0, red = 0 }
    local c = 0
    local cond = 2 -- 0 = semua ijo, 1 = ada yang merah, 2 = belum ada ijo atau pun merah

    for _, kotak in ipairs(kotak_list) do
        if kotak.matchedHuruf ~= nil then
            if kotak.state == 1 then
                ht.green = ht.green + 1
            else
                ht.red = ht.red + 1
            end
            c = c + 1
        end
    end

    if c == 3 and ht.green == 3 and ht.green > ht.red then
        cond = 0
    elseif c == 3 and ht.red > ht.green then
        cond = 1
    end

    return cond
end

local function createButton(text, img, x, y, width, height, callback)
    if (text == "Next" and nextButton) or (text == "Restart" and restartButton) then
        return -- Avoid creating duplicate buttons
    end

    local button = display.newImageRect(img, 80, 80)
    button.x = x
    button.y = y - 30
    local buttonText = display.newText(text, x, y + 25, game_font, 20)
    buttonText:setFillColor(0, 0, 0) -- Black text

    button.text = buttonText
    button:addEventListener("tap", callback)

    if text == "Next" then
        nextButton = button
    elseif text == "Restart" then
        restartButton = button
    end

    return button
end

local function restartGame()
    for _, huruf in ipairs(choice) do
        if huruf.rect then
            huruf.rect:removeSelf()
        end
    end
    for _, kotak in ipairs(kotak_list) do
        if kotak.rect then
            kotak.rect:removeSelf()
        end
    end

    choice = {}
    kotak_list = {}

    for i = 1, 3 do
        local m
        repeat
            m = hurufList[math.random(1, #hurufList)]
        until not isHurufInChoice(m)

        local xPos = i * 200 - 180
        local yPos = 230

        m.x, m.y = xPos, yPos
        local kotak_created = Kotak(m.text, 100, 100, xPos, yPos - 100 - gap)

        table.insert(choice, m)
        table.insert(kotak_list, kotak_created)
    end

    for _, kotak in ipairs(kotak_list) do
        kotak:show()
    end
    for _, huruf in ipairs(choice) do
        huruf:show(kotak_list)
    end

    removeButton(nextButton)
    nextButton = nil
    removeButton(restartButton)
    restartButton = nil
    score = 0
    score_text.text = "Score = " .. score
end

local function nextLevel()
    for _, huruf in ipairs(choice) do
        if huruf.rect then
            huruf.rect:removeSelf()
        end
    end
    for _, kotak in ipairs(kotak_list) do
        if kotak.rect then
            kotak.rect:removeSelf()
        end
    end

    choice = {}
    kotak_list = {}

    for i = 1, 3 do
        local m
        repeat
            m = hurufList[math.random(1, #hurufList)]
        until not isHurufInChoice(m)

        local xPos = i * 200 - 180
        local yPos = 230

        m.x, m.y = xPos, yPos
        local kotak_created = Kotak(m.text, 100, 100, xPos, yPos - 100 - gap)

        table.insert(choice, m)
        table.insert(kotak_list, kotak_created)
    end

    for _, kotak in ipairs(kotak_list) do
        kotak:show()
    end
    for _, huruf in ipairs(choice) do
        huruf:show(kotak_list)
    end

    removeButton(nextButton)
    nextButton = nil
    removeButton(restartButton)
    restartButton = nil
end

local function updateScore()
    score = score + 10
    score_text.text = "Score = " .. score
end

local function gameLoop()
    if checkAllKotak(kotak_list) == 0 then
        if not nextButton then
            nextButton = createButton("Next", "./assets/right.png",
                display.contentCenterX - 20, display.contentHeight - 65, 100, 50, nextLevel)
            updateScore()
        end
        if restartButton then
            removeButton(restartButton)
            restartButton = nil
        end
    elseif checkAllKotak(kotak_list) == 1 then
        if not restartButton then
            restartButton = createButton("Restart", "./assets/restart_btn.png",
                display.contentCenterX - 20, display.contentHeight - 65, 100, 50, restartGame)
        end
        if nextButton then
            removeButton(nextButton)
            nextButton = nil
        end
    end
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

function scene:create(event)
    local sceneGroup = self.view

    -- Initialize game assets
    game_font = "./assets/MouseMemoirs-Regular.ttf"

    -- Create background
    bg = display.newImageRect(sceneGroup, "./assets/template/background_huruf.png",
        display.actualContentWidth, display.actualContentHeight)
    bg.x = display.contentCenterX
    bg.y = display.contentCenterY

    -- Initialize score text
    score_text = display.newText(sceneGroup, "Score = " .. score, -60, 21, game_font, 30)
    score_text:setFillColor(0, 0, 0)

    -- Load huruf assets
    hurufList = loadHurufAssets()
end

function scene:show(event)
    local sceneGroup = self.view
    local phase = event.phase

    if phase == "will" then
        -- Initialize game state
        choice = {}
        kotak_list = {}
        gap = 20

        -- Create initial game elements
        for i = 1, 3 do
            local m
            repeat
                m = hurufList[math.random(1, #hurufList)]
            until not isHurufInChoice(m)

            local xPos = i * 200 - 180
            local yPos = 230

            m.x, m.y = xPos, yPos
            local kotak_created = Kotak(m.text, 100, 100, xPos, yPos - 100 - gap)

            table.insert(choice, m)
            table.insert(kotak_list, kotak_created)
        end

        -- Show elements
        for _, kotak in ipairs(kotak_list) do
            kotak:show()
        end
        for _, huruf in ipairs(choice) do
            huruf:show(kotak_list)
        end
    elseif phase == "did" then
        -- Start game loop
        Runtime:addEventListener("enterFrame", gameLoop)
    end
end

function scene:hide(event)
    local sceneGroup = self.view
    local phase = event.phase

    if phase == "will" then
        -- Clean up runtime listeners
        Runtime:removeEventListener("enterFrame", gameLoop)
    end
end

function scene:destroy(event)
    local sceneGroup = self.view

    -- Clean up remaining objects
    for _, huruf in ipairs(choice) do
        if huruf.rect then huruf.rect:removeSelf() end
    end
    for _, kotak in ipairs(kotak_list) do
        if kotak.rect then kotak.rect:removeSelf() end
    end

    -- Remove buttons
    removeButton(nextButton)
    removeButton(restartButton)
end

-- -----------------------------------------------------------------------------------
-- Scene event listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)
-- -----------------------------------------------------------------------------------

return scene