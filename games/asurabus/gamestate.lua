require("/games/asurabus/constants")
require("/games/asurabus/memory_addresses")
require("/games/asurabus/asurabus")

local rb, rbs, rw, rws, rd = memory.readbyte, memory.readbytesigned, memory.readword, memory.readwordsigned,
    memory.readdword

local playerState = {
    {
        CurrentAnimation = 0x00,
        CurrentFrame = -1,
        PrevAnimation = 0x00,
        Startup = -1,
        Active = -1,
        Recovery = -1,
        ActiveString = "",
        LastHitStartFrame = -2,
        LastHitEndFrame = -1,
        ProjStartup = -1,
        ProjActiveTime = -1,
        ProjAnimLength = -1,
        ProjFrame = -1,
        ProjMoveID = -1,
        ProjActive = false,

        IsActionable = true,
        FramesSinceActionable = -1,
        SprTime = -1,
        SprFrame = -1,
        PrevFrame = -1,
        PrevTime = -1,

        NowActive = 0x00
    },

    {
        CurrentAnimation = 0x00,
        CurrentFrame = -1,
        PrevAnimation = 0x00,
        Startup = -1,
        Active = -1,
        Recovery = -1,
        ActiveString = "",
        LastHitStartFrame = -2,
        LastHitEndFrame = -1,
        ProjStartup = -1,
        ProjActiveTime = -1,
        ProjAnimLength = -1,
        ProjFrame = -1,
        ProjMoveID = -1,
        ProjActive = false,

        IsActionable = true,
        FramesSinceActionable = -1,
        SprTime = -1,
        SprFrame = -1,
        PrevFrame = -1,
        PrevTime = -1,

        NowActive = 0x00
    }
}

Advantage = ""

local function checkForActiveProjectiles(p)
    for i = 0, 31, 1 do
        local On   = rbs(players[p].pOn + (i * 0x10))
        local Type = rbs(players[p].pType + (i * 0x10))
        local ID   = rws(players[p].pID + (i * 0x10))
        local Time = rbs(players[p].pTime + (i * 0x10))
        local Hit  = rbs(players[p].pHit + (i * 0x10))

        if (On > 0 and Type > 0 and Hit == 1) then
            local skipProjectile = false;
            -- extra checks for ＳＰＥＣＩＡＬ ＣＡＳＥＳ 🫠
            if (players[p].Character == ALICE_HIDDEN) then
                if (ID == 92 and Time > 60) then                                  -- skip 214X inactive frames
                    skipProjectile = true;
                elseif ((ID == 51 or ID == 95) and (Time < 13 or Time > 21)) then -- 623X is only active on frames 13 to 21 of being on screen
                    skipProjectile = true;
                elseif (ID == 94 and (Time < 19 or Time > 27)) then               -- 623EX and boost 623C final hits are only active on frames 19 to 27 of being on screen
                    skipProjectile = true;
                end
            elseif (ID == 15) then -- Zam-B 236X ground puddle
                skipProjectile = true;
            end
            if (skipProjectile == false) then
                return true
            end
        end
    end
    return false
end

local function formatActiveString(p)
    if playerState[p].ActiveString ~= "" then
        playerState[p].ActiveString = playerState[p].ActiveString ..
            ", " .. playerState[p].LastHitStartFrame .. "-" .. playerState[p].LastHitEndFrame
    else
        playerState[p].ActiveString = playerState[p].LastHitStartFrame .. "-" .. playerState[p].LastHitEndFrame
    end
end

local function formatAdvantage(adv)
    if adv > 0 then
        Advantage = " +" .. adv
    else
        Advantage = " " .. adv
    end
end

local function formatHex(x)
    return string.upper(string.format("%02x", x))
end

local function isFrozen(p)
    return (playerState[p].SprTime == playerState[p].PrevTime and playerState[p].SprFrame == playerState[p].PrevFrame
        and playerState[p].CurrentAnimation == playerState[p].PrevAnimation)
end

local function isNeutralFrame(p)
    local move_id = rws(players[p].AnimationID)

    local i = 0
    local contains = false

    repeat
        if (ANIMATIONS_NFRAME[i] == move_id) then contains = true end
        i = i + 1
    until (i == #ANIMATIONS_NFRAME)

    return contains and playerState[p].IsActionable == false
end

function CheckActionable(p)
    local actions = IsPlayerActionable(p)
    local anim = rws(players[p].AnimationID)
    local canAct = (actions.Movement and actions.Attack) or anim == 0
    playerState[p].IsActionable = canAct
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

    if blockstun > 8 or kd1 ~= 0 or kd2 ~= 0 or cancelAvailable == 5 or actionLock ~= 0 then
        actions.Movement = false
    end

    if p == 1 then
        DebugMessage = "Options: "
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
    end
    return actions
end

function ParseFrameData(p)
    playerState[p].SprTime, playerState[p].SprFrame = rw(players[p].SPRTime), rw(players[p].SPRFrame)

    local move_id = rws(players[p].AnimationID)
    local is_active = (rws(players[p].AttackState) ~= 0)
    local is_vulnerable = 0

    if move_id == playerState[p].CurrentAnimation or isNeutralFrame(p) then
        if isFrozen(p) == false then
            playerState[p].CurrentFrame = playerState[p].CurrentFrame + 1
        end
        if is_active then
            if playerState[p].Startup == -1 then
                if isFrozen(p) == false then
                    playerState[p].Startup = playerState[p].CurrentFrame
                else
                    playerState[p].Startup = playerState[p].CurrentFrame + 1
                end
            end
            -- manage gaps in active frames
            if playerState[p].LastHitEndFrame < playerState[p].CurrentFrame and playerState[p].LastHitStartFrame < playerState[p].LastHitEndFrame then
                if isFrozen(p) == false then
                    playerState[p].LastHitStartFrame = playerState[p].CurrentFrame
                else
                    playerState[p].LastHitStartFrame = playerState[p].CurrentFrame + 1
                end
            end
            playerState[p].Active = playerState[p].CurrentFrame - playerState[p].Startup + 1
        else
            -- not currently active, add active period to activeStr
            if playerState[p].LastHitStartFrame > playerState[p].LastHitEndFrame then
                -- not active anymore, use previous currentFrame value
                if isFrozen(p) == false then
                    playerState[p].LastHitEndFrame = playerState[p].CurrentFrame - 1
                else
                    playerState[p].LastHitEndFrame = playerState[p].CurrentFrame
                end
                formatActiveString(1)
            end
        end
    else
        if playerState[p].Startup ~= -1 then
            -- manage any hanging active periods
            if playerState[p].LastHitStartFrame > playerState[p].LastHitEndFrame then
                playerState[p].LastHitEndFrame = playerState[p].CurrentFrame
                formatActiveString(1)
            end
            playerState[p].Recovery = playerState[p].CurrentFrame -
                ((playerState[p].Startup - 1) + playerState[p].Active)
            -- -1 because using first active for startup
            if p == 1 then
                FrameDataOutput = "Move ID " .. formatHex(playerState[p].CurrentAnimation) ..
                    ": S" ..
                    playerState[p].Startup ..
                    " A" ..
                    playerState[p].Active ..
                    "(" .. playerState[p].ActiveString .. ") R" .. playerState[p].Recovery .. " (T" ..
                    playerState[p].Startup + playerState[p].Active + playerState[p].Recovery - 1 .. ")"
            end
        end
        playerState[p].CurrentFrame, playerState[p].CurrentAnimation, playerState[p].Startup, playerState[p].Active, playerState[p].Recovery, playerState[p].ActiveString, playerState[p].LastHitStartFrame, playerState[p].LastHitEndFrame =
            1, move_id, -1, -1, -1, "", -2, -1
    end
    if p == 1 then NowActive = formatHex(move_id) .. "." .. playerState[1].CurrentFrame end
end

function ParseProjectileData(p)
    local move_id = rws(players[p].AnimationID)
    playerState[p].ProjActive = checkForActiveProjectiles(p)

    if playerState[p].ProjActive then
        if playerState[p].ProjStartup == -1 then
            -- new projectile
            playerState[p].ProjFrame = playerState[p].CurrentFrame

            playerState[p].ProjStartup = playerState[p].ProjFrame
            playerState[p].ProjMoveID = move_id
        else
            if isFrozen(p) == false then
                playerState[p].ProjFrame = playerState[p].ProjFrame + 1
            end
            -- check if spawning move still ongoing
            if playerState[p].ProjMoveID == move_id or isNeutralFrame(p) then
                playerState[p].ProjAnimLength = playerState[p].ProjFrame
            end
        end
        playerState[p].ProjActiveTime = (playerState[p].ProjFrame - playerState[p].ProjStartup) + 1
    else
        -- check if spawning move still ongoing
        if playerState[p].ProjMoveID == move_id or isNeutralFrame(p) then
            if isFrozen(p) then
                playerState[p].ProjFrame = playerState[p].ProjFrame + 1
            end
            playerState[p].ProjAnimLength = playerState[p].ProjFrame
        else
            if playerState[p].ProjStartup ~= -1 then
                -- format projectile string
                if p == 1 then
                    ProjectileDataOutput = "S" ..
                        playerState[p].ProjStartup .. " A" .. playerState[p].ProjActiveTime ..
                        " - Anim: " .. playerState[p].ProjAnimLength .. "T";
                end
                playerState[p].ProjStartup, playerState[p].ProjFrame, playerState[p].ProjActiveTime, playerState[p].ProjAnimLength, playerState[p].ProjMoveID =
                    -1, -1, -1, -1, -1
            end
        end
    end
end

function ParseFrameAdv()
    if playerState[1].IsActionable then
        -- p1 is actionable, increment the counter
        if isFrozen(1) == false then
            playerState[1].FramesSinceActionable = playerState[1].FramesSinceActionable + 1
        end
    else
        -- not actionable; reset the counter
        playerState[1].FramesSinceActionable = -1
    end

    if playerState[2].IsActionable then
        -- p2 is actionable, increment the counter
        if isFrozen(2) == false then
            playerState[2].FramesSinceActionable = playerState[2].FramesSinceActionable + 1
        end
    else
        -- not actionable; reset the counter
        playerState[2].FramesSinceActionable = -1
    end


    if playerState[1].IsActionable and playerState[2].IsActionable then
        formatAdvantage(playerState[1].FramesSinceActionable - playerState[2].FramesSinceActionable)
    end

    --DebugMessage = DebugMessage ..
    --    ". P1: " .. playerState[1].FramesSinceActionable .. ", P2: " .. playerState[2].FramesSinceActionable

    playerState[1].PrevTime, playerState[1].PrevFrame, playerState[1].PrevAnimation, playerState[2].PrevTime, playerState[2].PrevFrame, playerState[2].PrevAnimation =
        playerState[1].SprTime, playerState[1].SprFrame, playerState[1].CurrentAnimation, playerState[2].SprTime,
        playerState[2].SprFrame, playerState[2].CurrentAnimation
end
