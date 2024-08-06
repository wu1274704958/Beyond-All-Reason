local Vec2 = {}

Vec2.Create = function (x,y)
    local vec2 = { x = x or 0,y = y or 0 }
    
    function vec2:add(x,y)
        self.x = self.x + x;
        self.y = self.y + y;
    end

    function vec2:sub(x,y)
        self.x = self.x - x;
        self.y = self.y - y;
    end

    function vec2:normalize()
        local len = math.sqrt( self.x * self.x + self.y * self.y )
        self.x = self.x / len;
        self.y = self.y / len;
    end
    return vec2;
end

return Vec2;