' TODO should these all be subs, not returning anything? Any advantage to subs?

' Set global game parameters here.
function rg2dSetGameParameters() as void

    g = GetGlobalAA()

    g.USING_LB_CODE = false
    g.DEBUG = True

    g.highScoreRegister = "GameHighScores"

    g.menuArray = rg2dMenuItemList()
    g.menuArray.addItem("New Game", "new_game")
    g.menuArray.addItem("Options", "options")
    g.menuArray.addItem("High Scores", "high_scores")
    g.menuArray.addItem("About", "about")

end function

'
' Load all Sprites Used in the game
'
function rg2dLoadSprites() as void
    g = GetGlobalAA()

    if(g.DEBUG) then
      ?"Loading Sprites..."
    end if

    bmScore = CreateObject("roBitmap", "pkg:/components/sprites/Numbers_Spritesheet_32.png")

    g.rScore = []
    g.rScore[0] = CreateObject("roRegion", bmScore, 0*32, 0, 32, 32)
    g.rScore[1] = CreateObject("roRegion", bmScore, 1*32, 0, 32, 32)
    g.rScore[2] = CreateObject("roRegion", bmScore, 2*32, 0, 32, 32)
    g.rScore[3] = CreateObject("roRegion", bmScore, 3*32, 0, 32, 32)
    g.rScore[4] = CreateObject("roRegion", bmScore, 4*32, 0, 32, 32)
    g.rScore[5] = CreateObject("roRegion", bmScore, 5*32, 0, 32, 32)
    g.rScore[6] = CreateObject("roRegion", bmScore, 6*32, 0, 32, 32)
    g.rScore[7] = CreateObject("roRegion", bmScore, 7*32, 0, 32, 32)
    g.rScore[8] = CreateObject("roRegion", bmScore, 8*32, 0, 32, 32)
    g.rScore[9] = CreateObject("roRegion", bmScore, 9*32, 0, 32, 32)


    bmPauseScreen = CreateObject("roBitmap", "pkg:/components/sprites/Pause_Menu_Screen.png")
    g.rPauseScreen = CreateObject("roRegion", bmPauseScreen, 0, 0, 640, 200)

    'bmTruck = CreateObject("roBitmap", "pkg:/components/sprites/texture_brick01_60p.png")
    'g.rTruck = CreateObject("roRegion", bmTruck, 0, 0, 60, 60)
    g.rTruck = rg2dLoadRegion("pkg:/components/sprites/firetruck_spritesheetII.png", 0, 0, 49, 36)
    g.rBricks = rg2dLoadRegion("pkg:/components/sprites/texture_brick01_60p.png", 0, 0, 60, 60)
    g.rCircleFire16 = rg2dLoadRegion("pkg:/components/sprites/circle_fire_16p.png", 0, 0, 16, 16)
    g.rCircleGrey8 = rg2dLoadRegion("pkg:/components/sprites/circle_grey_8p.png", 0, 0, 8, 8)

    ' Kenny's stuff
    g.rSnowBall = rg2dLoadRegion("pkg:/components/sprites/snowball_p21.png", 0, 0, 21, 21)
    'g.rTerrain_ice = rg2dLoadRegion("pkg:/components/sprites/terrain_ice_288_44.png", 0, 0, 288, 44)
    g.rIgloo_right = rg2dLoadRegion("pkg:/components/sprites/igloo_right_63_42.png", 0, 0, 63, 42)
    g.rIgloo_left = rg2dLoadRegion("pkg:/components/sprites/igloo_left_63_42.png", 0, 0, 63, 42)

    g.rFlagRed = rg2dLoadRegion("pkg:/components/sprites/Flag_red_white.png", 0, 0, 40, 30)
    g.rFlagBlue = rg2dLoadRegion("pkg:/components/sprites/Flag_orange_blue.png", 0, 0, 40, 30)

    g.terrain_ice = createTerrain("pkg:/components/sprites/terrain_ice_288_44.png")

    if(g.USING_LB_CODE) then
        LBLoadSprites()
    end if

end function

'
' Load all sounds used in the game
'
function rg2dLoadSounds() as void
    g = GetGlobalAA()

    if(g.DEBUG) then
      ?"Loading Sounds..."
    end if

    g.sounds ={}
    'g.sounds.ship_engines = CreateObject("roAudioResource", "pkg:/assets/ship_engines.wav")
    g.sounds.navSingle = CreateObject("roAudioResource", "navsingle")

    '?"Max Streams ";g.sounds.astroid_blast.maxSimulStreams()
    g.audioStream = 1
    g.maxAudioStreams = 1 'g.sounds.astroid_blast.maxSimulStreams()

end function

'
' Use this to set custom actions when a menu item is selected
'
function rg2dMenuItemSelected() as void

    g = GetGlobalAA()

    if(g.DEBUG) then
      ?"Menu Item Selected ...";
    end if

    selectedMenuOption = g.menuArray.selectedIndex

    shortName = g.menuArray.getSelectedItemShortName()

    if(g.DEBUG) then
      ?"->";shortName
    end if

    if(shortName = "new_game") then ' New Game

        stat = rg2dPlayGame()

    else if(shortName = "options") then ' Settings
        '?"Going to settings screen"
        'rg2dPlaySound(m.sounds.warp_out)
        stat = rg2dOpenSettingsScreen(m.screen, m.port)
        'rg2dPlaySound(m.sounds.warp_in)

    else if(shortName = "high_scores") then

        'rg2dPlaySound(m.sounds.warp_out)
        stat = rg2dOpenHighScoresScreen(m.screen, m.port)
        'rg2dPlaySound(m.sounds.warp_in)

    else if(shortName = "about") then

        'rg2dPlaySound(m.sounds.warp_out)
        stat = rg2dOpenCreditScreen(m.screen, m.port)
        'rg2dPlaySound(m.sounds.warp_in)
    end if

end function


' Stuff that needs to be done at the start of each game goes here.
function rg2dGameInit() as void
    g = GetGlobalAA()

    if(g.DEBUG) then
      ?"rg2dGameInit()..."
    end if

    ' Create Truck
    g.tank1 = createTank(100, g.sHeight-200, 0, true, "igloo") ' TODO Flip this one
    g.tank2 = createTank(g.sWidth-100, g.sHeight-200,0, false, "igloo")

    g.tank1.bmFlag.setFlagImage(g.rFlagRed)
    g.tank2.bmFlag.setFlagImage(g.rFlagBlue)

    g.pogTanks = g.pm.createPhysObjGroup()
    g.pogProjs = g.pm.createPhysObjGroup()
    g.pogTerr = g.pm.createPhysObjGroup()

    g.pogTanks.addPhysObj(g.tank1)
    g.pogTanks.addPhysObj(g.tank2)

    cpTankProj = g.pm.createCollisionPair(g.pogTanks,g.pogProjs)

    cpTankProj.overlapCallback = function(t,p) as integer

      if(p.ttl > 29) then

        ?"Projectile must be firing still!";p.ttl
        return 1
      end if
      if p.state = "ALIVE" then
        ?"Projectile Hit Tank!"
        t.takeDamage(10)
        p.ttl = 0.0
        p.state = "DEAD"
      end if

      return 1 ' Indicate not to perform normal collision

    end function

    if(g.USING_LB_CODE) then
        LBMakeGroups()
    end if

end function


'''''''''' OUTER LOOP STUFF
' Stuff to be done at the start of each level goes here.
function rg2dLoadLevel(level as integer) as void
    g = GetGlobalAA()
    if(g.DEBUG) then
      ?"rg2dLoadLevel()..."
    end if
    if(g.USING_LB_CODE) then
        LBLoadLevel(level)
    end if

    g.bgColor = &h112233FF ' TODO probably need to have a compositor be tied to each level. BG color is set at creation. This might also help to clear sprites that the game is done with after each level.'

    g.player_state = "IDLE"

    g.player_turn = 1

    cpProjTerr = g.pm.createCollisionPair(g.pogProjs,g.pogTerr)
    cpProjTerr.overlapCallback = function(p,t) as integer
      ?"Projectile hitting ICE"
      if p.state = "ALIVE" then
        p.ttl = 0.1
        p.state = "DEAD"
      end if
    end function

    td = terrainDefinition()
    td.addSection(160,180)
    td.addSection(160,200)
    td.addSection(160,160)
    td.addSection(160,140)

    td.addSection(160,220)
    td.addSection(160,100)
    td.addSection(160,100)
    td.addSection(160,160)

    terrain = laydownTerrainInOneSprite(g.pm, g.compositor, g.terrain_ice, td)

    g.tank1.setPosition(100, (g.sHeight - 180) - 21)
    g.tank2.setPosition(g.sWidth-100, (g.sHeight - 160) - 21)
    g.tank1.updateDisplay()
    g.tank2.updateDisplay()

end function

function switchActivePlayer() as void
    g = GetGlobalAA()
    If g.player_turn = 1 then
      g.player_turn = 2
    else
      g.player_turn = 1
    End If

end function

' Stuff to be done at the start of each update loop goes here.
function rg2dInnerGameLoopUpdate(dt as float, button, button_hold_time) as void
    g = GetGlobalAA()
    if(g.DEBUG and (dt > 0.040)) then
      ?"rg2dInnerGameLoopUpdate(";dt;")..."
    end if

    angle_inc = pi()/180

    If g.player_turn = 1 then
      active_player = g.tank1
    else
      active_player = g.tank2
    End If

    if(button.bUp) then
        active_player.set_turret_angle(active_player.tank_turret_angle + angle_inc)
        ?"Angle Up ";active_player.tank_turret_angle

        'g.bmFlagLeft.setFlagPosition(g.bmFlagLeft.flagHeight + 0.05)
        'g.bmFlagLeft.updateDisplay()
    else if(button.bDown) then
        active_player.set_turret_angle(active_player.tank_turret_angle - angle_inc)
        ?"Angle Up ";active_player.tank_turret_angle

        'g.bmFlagLeft.setFlagPosition(g.bmFlagLeft.flagHeight - 0.05)
        'g.bmFlagLeft.updateDisplay()
    else if(button.bRight) then
        ?"Trucking Left"
        'g.bmExtLeft.setValue(g.bmExtLeft.value + 0.05)
        'active_player.set_turret_spacing(active_player.turret_spacing + 1)

    else if(button.bLeft) then
        ?"Trucking Right"
        'g.bmExtLeft.setValue(g.bmExtLeft.value - 0.05)
        'active_player.set_turret_spacing(active_player.turret_spacing - 1)

    else if(button.bSelect1) then
      if g.player_state = "IDLE" then
        ?"Prepping to fire"
        g.player_state = "POWER_SELECT"
      else if g.player_state = "POWER_SELECT"
        g.power_select =  (button_hold_time MOD 2000)/2000
        active_player.setPowerBar(g.power_select)
      end if
    else
      if g.player_state = "POWER_SELECT"
        g.player_state = "IDLE"
        active_player.fireProjectile(200 + g.power_select * 300)
        switchActivePlayer()
      end if
    end if

end function
