require("/games/asurabus/constants")
require("/games/asurabus/memory_addresses")

local rb, rbs, rw, rws, rd = memory.readbyte, memory.readbytesigned, memory.readword, memory.readwordsigned,
    memory.readdword

local currentAnim = 0x00;
local currentFrame = -1;
local startup = -1;
local active = -1;
local recovery = -1;

local opponentIsActionable = true
local framesSinceP1Actionable = -1
local framesSinceP2Actionable = -1
local hitstun = 0;
local hitState = 0;
--local hitstop = 0;
--local superFlash = 0;
local sprTimeP1 = -1;
local sprFrameP1 = -1;
local prevFrameP1 = -1;
local prevTimeP1 = -1;
local sprTimeP2 = -1;
local sprFrameP2 = -1;
local prevFrameP2 = -1;
local prevTimeP2 = -1;
--local blockstun = 0;

Advantage = ""

local function isFrozenP1()
    --return superFlash == 0x7 or hitstop ~= 0

    return (sprTimeP1 == prevTimeP1 and sprFrameP1 == prevFrameP1)
end

local function isFrozenP2()
    --return superFlash == 0x7 or hitstop ~= 0

    return (sprTimeP2 == prevTimeP2 and sprFrameP2 == prevFrameP2)
end

local function formatAdvantage(adv)
    if adv > 0 then
        Advantage = " +" .. adv
    else
        Advantage = " " .. adv
    end
end

local function checkAnimStun(id)
    for _, v in pairs(ANIMATIONS_STUN) do
        if v == id then
            -- Animation matches hit, block, knockdown, or wakeup animation
            return true
        end
    end
    -- No match
    return false
end

local function checkWakeUp(id)
    for _, v in pairs(ANIMATIONS_WAKEUP) do
        if v == id then
            -- Animation matches wakeup animation
            return true
        end
    end
    -- No match
    return false
end

function CheckHitstun()
    hitstun = rws(players[2].Hitstun)
end

function CheckOpponentStunned()
    local anim = rws(players[2].AnimationID)
    hitState = rws(players[2].HitState)
    --blockstun = rws(players[2].Blockstun)
    local animPrev = rws(players[2].PrevAnimID)
    local animStun = checkAnimStun(anim)
    local wakeup = checkWakeUp(animPrev)

    local animString;
    local actString;
--
    if animStun then
        animString = anim .. "Y"
    elseif wakeup then
        animString = anim .. "W" .. animPrev
    else
        animString = anim .. "N"
    end

    local canAct = (hitstun ~= 0 or hitState ~= 0 or animStun or wakeup) == false
    if canAct then
        actString = " — ACTIONABLE"
    else
        actString = " — STUNNED"
    end

    DebugMessage = "Hitstun: " ..
        hitstun .. " | Hitstate: " .. hitState .. " | Anim: " .. animString .. actString
    opponentIsActionable = canAct
end

function ParseFrameData()
    sprTimeP1, sprFrameP1 = rw(players[1].SPRTime), rw(players[1].SPRFrame)

    local move_id = rws(players[1].AnimationID)
    local is_active = rws(players[1].AttackState) ~= 0
    --hitstop = rw(global.Hitstop)
    --superFlash = bit.band(memory.getregister(global.SuperFlash), 0xFFFF0000)/65536
    --DebugMessage = superFlash .. " ~ " .. memory.getregister(global.SuperFlash)
    --if move_id == currentAnim or (move_id == 0x17 and rws(players[1].Airborne) ~= 0) then
    if move_id == currentAnim then
        if isFrozenP1() == false then
            currentFrame = currentFrame + 1
        end
        if is_active then
            if startup == -1 then
                if isFrozenP1() == false then
                    startup = currentFrame
                else
                    startup = currentFrame + 1
                end
            end
            active = currentFrame - startup + 1
        end
    else
        if startup ~= -1 then
            recovery = currentFrame - ((startup - 1) + active)
            -- +1 because using first active for startup
            FrameDataOutput = "Move ID " .. currentAnim ..
                ": S" .. startup .. " A" .. active .. " R" .. recovery .. " (T" ..
                startup + active + recovery - 1 .. ")"
            -- start the counter for frame advantage calc
            framesSinceP1Actionable = 0
        end
        currentFrame, currentAnim = 1, move_id
        startup, active, recovery = -1, -1, -1
    end
    NowActive = move_id
end

function ParseFrameAdv()
    sprTimeP2, sprFrameP2 = rw(players[2].SPRTime), rw(players[2].SPRFrame)
    if opponentIsActionable then
        -- p2 is actionable, increment the counter
        if isFrozenP2() == false then
            framesSinceP2Actionable = framesSinceP2Actionable + 1
        end
    else
        -- p2 is not actionable, reset the counter
        framesSinceP2Actionable = -1
    end
    if framesSinceP1Actionable ~= -1 and framesSinceP2Actionable ~= -1 then
        -- both actionable, substract for frame advantage
        formatAdvantage(framesSinceP1Actionable - framesSinceP2Actionable)
        -- calculation made, reset p1's counter
        framesSinceP1Actionable = -1
    elseif framesSinceP1Actionable ~= -1 and framesSinceP2Actionable == -1 then
        -- p1 is plus, waiting on p2
        if opponentIsActionable then
            -- advantage is just P1's frame counter since P2's would equal 0
            formatAdvantage(framesSinceP1Actionable)
            -- reset the counter for next calc
            framesSinceP1Actionable = -1
        elseif isFrozenP1() == false then
            -- increment
            framesSinceP1Actionable = framesSinceP1Actionable + 1
        end
    end
    DebugMessage = DebugMessage .. ". P1: " .. framesSinceP1Actionable .. ", P2: " .. framesSinceP2Actionable

    prevTimeP1, prevFrameP1, prevTimeP2, prevFrameP2 = sprTimeP1, sprFrameP1, sprTimeP2, sprFrameP2
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
