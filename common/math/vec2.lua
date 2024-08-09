local Vec2 = {}

Vec2.Create = function (x,y)
    local vec2 = { x = x or 0,y = y or 0 }
    
    local meta = {
        __mul = function (a,b)
            if type(b) == "number" then
                return Vec2.Create(a.x * b,a.y * b);
            elseif b.class == "Vec2" then
                return a.x * b.x + a.y * b.y
            end
        end ,
        __index = function (a,key)
            if key == "class" then
                return "Vec2";
            end
            return nil;
        end
    }

    setmetatable(vec2, meta)

    function vec2:add(_x,_y)
        self.x = self.x + _x;
        self.y = self.y + _y;
    end

    function vec2:sub(_x,_y)
        self.x = self.x - _x;
        self.y = self.y - _y;
    end

    function vec2:normalize()
        local len = math.sqrt( self.x * self.x + self.y * self.y )
        self.x = self.x / len;
        self.y = self.y / len;
    end

    return vec2;
end

return Vec2;