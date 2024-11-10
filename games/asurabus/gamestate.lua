require("/games/asurabus/constants")
require("/games/asurabus/memory_addresses")

local rb, rbs, rw, rws, rd = memory.readbyte, memory.readbytesigned, memory.readword, memory.readwordsigned,
    memory.readdword

DebugMessage = "How did you see this?";

CurrentAnim = 0x00;
Startup = -1;
Active = -1;
Recovery = -1;
CurrentFrame = -1;
function ShowFrameData()
    local move_id = rws(players[1].AnimationID)
    local is_active = rws(players[1].AttackState) ~= 0
    local hitstop = rws(global.Hitstop)
    if move_id == CurrentAnim then
        if hitstop == 0 then
            CurrentFrame = CurrentFrame + 1
        end
        if is_active then
            if Startup == -1 then
                if hitstop == 0 then
                    Startup = CurrentFrame
                else
                    Startup = CurrentFrame + 1
                end
            end
            Active = CurrentFrame - Startup + 1
        end
    else
        if Startup ~= -1 then
            Recovery = CurrentFrame - (Startup + Active) +2 
            -- +1 because using first active for startup; +1 because of forced neutral frame
            DebugMessage = "Move ID " ..
            CurrentAnim ..
            ": S" .. Startup .. " A" .. Active .. " R" .. Recovery .. " (T" .. Startup + Active + Recovery - 1 .. ")"
        end
        CurrentFrame, CurrentAnim = 1, move_id
        Startup, Active, Recovery = -1, -1, -1
    end
    NowActive = move_id
end

-- function DamageCalc(damage, hitCount)
--     damage = ((damage * 32) & 0xFFFF) >> 5 -- shave off excess bits;  >> 5 is effectively dividing by 32

--     if hitCount > 11 then
--         hitCount = 11
--     end

--     DamageTable = {0x20, 0x1A, 0x14, 0x10, 0x0C, 0x0A, 0x08, 0x06, 0x05, 0x04, 0x02, 0x01}
--     modifier = DamageTable[hitCount + 1]

--     damage = ((damage * modifier) & 0xFFFF) >> 5
-- end
