
--Gör en koll om real x oxh real y är utanför "skärmen" och anpassa
--Skapa en karta och gör så den ritas ut istället för prickar.

--Skapa ett spel där man ska matcha en Voronoi mot en annan, där lagret man ändrar är halvtransparent. Generera en grid random med 2 eller fler punkter och sen generera en till som ligger ovanpå. 
--Vinner när de är likadana, Kolla X och Y på punkterna men en liten OK diff.

width, height = love.graphics.getDimensions()
local voronoiCalculate = true
function love.load()
    objects = {{x = love.math.random(200,500), y = love.math.random(200,800), size = 16, r = 255, g = 0, b = 0, speed = 100},
        {x = love.math.random(200,500), y = love.math.random(200,800), size = 16, r = 0, g = 0, b = 255, speed = 100}
        }--{x = 800, y = 100, size = 16, r = 0, g = 255, b = 0, speed = 100}}
    voronoiDiagramObjects = Voronoi(160,0,width-160,height,objects,255)
    players = {{rx = 200, ry = 200, x = 100, y = 100, size = 16, r = 255, g = 0, b = 0, speed = 100},
        {rx = 500, ry = 500, x = 500, y = 500, size = 16, r = 0, g = 0, b = 255, speed = 100}
        }--{rx = 800, ry = 100, x = 800, y = 100, size = 16, r = 0, g = 255, b = 0, speed = 100}}
end

function love.update(dt)
    if love.keyboard.isDown('w') then
        players[1].ry = players[1].ry - players[1].speed*dt
    elseif love.keyboard.isDown('a') then
        players[1].rx = players[1].rx - players[1].speed*dt
    elseif love.keyboard.isDown('s') then
        players[1].ry = players[1].ry + players[1].speed*dt
    elseif love.keyboard.isDown('d') then
        players[1].rx = players[1].rx + players[1].speed*dt
    end
    if love.keyboard.isDown('up') then
        players[2].ry = players[2].ry - players[2].speed*dt
    elseif love.keyboard.isDown('left') then
        players[2].rx = players[2].rx - players[2].speed*dt
    elseif love.keyboard.isDown('down') then
        players[2].ry = players[2].ry + players[2].speed*dt
    elseif love.keyboard.isDown('right') then
        players[2].rx = players[2].rx + players[2].speed*dt
    end
    --Funkar inte om alla är utanför bilden åt samma håll
    for i = 1, #players do
        if players[i].x ~= players[i].rx and players[i].rx > 100 and players[i].rx < width-100 then
            players[i].x = players[i].rx
        end
        if players[i].y ~= players[i].ry and players[i].ry > 100 and players[i].ry < height-100 then
            players[i].y = players[i].ry
        end
    end
    if voronoiCalculate then
        voronoiDiagram = Voronoi(160,0,width-160,height,players,127)
    end
    voronoiCalculate = not voronoiCalculate
end

function love.draw()
    love.graphics.draw(voronoiDiagramObjects)
    love.graphics.draw(voronoiDiagram)
    for i = 1, #players do
        love.graphics.rectangle('fill', players[i].x, players[i].y, players[i].size, players[i].size)
    end
    love.graphics.print(love.timer.getFPS(), 0, 0)
end

function hypot( x, y )
    return math.sqrt( x*x + y*y )
end

function Voronoi(tx,ty,width,hight,players,alpha)
    canvas = love.graphics.newCanvas(width, height)
    local imgx = canvas:getWidth()
    local imgy = canvas:getHeight()
    love.graphics.setColor(255,255,255)
    love.graphics.setCanvas(canvas)
    for y = ty+1, imgy, 16 do
        for x = tx+1, imgx, 16 do
            dmin = hypot( imgx-16, imgy-16)
            j = 1
            for i = 1, #players do
                d = hypot(players[i].x-x, players[i].y-y ) 
                if d < dmin then
                    dmin = d
                    j = i
                end
            end
            love.graphics.setColor(players[j].r, players[j].g, players[j].b,alpha)
            love.graphics.rectangle('fill', x, y, 16, 16)
            --love.graphics.points( x, y )
        end
    end
    love.graphics.setColor(255, 255, 255)
    love.graphics.setCanvas( )
    return canvas
end