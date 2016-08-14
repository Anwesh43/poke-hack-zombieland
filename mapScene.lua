composer = require('composer')
scene = composer.newScene()
local alert = nil

local startGameBtn = nil
local shopFactory = require('shopFactory')
local zombieAreaFactory = require('zombieAreaFactory')
local shops = shopFactory.getShops()
local zombieAreas = zombieAreaFactory.getZombiesArea()
local myMap = nil
local updatedLocation = 0
local locationUtil = require("locationUtil")
local function markerListener(event)
    print( event.type, event.markerId, event.latitude, event.longitude)
end

local attempts = 0

local locationText = nil



local function locationHandler( event )
  if(myMap~=nil and myMap.getUserLocation~=nil)
  then
  local currentLocation = myMap:getUserLocation()

if ( currentLocation.errorCode or ( currentLocation.latitude == 0 and currentLocation.longitude == 0 ) ) then

  attempts = attempts + 1

  if ( attempts > 10 ) then
      native.showAlert( "No GPS Signal", "Can't sync with GPS.", { "Okay" } )
  else
      timer.performWithDelay( 1000, locationHandler )
  end
else

  myMap:setCenter( currentLocation.latitude, currentLocation.longitude,0.01,0.01 )

  local zshop =
  {
       title = "Shop",
       subtitle = "",
       listener = markerListener,
       imageFile =  "smarker.png",
  }

  local zifst =
  {
       title = "Zombie Infested Area",
       subtitle = "",
       listener = markerListener,
       imageFile =  "zmarker.png",
  }

  if(updatedLocation == 0)
  then
      for index,shop in ipairs(shops)
      do
          myMap:addMarker(shop.latitude,shop.longitude,zshop)
      end
      for index,zombieArea in ipairs(zombieAreas)
      do
          myMap:addMarker(zombieArea.latitude,zombieArea.longitude,zifst)
      end
  end
  checkForNearestShops(currentLocation.latitude,currentLocation.longitude)
  checkForNearestZombieAreas(currentLocation.latitude,currentLocation.longitude)
  updatedLocation = updatedLocation+1
        --myMap:removeMarker(ifst)
    end
  end
end

function enterFrame()
  timer.performWithDelay( 5000, function()
    locationHandler()
  end)
end

function checkForNearestShops(latitude,longitude)
    shopDistances = {}
    for index,shop in ipairs(shops)
    do
        print(latitude,longitude,shop.latitude,shop.longitude)
        d = locationUtil.calculateDistance(latitude,longitude,shop.latitude,shop.longitude)
        print(d)
        table.insert(shopDistances,index,d)
    end
    table.sort(shopDistances)
    print(shopDistances[1])

    if(shopDistances[1]<5)
    then

    end
end

function checkForNearestZombieAreas(latitude,longitude)
    zombieAreasDistances = {}
    for index,shop in ipairs(zombieAreas)
    do
        d = locationUtil.calculateDistance(latitude,longitude,shop.latitude,shop.longitude)
        print(d)
        table.insert(zombieAreasDistances,index,d)
    end
    table.sort(zombieAreasDistances)
    print(zombieAreasDistances[1])
    if(zombieAreasDistances[1]<5)
    then
       locationText.text="Close to a zombie affected area"
       startGameBtn.alpha = 1
       startGameBtn:addEventListener("tap",function()
          composer.gotoScene("shootingScene")
          composer.removeScene("mapScene",true)
       end)

    end
end

function scene:create(event)
    print("starting here")
    local mapGroup = self.view
    myMap = native.newMapView(0, 0,display.contentWidth, display.actualContentHeight*0.6)
    myMap.x = display.contentCenterX
    myMap.y = display.contentCenterY
    startGameBtn = display.newRect(0,display.actualContentHeight*0.9,display.contentWidth*2.4,display.actualContentHeight*0.2)
    startGameBtn:setFillColor(76/255, 175/255, 80/255)
    startGameBtn.alpha = 0.6
    locationText =  display.newText( "Not close to a zombie affected area", display.contentWidth/2,display.actualContentHeight*0.85, native.systemFont, 20 )
    locationText:setFillColor(1,1,1)
    locationText.anchorY = 0
    locationText.x = display.contentCenterX
    mapGroup:insert(myMap)

    mapGroup:insert(startGameBtn)
    mapGroup:insert(locationText)
    locationHandler()


end
function scene:show(event)
    timer.performWithDelay( 1000,function()
        Runtime:addEventListener("location",locationHandler)
    end )

end
function scene:hide(event)
    Runtime:removeEventListener("location",locationHandler)
end
function scene:destroy(event)
    Runtime:removeEventListener("location",locationHandler)
end
scene:addEventListener("create",scene)
scene:addEventListener("show",scene)
scene:addEventListener("hide",scene)
scene:addEventListener("destroy",scene)
return scene
