local Vec2 = VFS.Include("common/math/vec2.lua")

local Mat2 = {}
-- 00 01
-- 10 11
Mat2.Create = function (m00,m01,m10,m11)
    local mat2 = { m00 = m00,m01 = m01,m10 = m10,m11 = m11 }
    local meta = {
        __index = function (a,key)
            if key == "class" then
                return "Mat2";
            end
            return nil;
        end,
        __mul = function (a,b)
            if b.class == "Vec2" then
                return Vec2.Create(a.m00 * b.x + a.m01 * b.y, a.m10 * b.x + a.m11 * b.y);
            elseif b.class == "Mat2" then
                return Mat2.Create (
                    a.m00 * b.m00 + a.m01 * b.m10, a.m00 * b.m01 + a.m01 * b.m11,
                    a.m10 * b.m00 + a.m11 * b.m10, a.m10 * b.m01 + a.m11 * b.m11
                );
            end
        end
    }

    setmetatable(mat2,meta);

    return mat2;
end

Mat2.FromRotate = function(angle)
    local rad = 0.017453292519943 * angle;
    return Mat2.Create(
        math.cos(rad), -math.sin(rad),
        math.sin(rad),  math.cos(rad)
    );
end


return Mat2