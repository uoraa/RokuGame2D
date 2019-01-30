' Like other components, this must be created with the level compositor already created beforehand
function mouseController()
  mc = {}

  mc.state = "IDLE"
  mc.sBanner = invalid
  mc.BANNER_WIDTH = 100
  mc.PLANE_WIDTH = 148
  mc.PLANE_HEIGHT = 86

  mc.vx = 200

  mc.timeSinceLastFlight = 0

  ' dt seconds since last update in seconds'
  mc.update = function(dt)
    if m.state = "IDLE" then
      m.timeSinceLastFlight += dt
    else if m.state = "FLYING" then

      m.x -= dt * m.vx
      m.y += dt * (rnd(7) - 4)
      m.sBanner.moveto(m.x, m.y)

      if( m.x < ( 0 - (m.BANNER_WIDTH + m.PLANE_WIDTH) ) ) then ' Off screen'
        m.state = "IDLE"
        m.sBanner.remove()
        m.sBanner = invalid
      end if
    end if

  end function

  mc.startPlaneBanner = function(msg as string)
    if(m.sBanner <> invalid) then
      m.sBanner.Remove()
    end if

    m.createMousePlaneBanner(msg)

    m.state = "FLYING"
  end function

  mc.createMousePlaneBanner = function(msg as string)
    g = GetGlobalAA()
    font = g.font_registry.GetFont("HannaHandwriting",20, True, false)
    'font = g.font_registry.GetFont("Almonte Snow", 56, false, false)

    m.BANNER_WIDTH = font.GetOneLineWidth(msg, 1280) + 16

    m.bmBanner = CreateObject("roBitmap", {width:m.PLANE_WIDTH+m.BANNER_WIDTH, height:m.PLANE_HEIGHT, AlphaEnable:true})
    m.bmBanner.DrawObject(0, 0, g.rMousePlaneStrings)

    m.bmBanner.drawRect(m.PLANE_WIDTH, 20, m.BANNER_WIDTH, 30, &hfefff2FF) ' Draw banner'
    'Write message'
    m.bmBanner.DrawText(msg, m.PLANE_WIDTH+8, 20, &h020c30FF, font)

    m.rBanner = CreateObject("roRegion", m.bmBanner, 0, 0, m.PLANE_WIDTH+m.BANNER_WIDTH, m.PLANE_HEIGHT)

    m.x = g.sWidth + 10
    m.y = 100

    m.sBanner = g.compositor.NewSprite(m.x, m.y, m.rBanner, g.layers.MousePlane)

  end function

  mc.getRandomMessage = function(eventName as string) as string
    g = GetGlobalAA()

    msgArray = g.mouseMessageData.lookup(eventName)
    msg = msgArray[rnd(msgArray.count()-1)]

    return msg

  end function


  return mc

end function

' Messgages are loaded globally'
function loadMouseMessages() as void
  g = GetGlobalAA()

  mouseMessageKey = "mouse_msg"

  mouseMessageStrings = rg2dGetRegistryString(mouseMessageKey)
  mouseMessageData = {}

  'NOTE Using only lower case for AA keys. they seem to go all lower case anyway'
  mouseMessageData.match_start = []
  mouseMessageData.match_start[0] = "Go! Go! Go!"
  mouseMessageData.match_start[1] = "Now let's have a nice clean snow battle folks!"
  mouseMessageData.match_start[2] = "Have fun you two!"

  mouseMessageData.match_over = []
  mouseMessageData.match_over[0] = "Move along folks, nothing left to see here!"
  mouseMessageData.match_over[1] = "What a shot, what a play, what a match!"
  mouseMessageData.match_over[2] = "Tune in next time for another Snow Battle Adventure!"

  ''" Ex: <NAME> <encouragement string>"
  ''" Player 1, You are still in the game, don't give up yet!"
  mouseMessageData.encouragement = []
  mouseMessageData.encouragement[0] = "You are still in the game, don't give up yet!"

  mouseMessageData.shot_compliment = []
  mouseMessageData.shot_compliment[0] = "Wow, what amazing skills!"
  mouseMessageData.shot_compliment[1] = "What a shot!"
  mouseMessageData.shot_compliment[2] = "This guy is on fire!"

  mouseMessageData.shot_criticism = []
  mouseMessageData.shot_criticism[0] = "Well, that could have gone better..."
  mouseMessageData.shot_criticism[1] = "Can't be happy with that one"


  mouseMessageData.test = []
  mouseMessageData.test[0] = "Mouse Plane Banner Printalizer is experiencing technical difficulties. Please stand by..."

  g.mouseMessageData = mouseMessageData


end function

function setMouseMessageData(data) as void
  g = GetGlobalAA()


  keys = g.mouseMessageData.keys()

  For each k in keys
    if data.DoesExist(k) then ' If aws update exists, use it
    ''?" Mouse Message Data: Adding remote values for field ";k
      g.mouseMessageData.AddReplace(k, data.lookup(k))
    else
    ''?" Mouse Message Data: Using local data for field ";k
    end if
  End For

  ''?"Saving mouse message data"
  mouseMessageKey = "mouse_msg"
  rg2dSaveRegistryData(mouseMessageKey, g.mouseMessageData)

end function
