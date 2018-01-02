
--Gör en koll om real x oxh real y är utanför "skärmen" och anpassa
--Skapa en karta och gör så den ritas ut istället för prickar.

--Skapa ett spel där man ska matcha en Voronoi mot en annan, där lagret man ändrar är halvtransparent. Generera en grid random med 2 eller fler punkter och sen generera en till som ligger ovanpå. 
--Vinner när de är likadana, Kolla X och Y på punkterna men en liten OK diff.

width, height = love.graphics.getDimensions()
local voronoiCalculate = true
function love.load()
     player1 = {rx = 100, ry = 100, x = 100, y = 100, size = 16, r = 255, g = 0, b = 0, speed = 100}
     player2 = {rx = 500, ry = 500, x = 500, y = 500, size = 16, r = 0, g = 0, b = 255, speed = 100}
     player3 = {rx = 800, ry = 100, x = 800, y = 100, size = 16, r = 0, g = 255, b = 0, speed = 100}
end

function love.update(dt)
    if love.keyboard.isDown('w') then
        player1.ry = player1.ry - player1.speed*dt
    elseif love.keyboard.isDown('a') then
        player1.rx = player1.rx - player1.speed*dt
    elseif love.keyboard.isDown('s') then
        player1.ry = player1.ry + player1.speed*dt
    elseif love.keyboard.isDown('d') then
        player1.rx = player1.rx + player1.speed*dt
    end
    --Funkar inte om alla är utanför bilden åt samma håll
    if player1.x ~= player1.rx and player1.rx > 100 and player1.rx < width-100 then
        player1.x = player1.rx
    end
    if player1.y ~= player1.ry and player1.ry > 100 and player1.ry < height-100 then
        player1.y = player1.ry
    end
    if love.keyboard.isDown('up') then
        player2.y = player2.y - player2.speed*dt
    elseif love.keyboard.isDown('left') then
        player2.x = player2.x - player2.speed*dt
    elseif love.keyboard.isDown('down') then
        player2.y = player2.y + player2.speed*dt
    elseif love.keyboard.isDown('right') then
        player2.x = player2.x + player2.speed*dt
    end
    if voronoiCalculate then
        voronoiDiagram = Voronoi(width,hight,{player1,player2,player3})
    end
    voronoiCalculate = not voronoiCalculate
end

function love.draw()
    love.graphics.draw( voronoiDiagram )
    love.graphics.rectangle('fill', player1.x, player1.y, player1.size, player1.size)
   --love.graphics.line(player1.x, player1.y, player1.x+(player2.x-player1.x)/2, player1.y+(player2.y-player1.y)/2)
    love.graphics.rectangle('fill', player2.x, player2.y, player2.size, player2.size)
    --love.graphics.line(player2.x, player2.y, player2.x+(player1.x-player2.x)/2, player2.y+(player1.y-player2.y)/2)
    love.graphics.rectangle('fill', player3.x, player3.y, player3.size, player3.size)
    love.graphics.print(love.timer.getFPS(), 0, 0)
end

function hypot( x, y )
    return math.sqrt( x*x + y*y )
end

function Voronoi(width,hight,players)
    canvas = love.graphics.newCanvas(width, height)
    local imgx = canvas:getWidth()
    local imgy = canvas:getHeight()
    love.graphics.setColor(255,255,255)
    love.graphics.setCanvas(canvas)
    for y = 1, imgy, 16 do
        for x = 1, imgx, 16 do
            dmin = hypot( imgx-16, imgy-16)
            j = 1
            for i = 1, #players do
                d = hypot(players[i].x-x, players[i].y-y ) 
                if d < dmin then
                    dmin = d
                    j = i
                end
            end
            love.graphics.setColor(players[j].r, players[j].g, players[j].b)
            --love.graphics.rectangle('fill', x, y, 16, 16)
            love.graphics.points( x, y )
        end
    end
    love.graphics.setColor(255, 255, 255)
    love.graphics.setCanvas( )
    return canvas
end