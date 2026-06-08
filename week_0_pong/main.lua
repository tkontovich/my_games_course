push = require 'push'

Class = require 'class'

require 'Paddle'

require 'Ball'

-- set paddle size
PADDLE_WIDTH = 5
PADDLE_HEIGHT = 20

-- set ball size
BALL_WIDTH = 4
BALL_HEIGHT = 4

-- set paddle speed
PADDLE_SPEED = 200

-- window size settings
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720
VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    love.window.setTitle('Fuck you')

    largeFont = love.graphics.newFont('font.ttf', 32)
    smallFont = love.graphics.newFont('font.ttf', 8)

    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
        resizable = false,
        vsync = true, 
        fullscreen = false
    })

    push.setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, {
        upscale = 'normal'
    })

    -- "seed" the RNG so that calls to random are always random
    math.randomseed(os.time())

    -- initialize scores
    player1Score = 0
    player2Score = 0
    
    -- initialize player paddles
    player1 = Paddle(10, 30, PADDLE_WIDTH, PADDLE_HEIGHT)
    player2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 30 - PADDLE_HEIGHT, PADDLE_WIDTH, PADDLE_HEIGHT)

    -- initialize ball
    ball = Ball(VIRTUAL_WIDTH / 2-2, VIRTUAL_HEIGHT / 2 - 2, BALL_WIDTH, BALL_HEIGHT)

    -- game state variable
    gameState = 'start'
end

function love.update(dt)
    -- player 1 movement
    if love.keyboard.isDown('w') then
        player1.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('s') then
        player1.dy = PADDLE_SPEED
    else
        player1.dy = 0
    end

    -- player 2 movement
    if love.keyboard.isDown('up') then
        player2.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('down') then
        player2.dy = PADDLE_SPEED
    else
        player2.dy = 0
    end

    -- ball movement
    if gameState == 'play' then
        ball:update(dt)
    end

    player1:update(dt)
    player2:update(dt)
end

function love.keypressed(key)
    -- quit game when escape is pressed
    if key == 'escape' then
        love.event.quit()
    elseif key == 'enter' or key == 'return' then
        if gameState == 'start' then
            gameState = 'play'
        else
            gameState = 'start'

            -- reset ball position
            ball:reset()
        end
    end
end

function love.draw()
    push.start()

    -- set background color and font
    love.graphics.clear(40/255, 45/255, 52/255, 1)
    love.graphics.setFont(largeFont)
    love.graphics.setColor(1, 1, 1, 1)

    if gameState == 'start' then
        love.graphics.printf('Hello Start State!', 0, 20, VIRTUAL_WIDTH, 'center')
    else
        love.graphics.printf('Hello Play State!', 0, 20, VIRTUAL_WIDTH, 'center')
    end

    --render paddles
    player1:render()
    player2:render()

    --render ball
    ball:render()

    displayFPS()

    push.finish()
end

function displayFPS()
    -- simple FPS display across all states
    love.graphics.setFont(smallFont)
    love.graphics.setColor(0, 255/255, 0, 255/255)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)
end
