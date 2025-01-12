require("/games/asurabus/constants")
require("/games/asurabus/memory_addresses")
require("/games/asurabus/asurabus")

local rb, rbs, rw, rws, rd = memory.readbyte, memory.readbytesigned, memory.readword, memory.readwordsigned,
    memory.readdword

local currentAnim = 0x00;
local currentFrame = -1;
local prevAnimP1 = 0x00;

local startup = -1;
local active = -1;
local recovery = -1;
local activeStr = ""
local lastHitStartFrame = -2
local lastHitEndFrame = -1

local isActionableP1 = true
local framesSinceP1Actionable = -1
local sprTimeP1 = -1;
local sprFrameP1 = -1;
local prevFrameP1 = -1;
local prevTimeP1 = -1;

local isActionableP2 = true
local framesSinceP2Actionable = -1
local sprTimeP2 = -1;
local sprFrameP2 = -1;
local prevFrameP2 = -1;
local prevTimeP2 = -1;

Advantage = ""

function formatHex(x)
    return string.upper(string.format("%02x", x))
end

local function formatActiveString()
    if activeStr ~= "" then
        activeStr = activeStr .. ", " .. lastHitStartFrame .. "-" .. lastHitEndFrame
    else
        activeStr = lastHitStartFrame .. "-" .. lastHitEndFrame
    end
end

local function formatAdvantage(adv)
    if adv > 0 then
        Advantage = " +" .. adv
    else
        Advantage = " " .. adv
    end
end

local function isFrozenP1()
    return (sprTimeP1 == prevTimeP1 and sprFrameP1 == prevFrameP1 and currentAnim == prevAnimP1)
end

function ParseFrameDataP1()
    sprTimeP1, sprFrameP1 = rw(players[1].SPRTime), rw(players[1].SPRFrame)

    local move_id = rws(players[1].AnimationID)
    local is_active = (rws(players[1].AttackState) ~= 0) or ProjectileActiveP1

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
            -- manage gaps in active frames
            if lastHitEndFrame < currentFrame and lastHitStartFrame < lastHitEndFrame then
                if isFrozenP1() == false then
                    lastHitStartFrame = currentFrame
                else
                    lastHitStartFrame = currentFrame + 1
                end
            end
            active = currentFrame - startup + 1
        else
            -- not currently active, add active period to activeStr
            if lastHitStartFrame > lastHitEndFrame then
                -- not active anymore, use previous currentFrame value
                if isFrozenP1() == false then
                    lastHitEndFrame = currentFrame - 1
                else
                    lastHitEndFrame = currentFrame
                end
                formatActiveString()
            end
        end
    else
        if startup ~= -1 then
            -- manage any hanging active periods
            if lastHitStartFrame > lastHitEndFrame then
                lastHitEndFrame = currentFrame
                formatActiveString()
            end
            recovery = currentFrame - ((startup - 1) + active)
            -- -1 because using first active for startup
            FrameDataOutput = "Move ID " .. formatHex(currentAnim) ..
                ": S" .. startup .. " A" .. active .. "(" .. activeStr .. ") R" .. recovery .. " (T" ..
                startup + active + recovery - 1 .. ") "
        end
        currentFrame, currentAnim, startup, active, recovery, activeStr, lastHitStartFrame, lastHitEndFrame = 1, move_id,
            -1, -1, -1, "", -2, -1
    end
    DebugMessage = DebugMessage .. " - S" .. lastHitStartFrame .. "E" .. lastHitEndFrame .. " | " .. activeStr
    NowActive = move_id
end

local function isFrozenP2()
    --return superFlash == 0x7 or hitstop ~= 0

    return (sprTimeP2 == prevTimeP2 and sprFrameP2 == prevFrameP2)
end

function CheckActionableP1()
    actions = IsPlayerActionable(1)

    local canAct = actions.Movement
    isActionableP1 = canAct
end

function CheckActionableP2()
    actions = IsPlayerActionable(2)

    local canAct = actions.Movement
    isActionableP2 = canAct
end

function ParseFrameAdv()
    -- ParseFrameDataP2() doesn't exist yet, update sprite data here
    sprTimeP2, sprFrameP2 = rw(players[2].SPRTime), rw(players[2].SPRFrame)

    if isActionableP1 then
        -- p1 is actionable, increment the counter
        if isFrozenP1() == false then
            framesSinceP1Actionable = framesSinceP1Actionable + 1
        end
    else
        -- not actionable; reset the counter
        framesSinceP1Actionable = -1
    end

    if isActionableP2 then
        -- p2 is actionable, increment the counter
        if isFrozenP2() == false then
            framesSinceP2Actionable = framesSinceP2Actionable + 1
        end
    else
        -- not actionable; reset the counter
        framesSinceP2Actionable = -1
    end

    if isActionableP1 and isActionableP2 then
        formatAdvantage(framesSinceP1Actionable - framesSinceP2Actionable)
    end

    DebugMessage = DebugMessage .. ". P1: " .. framesSinceP1Actionable .. ", P2: " .. framesSinceP2Actionable

    prevTimeP1, prevFrameP1, prevAnimP1, prevTimeP2, prevFrameP2 = sprTimeP1, sprFrameP1, currentAnim, sprTimeP2, sprFrameP2
end

function IsPlayerActionable(p)
    -- movement
    actions = { Movement = true, Attack = true, Special = true }

    hitstunType = rw(players[p].HitstunType)
    kdTime = rw(players[p].KnockdownTime)
    cancelAvailable = rw(players[p].CanCancel)
    unused_3DE2 = rw(players[p].Unused_2)
    unused_3DE4 = rw(players[p].Unused_4)
    unused_3DEE = rw(players[p].Unused_E)
    inAirborneHitstun = rw(players[p].InAirborneHitstun)
    inHitstun = rw(players[p].InHitstun)
    usingSpecial = rw(players[p].IsUsingSpecial)
    blockstun = rw(players[p].Blockstun)
    ypos = rw(players[p].YPos)                     -- if > 0xD8
    airActionable = rw(players[p].IsAirActionable) -- if true
    hitstun = rw(players[p].Hitstun)
    kd1 = rw(players[p].IsKnockedDown1)
    kd2 = rw(players[p].IsKnockedDown2)
    actionLock = rw(players[p].ActionLock)
    airOptions = rw(players[p].AirOptions)
    lastMoveHit = rw(players[p].LastAttackConnected)
    buttonStrength = rw(players[p].ButtonStrength)

    --DebugMessage = hitstunType .. kdTime .. cancelAvailable .. unused_3DE2 .. unused_3DE4 .. unused_3DEE
    --    .. inAirborneHitstun .. launched .. usingSpecial .. blockstun .. ypos .. airActionable .. " | "

    DebugMessage = ""

    if kdTime ~= 0 or cancelAvailable == 1 or unused_3DE2 ~= 0 or unused_3DE4 ~= 0 or unused_3DEE ~= 0
        or inAirborneHitstun ~= 0 or inHitstun ~= 0 or (ypos > 0xD8 and airActionable == 0) then
        actions.Movement = false
        actions.Attack = false
        actions.Special = false
    end

    if (buttonStrength ~= 0 and cancelAvailable == 2 and lastMoveHit == 0) or (cancelAvailable ~= 0 and cancelAvailable ~= 2) then
        actions.Attack = false
    end

    if (cancelAvailable ~= 0 and cancelAvailable ~= 3 and (cancelAvailable == 2 and lastMoveHit == 0)) then
        actions.Special = false
    end

    if usingSpecial ~= 0 then
        actions.Movement = false
        actions.Attack = false
    end

    if hitstun ~= 0 then
        actions.Movement = false
        actions.Special = false
    end

    if hitstunType ~= 0 or blockstun ~= 0 then
        actions.Attack = false
    end

    if 8 < blockstun or kd1 ~= 0 or kd2 ~= 0 or cancelAvailable == 5 or actionLock ~= 0 then
        actions.Movement = false
    end

    DebugMessage = DebugMessage .. "Options: "
    if actions.Movement then
        DebugMessage = DebugMessage .. "M"
    else
        DebugMessage = DebugMessage .. "-"
    end

    if actions.Attack then
        if (ypos == 0xD8 or bit.band(airOptions, 0xF) ~= 0) and buttonStrength == 0 then
            DebugMessage = DebugMessage .. "A"
        else
            DebugMessage = DebugMessage .. "-"
        end
        if (ypos == 0xD8 or bit.band(airOptions, 0xF0) ~= 0) and buttonStrength == 0 then
            DebugMessage = DebugMessage .. "B"
        else
            DebugMessage = DebugMessage .. "-"
        end
        if (ypos == 0xD8 or bit.band(airOptions, 0xF00) ~= 0) and buttonStrength <= 2 then
            DebugMessage = DebugMessage .. "C"
        else
            DebugMessage = DebugMessage .. "-"
        end
        if (ypos == 0xD8 or bit.band(airOptions, 0xF000) ~= 0) and buttonStrength <= 4 then
            DebugMessage = DebugMessage .. "L"
        else
            DebugMessage = DebugMessage .. "-"
        end
    else
        DebugMessage = DebugMessage .. "----"
    end

    if actions.Special then
        DebugMessage = DebugMessage .. "S"
    else
        DebugMessage = DebugMessage .. "-"
    end

    return actions
end
