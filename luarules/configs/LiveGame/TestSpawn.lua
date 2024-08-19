
local test = {}

function test:func(gadget)
    gadget:SpawnSquad(1,nil,{ SquadGroup = {
         [1] = {
            Squad = "armart",
             Count = 3
         }
     } });
    gadget:SpawnSquad(20,nil,{ SquadGroup = {
        [1] = {
            Squad = "armart",
            Count = 3
        }
    } });
end

return test;