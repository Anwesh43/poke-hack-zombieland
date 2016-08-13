local zombieUtil = {}

local options = {width=256,height=256,numFrames=6,sheetContentWidth=1536,sheetContentHeight=256}
zombieUtil.getZombiesForAnArea = function(width,height,n)
    return zombieUtil.getMockZombies(width,height,n)
end
zombieUtil.getMockZombies = function(width,height,n)
    zombies = {}
    for i=1,n
    do
        imageSheet = graphics.newImageSheet("zombie_sheet.png",options)
        zombieAnimation = display.newSprite(imageSheet,{name="runningfast",start=1,count=6,time=500})
        zombieAnimation.xScale=0.4
        zombieAnimation.yScale=0.4
        zombieAnimation.x = width+256+(i-1)*128
        zombieAnimation.y = height - 50
        table.insert(zombies,i,zombieAnimation)
    end
    for k,zombieAnimation in ipairs(zombies)
    do
        print(zombieAnimation.x)
    end
    return zombies
end
return zombieUtil
