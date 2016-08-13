composer = require('composer')
local scene = composer.newScene()
local sceneGroup = nil
zombieService = require('zombieService')
n = 50
local bullets = {}
local index = 0
local scoreText = nil
local player = nil
local zombies = {}
function shoot()
    bullet = display.newImage("bullet1.png")
    bullet.x = 40
    bullet.y = display.contentHeight - 60
    sceneGroup:insert(bullet)
    table.insert(bullets,table.maxn(bullets),bullet)
end
function moveBullet()
    for index,bullet in ipairs(bullets)
    do
        bullet.x = bullet.x+10
    end
end
function checkForZombiePlayerCollision()
    for index,zombie in ipairs(zombies)
    do
        if(player ~= nil and player.x ~=nil and zombie~= null and zombie.x <= player.x)
        then
            table.remove(zombies,index)
            display.remove(zombie)

            Runtime:removeEventListener("enterFrame",enterFrame)
            display.remove(player)
            for index,zombie in ipairs(zombies)
            do
                display.remove(zombie)
                table.remove(zombies,index)
                scoreText.text="mission failed!"
            end
            break
        end
    end
end
function checkForBulletZombieCollision()
    for index,bullet in ipairs(bullets)
    do
      for zindex,zombie in ipairs(zombies)
      do
          if(bullet.x+bullet.width >= zombie.x and bullet.x<=display.contentWidth)
          then

              display.remove(zombie)
              table.remove(zombies,zindex)
              display.remove(bullet)
              table.remove(bullets,index)
              scoreText.text=string.format("zombies left:%s",table.maxn(zombies))
              if(table.maxn(zombies) == 0)
              then
                  scoreText.text="Mission Accomplished"
                  Runtime:removeEventListener("enterFrame",enterFrame)
              end
          end
      end
    end
end
function drawZombies()
    for index,zombieAnimation in ipairs(zombies)
    do
        zombieAnimation.x= zombieAnimation.x-10
        zombieAnimation:play()
    end
end

function render()
    drawZombies()
    moveBullet()
    checkForBulletZombieCollision()
    checkForZombiePlayerCollision()
end
function enterFrame()
    timer.performWithDelay(200,render)
end

function scene:create(event)
    scoreText = display.newText(string.format("zombies left:%s",n),display.contentWidth/2,display.contentHeight/3,"arial",40)
    player = display.newImage("Smuz_Sprite.png")
    zombies = zombieService.getZombiesForAnArea(display.contentWidth,display.contentHeight,n)
    player.x = 30
    local bg = display.newImage("activity1.png")
    bg.xScale=2
    bg.yScale=2
    player.y = display.contentHeight-50
    player.xScale=0.8
    player.yScale=0.9
    scoreText:setFillColor(1,1,1)
    sceneGroup = self.view
    sceneGroup:insert(bg)
    sceneGroup:insert(scoreText)
    sceneGroup:insert(player)

    for k,zombie in ipairs(zombies)
    do
        sceneGroup:insert(zombie)
    end
    display.currentStage:addEventListener("tap",shoot)
    Runtime:addEventListener("enterFrame",enterFrame)
end
function scene:show(event)

end
function scene:hide(event)

end
function scene:destroy(event)

end
scene:addEventListener("create",scene)
scene:addEventListener("show",scene)
scene:addEventListener("hide",scene)
scene:addEventListener("destroy",scene)
return scene
