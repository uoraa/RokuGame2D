function DisplayManager(view as object) as object
  dm = {}

  dm.DisplayObjList = []
  dm.view = view

  dm.addDisplayObj = function(do as object) as void
    m.DisplayObjList.push(do)
  end function

  dm.updateDisplays = function(dt as float)
    i = 0
    while i < m.DisplayObjList.count()
        a = m.DisplayObjList[i]

        a.updateDisplay(dt) 'Update Display
        i += 1

    end while
  end function


  return dm

end function

' Component to be added to gameObjects'
function DisplayComp(sprite as object) as object
  dc = {}

  dc.compType = "DisplayComp"

  dc.sprite = sprite

  dc.updateDisplay = function(dt) as void
    if(m.sprite <> invalid) then
      m.sprite.MoveTo(m.x, m.y) ' Requires x & y from gameObj. This component will not stand on it's own
    else
        ?"Warning: Display object has no sprite."
    end if
  end function

  return dc

end function
