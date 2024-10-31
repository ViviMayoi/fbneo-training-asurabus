local rb, rbs, rw, rws, rd = memory.readbyte, memory.readbytesigned, memory.readword, memory.readwordsigned,
    memory.readdword

-- HitboxActive = false
-- ProjectileStart = 0
-- ProjectileEnd = 0
-- ProjectileFrames = 0
-- ProjectileID = 0
-- ProjectileOn = false

DebugMessage = "How did you see this?";

-- function CheckProjectile()
--     local ProjectileOnScreen = false;
--     local AttackState = rw(0x004033F8)

--     for i = 0, 31, 1 do
--         local On   = rbs(0x004039B0 + (i * 0x10))
--         local ID   = rws(0x004039B2 + (i * 0x10))
--         local Time = rb(0x004039BB + (i * 0x10))
--         local Hit  = rbs(0x004039BF + (i * 0x10))

--         if (On > 0 and Hit == 1) then
--             ProjectileOnScreen = true;
--             ProjectileFrames = Time;
--             ProjectileID = ID;

--             if (AttackState ~= 0) then
--                 if (HitboxActive == false) then
--                     ProjectileStart = ProjectileFrames
--                     HitboxActive = true
--                 end
--             elseif (HitboxActive == true) then
--                 ProjectileEnd = ProjectileFrames - 2;
--                 HitboxActive = false;
--             end
--         end
--     end

--     if (ProjectileOnScreen == false and ProjectileOn == true) then
--         if (ProjectileEnd == 0) then
--             ProjectileEnd = ProjectileFrames
--             HitboxActive = false
--         end
--         ProjectileMessage = "Projectile " .. ProjectileID ..  ": " .. ProjectileFrames .. "F on screen, active F"
--             .. ProjectileStart .. "-" .. ProjectileEnd  .. "(" .. ProjectileEnd + 1 - ProjectileStart .. ")";
--         HitboxActive = false;

--         ProjectileStart = 0
--         ProjectileEnd = 0
--         ProjectileFrames = 0
--     end

--     ProjectileOn = ProjectileOnScreen
--     --end
-- end


-- p1_alice_hidden_623X_projectile_data = {
--    Version = -1,
--    ActiveProjectile = {},
--}
--for i = -1, 31, 1 do
--    p1_alice_hidden_623X_projectile_data.ActiveProjectile[i] = -1;
--end
