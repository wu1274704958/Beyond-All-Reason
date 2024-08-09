
local Mat2 = _G.Mat2;

local function GetNextPosFuncDef(originPos,forward,index,group,op)
     if op == nil then op = {} end
     local offx = op.offx or 200;
     local range = op.offy or 180;
     local baseRowNum = op.baseRowNum or 3;
     local beginRot = op.beginRot;
     local rowNumAccrual = op.rowNumAccrual or 2;
     local beginx = op.beginx or 200;
 
     if beginRot == nil then
         local tmp = { [0] = -15,[1] = 15 };
         beginRot = tmp[group];
     end
 
     local row = 0;
     local tmp = index;
     while true do
          local currNum = baseRowNum + rowNumAccrual * row;
          if tmp - currNum < 0 then
               break;
          else
               row = row + 1;
               tmp = tmp - currNum;
          end
     end

     local rowNum = baseRowNum + rowNumAccrual * row;
     local col = tmp;
     
     local offy = range / (rowNum - 1);
 
     local angle = 0;
     if col > 0 then
         angle = math.floor(((col - 1) / 2) + 1) * offy;
         if (col - 1) % 2 == 1 then
             angle = -1 * angle;
         end
     end
     --Spring.Echo(string.format(" i = %d angle = %d row = %d col = %d offy = %d",index,angle,row,col,offy))
     local mat = Mat2.FromRotate( angle + beginRot );
 
     local forwardDist = (mat * forward) * (offx * row + beginx);
 
     originPos:add(forwardDist.x,forwardDist.y);
     
     return originPos;
 end


 local function GetTowerUnitByTypeDef(type,group)
     if type == nil then
         return group == 0 and "cordoom" or "corvipe"
     elseif type == 1 then
          return "armrl"
     elseif type == 0 then 
          return "armllt"
     end

 end

return {
     ["Comet Catcher Remake 1.8"] = {
          pos = {
               [0] = { x = 300, z = 600 },
               [1] = { x = 800, z = 600 }
          },
          camera_state = {
               px = 6000,
               py = 0,
               pz = 1000,
               dx = 0,
               dy = -0.8568887,
               dz = -0.5155014,
               angle = 300,
               dist = 2284.8313
          }
     },
     ["Asteroid_Mines_V3"] = {
          pos = {
               [0] = { x = 1600, z = 1700 },
               [1] = { x = 4500, z =  1700 }
          },
          camera_state = {
               px = 3050.5332,
               py = 449.98291,
               pz = 1572.57947,
               dx = 0,
               dy = -0.8568887,
               dz = -0.5155014,
               angle = 300,
               dist = 2284.8313
          },
          GetNextPosFunc = GetNextPosFuncDef
     },
     ["Ascendancy v2.2"] = {
          pos = {
               [0] = { x = 4500, z = 4800 },
               [1] = { x = 7500, z = 4800 }
          },
          camera_state = {
               px = 5990.30811,
               py =  591.027954,
               pz = 4856.1377,
               dx = 0,
               dy = -0.8568887,
               dz = -0.5155014,
               angle = 300,
               dist = 2375.36841
          },
          GetNextPosFunc = GetNextPosFuncDef,
          GetTowerUnitByType = GetTowerUnitByTypeDef
     }
}
