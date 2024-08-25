
local test = {}

function test:func(gadget)
    gadget:SpawnSquad(1,nil,{ SquadGroup = {
         [1] = {
            Squad = "armpw",
             Count = 100
         },
         [2] = {
            Squad = "armart",
             Count = 2
         }
     } });
    gadget:SpawnSquad(20,nil,{ SquadGroup = {
        [1] = {
            Squad = "corcrwh",
            Count = 1
        }
    } });
end

return test;