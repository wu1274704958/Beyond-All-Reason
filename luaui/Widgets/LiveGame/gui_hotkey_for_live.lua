function widget:GetInfo()
    return {
       name      = "Shortcut Key support For Live Mode",
       desc      = "Handle global shortcut keys in live mode",
       author    = "eqd",
       date      = "Septmeber 2024",
       license   = "-",
       layer     = -10,
       enabled   = true
    }
 end
 local glTranslate = gl.Translate
 local glColor = gl.Color
 local glPushMatrix = gl.PushMatrix
 local glPopMatrix = gl.PopMatrix
 local glTexture = gl.Texture
 local glRect = gl.Rect
 local glTexRect = gl.TexRect
 local glRotate = gl.Rotate
 local glCreateList = gl.CreateList
 local glCallList = gl.CallList
 local glDeleteList = gl.DeleteList
local showQuitscreen,dlistQuit

 function widget:hideWindow()
    if WG['options'] ~= nil and WG['options'].isvisible() then
        WG['options'].toggle()
    end
 end

function widget:KeyRelease(key, mods, label, unicode)
    if mods.ctrl and mods.alt then
        if key == 57 then
            if WG['options'] ~= nil then
                WG['options'].toggle()
            end
        elseif key == 48 then
            Spring.Quit()
        end
    end
end

-- function widget:DrawScreen()
    
-- end