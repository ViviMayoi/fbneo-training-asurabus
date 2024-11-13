require("/games/asurabus/asurabus")
require("/games/asurabus/memory_addresses")
require("/games/asurabus/constants")
require("/games/asurabus/gamestate")

local rb, rbs, rw, rws, rd = memory.readbyte, memory.readbytesigned, memory.readword, memory.readwordsigned,
	memory.readdword
CameraX = 0xA0

function P1() --P1 Info
	local XPos_SCR     = rws(0x004033CE)
	local YPos_SCR     = rws(0x004033D0)
	local Facing       = rws(0x004033DA)
	local ATKState     = rws(0x004033F0)
	local Character    = rws(0x004039A6)
	local Boost        = rws(0x00403F56) ~= 0

	skullBgColor       = 0x00000040
	skullBorderColor   = 0x000000FF

	--Hitbox 1
	local A1_XR        = rws(0x004033F6)
	local A1_YT        = rws(0x004033F8)
	local A1_XL        = rws(0x004033FA)
	local A1_YB        = rws(0x004033FC)
	--Hitbox 2
	local A2_XR        = rws(0x004033FE)
	local A2_YT        = rws(0x00403400)
	local A2_XL        = rws(0x00403402)
	local A2_YB        = rws(0x00403404)
	--Clashbox
	local C1_XR        = rws(0x00403406)
	local C1_YT        = rws(0x00403408)
	local C1_XL        = rws(0x0040340A)
	local C1_YB        = rws(0x0040340C)

	--Pushbox
	local P_XR         = rws(0x00403504)
	local P_YT         = rws(0x00403506)
	local P_XL         = rws(0x00403508)
	local P_YB         = rws(0x0040350A)
	--Hurtbox 1
	local H1_XR        = rws(0x0040350C)
	local H1_YT        = rws(0x0040350E)
	local H1_XL        = rws(0x00403510)
	local H1_YB        = rws(0x00403512)
	--Hurtbox 2
	local H2_XR        = rws(0x00403514)
	local H2_YT        = rws(0x00403516)
	local H2_XL        = rws(0x00403518)
	local H2_YB        = rws(0x0040351A)

	-------------------------------------
	-- DMW/Afterimages
	local DMW_XPos_SCR = rws(0x00404D42)
	local DMW_YPos_SCR = rws(0x00404D44)
	local DMW_Facing   = rws(0x00404D4E)
	local DMW_ATKState = rws(0x00404D64)
	--Hitbox 1
	local DMW_A1_XR    = rws(0x00404D6A)
	local DMW_A1_YT    = rws(0x00404D6C)
	local DMW_A1_XL    = rws(0x00404D6E)
	local DMW_A1_YB    = rws(0x00404D70)
	--Hitbox 2
	local DMW_A2_XR    = rws(0x00404D72)
	local DMW_A2_YT    = rws(0x00404D74)
	local DMW_A2_XL    = rws(0x00404D76)
	local DMW_A2_YB    = rws(0x00404D78)
	--Clashbox
	local DMW_C1_XR    = rws(0x00404D7A)
	local DMW_C1_YT    = rws(0x00404D7C)
	local DMW_C1_XL    = rws(0x00404D7E)
	local DMW_C1_YB    = rws(0x00404D80)
	-------------------------------------

	-------------------------------------
	-- Projectiles
	local A_XR         = rws(0x00404030)
	local A_YT         = rws(0x00404032)
	local A_XL         = rws(0x00404034)
	local A_YB         = rws(0x00404036)

	for i = 0, 31, 1 do
		local On     = rbs(0x004039B0 + (i * 0x10))
		local Type   = rbs(0x004039B1 + (i * 0x10))
		local ID     = rws(0x004039B2 + (i * 0x10))
		local XPos   = rws(0x004039B4 + (i * 0x10))
		local YPos   = rws(0x004039B6 + (i * 0x10))
		local Facing = rbs(0x004039B8 + (i * 0x10))
		local Time   = rbs(0x004039BB + (i * 0x10))
		local Hit    = rbs(0x004039BF + (i * 0x10))

		if (On > 0 and Type > 0 and Hit == 1) then
			local skipProjectile = false;
			-- extra checks for ＳＰＥＣＩＡＬ ＣＡＳＥＳ 🫠
			if (Character == ALICE_HIDDEN) then
				if (ID == 92 and Time > 60) then                      -- skip 214X inactive frames
					skipProjectile = true;
				elseif ((ID == 51 or ID == 95) and (Time < 13 or Time > 21)) then -- 623X is only active on frames 13 to 21 of being on screen
					skipProjectile = true;
				elseif (ID == 94 and (Time < 19 or Time > 27)) then   -- 623EX and boost 623C final hits are only active on frames 19 to 27 of being on screen
					skipProjectile = true;
				end
			elseif (ID == 15) then -- Zam-B 236X ground puddle
				skipProjectile = true;
			end
			if (skipProjectile == false) then
				if Facing == 1 then -- facing right
					gui.box(
						XPos - CameraX + A_XR,
						0 + (YPos) + A_YT - 1,
						XPos - CameraX + A_XL,
						0 + (YPos) + A_YB - 1,
						0xFF000030, 0xFF0000FF)
					gui.drawline((XPos - CameraX - 3), YPos, (XPos - CameraX + 3), YPos, 0xFFFFFFFF)
					gui.drawline(XPos - CameraX, (-3 + YPos), XPos - CameraX, (3 + YPos), 0xFFFFFFFF)
				else -- facing left
					gui.box(
						XPos - CameraX - A_XR + 1,
						0 + (YPos) + A_YT - 1,
						XPos - CameraX - A_XL + 1,
						0 + (YPos) + A_YB - 1,
						0xFF000030,
						0xFF0000FF)
					gui.drawline((XPos - CameraX - 3), YPos, (XPos - CameraX + 3), YPos, 0xFFFFFFFF)
					gui.drawline(XPos - CameraX, (-3 + YPos), XPos - CameraX, (3 + YPos), 0xFFFFFFFF)
				end
				skullBgColor = 0xFF000030
				skullBorderColor = 0xFF0000FF
			end
		end
	end
	-------------------------------------
	----------------------------------------
	--Alice! Boost Mode Skulls
	if (Boost and Character == ALICE_HIDDEN) then
		local pX      = 0x00403E74
		local pY      = 0x00403E76
		local pATK    = 0x00403E7C
		local pActive = 0x00403E92
		-- pNextActiveSkull = 0x403477

		local XPos    = rws(pX)
		local YPos    = rws(pY)
		local ATK     = rws(pATK)
		local Active  = rws(pY)

		for i = 0, 3, 1 do
			XPos            = rws(pX)
			YPos            = rws(pY)
			ATK             = rws(pATK)
			Active          = rws(pActive)

			pX              = pX + 0x20
			pY              = pY + 0x20
			pATK            = pATK + 0x20
			pActive         = pActive + 0x20
			local axisColor = 0x00000080

			if (ATKState > 0) then
				skullBgColor = 0xFF000030
				skullBorderColor = 0xFF0000FF
			end

			if Active > 0 then
				if ATK > 0 then
					if ATK == 1 then
						if Facing == 0 then
							gui.box(
								XPos - CameraX - 15,
								YPos - 7,
								XPos - CameraX + 15,
								YPos + 6,
								skullBgColor, skullBorderColor)
						else
							gui.box(
								XPos - CameraX - 16,
								YPos - 7,
								XPos - CameraX + 14,
								YPos + 6,
								skullBgColor, skullBorderColor)
						end
						axisColor = 0xFFFFFFFF;
					else
						axisColor = 0xFFFF00FF;
					end
					gui.drawline((XPos - CameraX - 3), YPos, (XPos - CameraX + 3), YPos, axisColor)
					gui.drawline(XPos - CameraX, (-3 + YPos), XPos - CameraX, (3 + YPos), axisColor)
				elseif (i <= 1) then
					gui.drawline((XPos - CameraX - 3), YPos, (XPos - CameraX + 3), YPos, axisColor)
					gui.drawline(XPos - CameraX, (-3 + YPos), XPos - CameraX, (3 + YPos), axisColor)
				end
			end
		end
	end
	-------------------------------------

	-------------------------------------
	--Draw Boxes

	--Pushbox
	if (P_XR or P_YT or P_XL or P_YB ~= 0) and Facing == 1 then
		gui.box(
			XPos_SCR + P_XR,
			0 + (YPos_SCR) + P_YT,
			XPos_SCR + P_XL,
			0 + (YPos_SCR) + P_YB,
			0x00FF0030,
			0x00FF00FF)
	elseif (P_XR or P_YT or P_XL or P_YB ~= 0) and Facing == 0 then
		gui.box(
			XPos_SCR + P_XR,
			0 + (YPos_SCR) + P_YT,
			XPos_SCR + P_XL,
			0 + (YPos_SCR) + P_YB,
			0x00FF0030,
			0x00FF00FF)
	end

	--Hurtbox 1
	if (H1_XR or H1_YT or H1_XL or H1_YB ~= 0) and Facing == 1 then
		gui.box(
			XPos_SCR + H1_XR,
			0 + (YPos_SCR) + H1_YT,
			XPos_SCR + H1_XL,
			0 + (YPos_SCR) + H1_YB,
			0x7777FF30,
			0x7777FFFF)
	elseif (H1_XR or H1_YT or H1_XL or H1_YB ~= 0) and Facing == 0 then
		gui.box(
			XPos_SCR + H1_XR,
			0 + (YPos_SCR) + H1_YT,
			XPos_SCR + H1_XL,
			0 + (YPos_SCR) + H1_YB,
			0x7777FF30,
			0x7777FFFF)
	end

	--Hurtbox 2
	if (H2_XR or H2_YT or H2_XL or H2_YB ~= 0) and Facing == 1 then
		gui.box(
			XPos_SCR + H2_XR,
			0 + (YPos_SCR) + H2_YT,
			XPos_SCR + H2_XL,
			0 + (YPos_SCR) + H2_YB,
			0x7777FF30,
			0x7777FFFF)
	elseif (H2_XR or H2_YT or H2_XL or H2_YB ~= 0) and Facing == 0 then
		gui.box(
			XPos_SCR + H2_XR,
			0 + (YPos_SCR) + H2_YT,
			XPos_SCR + H2_XL,
			0 + (YPos_SCR) + H2_YB,
			0x7777FF30,
			0x7777FFFF)
	end

	--Hitbox 1
	if ATKState > 0 and Facing == 1 then
		gui.box(
			XPos_SCR + A1_XR - 1,
			0 + (YPos_SCR) + A1_YT - 1,
			XPos_SCR + A1_XL - 1,
			0 + (YPos_SCR) + A1_YB - 1,
			0xFF000030,
			0xFF0000FF)
	elseif ATKState > 0 and Facing == 0 then
		gui.box(
			XPos_SCR + A1_XR,
			0 + (YPos_SCR) + A1_YT - 1,
			XPos_SCR + A1_XL,
			0 + (YPos_SCR) + A1_YB - 1,
			0xFF000030,
			0xFF0000FF)
	end

	--Hitbox 2
	if ATKState > 0 and Facing == 1 then
		gui.box(
			XPos_SCR + A2_XR - 1,
			0 + (YPos_SCR) + A2_YT - 1,
			XPos_SCR + A2_XL - 1,
			0 + (YPos_SCR) + A2_YB - 1,
			0xFF000030,
			0xFF0000FF)
	elseif ATKState > 0 and Facing == 0 then
		gui.box(
			XPos_SCR + A2_XR,
			0 + (YPos_SCR) + A2_YT - 1,
			XPos_SCR + A2_XL,
			0 + (YPos_SCR) + A2_YB - 1,
			0xFF000030,
			0xFF0000FF)
	end

	--Clash Hitbox
	if ATKState > 0 and Facing == 1 then
		gui.box(
			XPos_SCR + C1_XR - 1,
			0 + (YPos_SCR) + C1_YT - 1,
			XPos_SCR + C1_XL - 1,
			0 + (YPos_SCR) + C1_YB - 1,
			0xFFFF0030,
			0xFFFF00FF)
	elseif ATKState > 0 and Facing == 0 then
		gui.box(
			XPos_SCR + C1_XR,
			0 + (YPos_SCR) + C1_YT - 1,
			XPos_SCR + C1_XL,
			0 + (YPos_SCR) + C1_YB - 1,
			0xFFFF0030,
			0xFFFF00FF)
	end

	gui.drawline((XPos_SCR - 3), YPos_SCR, (XPos_SCR + 3), YPos_SCR, 0xFFFFFFFF)
	gui.drawline(XPos_SCR, (-3 + YPos_SCR), XPos_SCR, (3 + YPos_SCR), 0xFFFFFFFF)
	-------------------------------------

	-------------------------------------
	-- Draw DMW/Afterimages Boxes

	--Hitbox 1
	if Character == 06 then --Are you Alice?
		if DMW_ATKState > 0 and DMW_Facing == 1 then
			gui.box(
				DMW_XPos_SCR + DMW_A1_XR - 1,
				0 + (DMW_YPos_SCR) + DMW_A1_YT - 1,
				DMW_XPos_SCR + DMW_A1_XL - 1,
				0 + (DMW_YPos_SCR) + DMW_A1_YB - 1,
				0xFF000030,
				0xFF0000FF)
		elseif DMW_ATKState > 0 and DMW_Facing == 0 then
			gui.box(
				DMW_XPos_SCR + DMW_A1_XR,
				0 + (DMW_YPos_SCR) + DMW_A1_YT - 1,
				DMW_XPos_SCR + DMW_A1_XL,
				0 + (DMW_YPos_SCR) + DMW_A1_YB - 1,
				0xFF000030,
				0xFF0000FF)
		end
	end

	--Hitbox 2
	if Character == 06 then --Are you Alice?
		if DMW_ATKState > 0 and DMW_Facing == 1 then
			gui.box(
				DMW_XPos_SCR + DMW_A2_XR - 1,
				0 + (DMW_YPos_SCR) + DMW_A2_YT - 1,
				DMW_XPos_SCR + DMW_A2_XL - 1,
				0 + (DMW_YPos_SCR) + DMW_A2_YB - 1,
				0xFF000030,
				0xFF0000FF)
		elseif DMW_ATKState > 0 and DMW_Facing == 0 then
			gui.box(
				DMW_XPos_SCR + DMW_A2_XR,
				0 + (DMW_YPos_SCR) + DMW_A2_YT - 1,
				DMW_XPos_SCR + DMW_A2_XL,
				0 + (DMW_YPos_SCR) + DMW_A2_YB - 1,
				0xFF000030,
				0xFF0000FF)
		end
	end

	--Hitbox 1
	if (Character == 00 or Character == 03 or Character == 08) and Boost then --Are you Yashaou/Chen-Mao/Sittara?
		if DMW_ATKState > 0 and DMW_Facing == 1 then
			gui.box(
				DMW_XPos_SCR + DMW_A1_XR - 1,
				0 + (DMW_YPos_SCR) + DMW_A1_YT - 1,
				DMW_XPos_SCR + DMW_A1_XL - 1,
				0 + (DMW_YPos_SCR) + DMW_A1_YB - 1,
				0xFF000030,
				0xFF0000FF)
		elseif DMW_ATKState > 0 and DMW_Facing == 0 then
			gui.box(
				DMW_XPos_SCR + DMW_A1_XR,
				0 + (DMW_YPos_SCR) + DMW_A1_YT - 1,
				DMW_XPos_SCR + DMW_A1_XL,
				0 + (DMW_YPos_SCR) + DMW_A1_YB - 1,
				0xFF000030,
				0xFF0000FF)
		end
	end

	--Hitbox 2
	if (Character == 00 or Character == 03 or Character == 08) and Boost then --Are you Yashaou/Chen-Mao/Sittara?
		if DMW_ATKState > 0 and DMW_Facing == 1 then
			gui.box(
				DMW_XPos_SCR + DMW_A2_XR - 1,
				0 + (DMW_YPos_SCR) + DMW_A2_YT - 1,
				DMW_XPos_SCR + DMW_A2_XL - 1,
				0 + (DMW_YPos_SCR) + DMW_A2_YB - 1,
				0xFF000030,
				0xFF0000FF)
		elseif DMW_ATKState > 0 and DMW_Facing == 0 then
			gui.box(
				DMW_XPos_SCR + DMW_A2_XR,
				0 + (DMW_YPos_SCR) + DMW_A2_YT - 1,
				DMW_XPos_SCR + DMW_A2_XL,
				0 + (DMW_YPos_SCR) + DMW_A2_YB - 1,
				0xFF000030,
				0xFF0000FF)
		end
	end

	--Clashbox
	if (Character == 00 or Character == 03 or Character == 08) and Boost then --Are you Yashaou/Chen-Mao/Sittara?
		if DMW_ATKState > 0 and DMW_Facing == 1 then
			gui.box(
				DMW_XPos_SCR + DMW_C1_XR - 1,
				0 + (DMW_YPos_SCR) + DMW_C1_YT - 1,
				DMW_XPos_SCR + DMW_C1_XL - 1,
				0 + (DMW_YPos_SCR) + DMW_C1_YB - 1,
				0xFFFF0030,
				0xFFFF00FF)
		elseif DMW_ATKState > 0 and DMW_Facing == 0 then
			gui.box(
				DMW_XPos_SCR + DMW_C1_XR,
				0 + (DMW_YPos_SCR) + DMW_C1_YT - 1,
				DMW_XPos_SCR + DMW_C1_XL,
				0 + (DMW_YPos_SCR) + DMW_C1_YB - 1,
				0xFFFF0030,
				0xFFFF00FF)
		end
	end

	--DMW Axis
	if Character == 06 then --Are you Alice?
		gui.drawline((DMW_XPos_SCR - 3), DMW_YPos_SCR, (DMW_XPos_SCR + 3), DMW_YPos_SCR, 0xFFFFFFFF)
		gui.drawline(DMW_XPos_SCR, (-3 + DMW_YPos_SCR), DMW_XPos_SCR, (3 + DMW_YPos_SCR), 0xFFFFFFFF)
	end

	--Afterimage Axis
	if (Character == 00 or Character == 03 or Character == 08) and Boost then --Are you Yashaou/Chen-Mao/Sittara?
		gui.drawline((DMW_XPos_SCR - 3), DMW_YPos_SCR, (DMW_XPos_SCR + 3), DMW_YPos_SCR, 0xFFFFFFFF)
		gui.drawline(DMW_XPos_SCR, (-3 + DMW_YPos_SCR), DMW_XPos_SCR, (3 + DMW_YPos_SCR), 0xFFFFFFFF)
	end

	-------------------------------------
end

function P2() --P2 Info
	local XPos_SCR     = rws(0x00404084)
	local YPos_SCR     = rws(0x00404086)
	local Facing       = rws(0x00404090)
	local ATKState     = rws(0x004040A8)
	local Character    = rws(0x00404666)
	local Boost        = rws(0x00404C16) ~= 0

	skullBgColor       = 0x00000040
	skullBorderColor   = 0x000000FF

	local A1_XR        = rws(0x004040AE)
	local A1_YT        = rws(0x004040B0)
	local A1_XL        = rws(0x004040B2)
	local A1_YB        = rws(0x004040B4)
	local A2_XR        = rws(0x004040B6)
	local A2_YT        = rws(0x004040B8)
	local A2_XL        = rws(0x004040BA)
	local A2_YB        = rws(0x004040BC)
	local C1_XR        = rws(0x004040BE)
	local C1_YT        = rws(0x004040C0)
	local C1_XL        = rws(0x004040C2)
	local C1_YB        = rws(0x004040C4)

	local P_XR         = rws(0x004041BE)
	local P_YT         = rws(0x004041C0)
	local P_XL         = rws(0x004041C2)
	local P_YB         = rws(0x004041C4)
	local H1_XR        = rws(0x004041C6)
	local H1_YT        = rws(0x004041C8)
	local H1_XL        = rws(0x004041CA)
	local H1_YB        = rws(0x004041CC)
	local H2_XR        = rws(0x004041CE)
	local H2_YT        = rws(0x004041D0)
	local H2_XL        = rws(0x004041D2)
	local H2_YB        = rws(0x004041D4)

	-------------------------------------
	-- Alice Stuff
	local DMW_XPos_SCR = rws(0x004059E2)
	local DMW_YPos_SCR = rws(0x004059E4)
	local DMW_Facing   = rws(0x004059EE)
	local DMW_ATKState = rws(0x00405A04)
	local DMW_A1_XR    = rws(0x00405A0A) --Hitbox 1
	local DMW_A1_YT    = rws(0x00405A0C)
	local DMW_A1_XL    = rws(0x00405A0E)
	local DMW_A1_YB    = rws(0x00405A10)
	local DMW_A2_XR    = rws(0x00405A12) --Hitbox 2
	local DMW_A2_YT    = rws(0x00405A14)
	local DMW_A2_XL    = rws(0x00405A16)
	local DMW_A2_YB    = rws(0x00405A18)
	local DMW_C1_XR    = rws(0x00405A1A) --Clashbox
	local DMW_C1_YT    = rws(0x00405A1C)
	local DMW_C1_XL    = rws(0x00405A1E)
	local DMW_C1_YB    = rws(0x00405A20)
	-------------------------------------

	-------------------------------------
	-- Projectiles
	local A_XR         = rws(0x00404CF0)
	local A_YT         = rws(0x00404CF2)
	local A_XL         = rws(0x00404CF4)
	local A_YB         = rws(0x00404CF6)

	for i = 0, 31, 1 do
		local On     = rbs(0x00404670 + (i * 0x10))
		local Type   = rbs(0x00404671 + (i * 0x10))
		local ID     = rws(0x00404672 + (i * 0x10))
		local XPos   = rws(0x00404674 + (i * 0x10))
		local YPos   = rws(0x00404676 + (i * 0x10))
		local Facing = rbs(0x00404678 + (i * 0x10))
		local Time   = rbs(0x0040467B + (i * 0x10))
		local Hit    = rbs(0x0040467F + (i * 0x10))

		if (On > 0 and Type > 0 and Hit == 1) then
			local skipProjectile = false;
			-- extra checks for ＳＰＥＣＩＡＬ ＣＡＳＥＳ 🫠
			if (Character == ALICE_HIDDEN) then
				if (ID == 92 and Time > 60) then                      -- skip 214X inactive frames
					skipProjectile = true;
				elseif ((ID == 51 or ID == 95) and (Time < 13 or Time > 21)) then -- 623X is only active on frames 13 to 21 of being on screen
					skipProjectile = true;
				elseif (ID == 94 and (Time < 19 or Time > 27)) then   -- 623EX and boost 623C final hits are only active on frames 19 to 27 of being on screen
					skipProjectile = true;
				end
			elseif (ID == 15) then -- Zam-B 236X ground puddle
				skipProjectile = true;
			end
			if (skipProjectile == false) then
				if Facing == 1 then
					gui.box(
						XPos - CameraX + A_XR - 1,
						0 + (YPos) + A_YT - 1,
						XPos - CameraX + A_XL - 1,
						0 + (YPos) + A_YB - 1,
						0xFF000030,
						0xFF0000FF)
					gui.drawline((XPos - CameraX - 3), YPos, (XPos - CameraX + 3), YPos, 0xFFFFFFFF)
					gui.drawline(XPos - CameraX, (-3 + YPos), XPos - CameraX, (3 + YPos), 0xFFFFFFFF)
				else
					gui.box(
						XPos - CameraX + A_XR,
						0 + (YPos) + A_YT - 1,
						XPos - CameraX + A_XL,
						0 + (YPos) + A_YB - 1,
						0xFF000030,
						0xFF0000FF)
					gui.drawline((XPos - CameraX - 3), YPos, (XPos - CameraX + 3), YPos, 0xFFFFFFFF)
					gui.drawline(XPos - CameraX, (-3 + YPos), XPos - CameraX, (3 + YPos), 0xFFFFFFFF)
				end
			end
		end
	end
	-------------------------------------

	-------------------------------------
	--Alice! Boost Mode Skulls
	if (Boost and Character == ALICE_HIDDEN) then
		local pX      = 0x00404B34
		local pY      = 0x00404B36
		local pATK    = 0x00404B3C
		local pActive = 0x00404B52

		if (ATKState > 0) then
			skullBgColor = 0xFF000030
			skullBorderColor = 0xFF0000FF
		end

		for i = 0, 3, 1 do
			local XPos      = rws(pX)
			local YPos      = rws(pY)
			local ATK       = rws(pATK)
			local Active    = rws(pActive)

			pX              = pX + 0x20
			pY              = pY + 0x20
			pATK            = pATK + 0x20
			pActive         = pActive + 0x20

			local axisColor = 0x00000080
			if (Active > 0) then
				if ATK > 0 then
					if ATK == 1 then
						if Facing == 0 then
							gui.box(
								XPos - CameraX - 15,
								YPos - 7,
								XPos - CameraX + 15,
								YPos + 6,
								skullBgColor, skullBorderColor)
						else
							gui.box(
								XPos - CameraX - 16,
								YPos - 7,
								XPos - CameraX + 14,
								YPos + 6,
								skullBgColor, skullBorderColor)
						end
						axisColor = 0xFFFFFFFF;
					else
						axisColor = 0xFFFF00FF;
					end
					gui.drawline((XPos - CameraX - 3), YPos, (XPos - CameraX + 3), YPos, axisColor)
					gui.drawline(XPos - CameraX, (-3 + YPos), XPos - CameraX, (3 + YPos), axisColor)
				elseif (i <= 1) then
					gui.drawline((XPos - CameraX - 3), YPos, (XPos - CameraX + 3), YPos, axisColor)
					gui.drawline(XPos - CameraX, (-3 + YPos), XPos - CameraX, (3 + YPos), axisColor)
				end
			end
		end
	end
	-------------------------------------

	-------------------------------------
	--Draw Boxes

	--Pushbox
	if (P_XR or P_YT or P_XL or P_YB ~= 0) and Facing == 1 then
		gui.box(
			XPos_SCR + P_XR,
			0 + (YPos_SCR) + P_YT,
			XPos_SCR + P_XL,
			0 + (YPos_SCR) + P_YB,
			0x00FF0030,
			0x00FF00FF)
	elseif (P_XR or P_YT or P_XL or P_YB ~= 0) and Facing == 0 then
		gui.box(
			XPos_SCR + P_XR,
			0 + (YPos_SCR) + P_YT,
			XPos_SCR + P_XL,
			0 + (YPos_SCR) + P_YB,
			0x00FF0030,
			0x00FF00FF)
	end

	--Hurtbox 1
	if (H1_XR or H1_YT or H1_XL or H1_YB ~= 0) and Facing == 1 then
		gui.box(
			XPos_SCR + H1_XR,
			0 + (YPos_SCR) + H1_YT,
			XPos_SCR + H1_XL,
			0 + (YPos_SCR) + H1_YB,
			0x7777FF30,
			0x7777FFFF)
	elseif (H1_XR or H1_YT or H1_XL or H1_YB ~= 0) and Facing == 0 then
		gui.box(
			XPos_SCR + H1_XR,
			0 + (YPos_SCR) + H1_YT,
			XPos_SCR + H1_XL,
			0 + (YPos_SCR) + H1_YB,
			0x7777FF30,
			0x7777FFFF)
	end

	--Hurtbox 2
	if (H2_XR or H2_YT or H2_XL or H2_YB ~= 0) and Facing == 1 then
		gui.box(
			XPos_SCR + H2_XR,
			0 + (YPos_SCR) + H2_YT,
			XPos_SCR + H2_XL,
			0 + (YPos_SCR) + H2_YB,
			0x7777FF30,
			0x7777FFFF)
	elseif (H2_XR or H2_YT or H2_XL or H2_YB ~= 0) and Facing == 0 then
		gui.box(
			XPos_SCR + H2_XR,
			0 + (YPos_SCR) + H2_YT,
			XPos_SCR + H2_XL,
			0 + (YPos_SCR) + H2_YB,
			0x7777FF30,
			0x7777FFFF)
	end

	--Hitbox 1
	if ATKState > 0 and Facing == 1 then
		gui.box(
			XPos_SCR + A1_XR - 1,
			0 + (YPos_SCR) + A1_YT - 1,
			XPos_SCR + A1_XL - 1,
			0 + (YPos_SCR) + A1_YB - 1,
			0xFF000030,
			0xFF0000FF)
	elseif ATKState > 0 and Facing == 0 then
		gui.box(
			XPos_SCR + A1_XR,
			0 + (YPos_SCR) + A1_YT - 1,
			XPos_SCR + A1_XL,
			0 + (YPos_SCR) + A1_YB - 1,
			0xFF000030,
			0xFF0000FF)
	end

	--Hitbox 2
	if ATKState > 0 and Facing == 1 then
		gui.box(
			XPos_SCR + A2_XR - 1,
			0 + (YPos_SCR) + A2_YT - 1,
			XPos_SCR + A2_XL - 1,
			0 + (YPos_SCR) + A2_YB - 1,
			0xFF000030,
			0xFF0000FF)
	elseif ATKState > 0 and Facing == 0 then
		gui.box(
			XPos_SCR + A2_XR,
			0 + (YPos_SCR) + A2_YT - 1,
			XPos_SCR + A2_XL,
			0 + (YPos_SCR) + A2_YB - 1,
			0xFF000030,
			0xFF0000FF)
	end

	--Clash Hitbox
	if ATKState > 0 and Facing == 1 then
		gui.box(
			XPos_SCR + C1_XR - 1,
			0 + (YPos_SCR) + C1_YT - 1,
			XPos_SCR + C1_XL - 1,
			0 + (YPos_SCR) + C1_YB - 1,
			0xFFFF0030,
			0xFFFF00FF)
	elseif ATKState > 0 and Facing == 0 then
		gui.box(
			XPos_SCR + C1_XR,
			0 + (YPos_SCR) + C1_YT - 1,
			XPos_SCR + C1_XL,
			0 + (YPos_SCR) + C1_YB - 1,
			0xFFFF0030,
			0xFFFF00FF)
	end
	-------------------------------------

	-------------------------------------
	-- Draw DMW Boxes

	--Hitbox 1
	if Character == 6 then --Are you Alice?
		if DMW_ATKState > 0 and DMW_Facing == 1 then
			gui.box(
				DMW_XPos_SCR + DMW_A1_XR,
				0 + (DMW_YPos_SCR) + DMW_A1_YT - 1,
				DMW_XPos_SCR + DMW_A1_XL - 1,
				0 + (DMW_YPos_SCR) + DMW_A1_YB - 1,
				0xFF000030,
				0xFF0000FF)
		elseif DMW_ATKState > 0 and DMW_Facing == 0 then
			gui.box(
				DMW_XPos_SCR + DMW_A1_XR,
				0 + (DMW_YPos_SCR) + DMW_A1_YT - 1,
				DMW_XPos_SCR + DMW_A1_XL,
				0 + (DMW_YPos_SCR) + DMW_A1_YB - 1,
				0xFF000030,
				0xFF0000FF)
		end
	end

	--Hitbox 2
	if Character == 6 then --Are you Alice?
		if DMW_ATKState > 0 and DMW_Facing == 1 then
			gui.box(
				DMW_XPos_SCR + DMW_A2_XR,
				0 + (DMW_YPos_SCR) + DMW_A2_YT,
				DMW_XPos_SCR + DMW_A2_XL - 1,
				0 + (DMW_YPos_SCR) + DMW_A2_YB,
				0xFF000030,
				0xFF0000FF)
		elseif DMW_ATKState > 0 and DMW_Facing == 0 then
			gui.box(
				DMW_XPos_SCR + DMW_A2_XR,
				0 + (DMW_YPos_SCR) + DMW_A2_YT,
				DMW_XPos_SCR + DMW_A2_XL,
				0 + (DMW_YPos_SCR) + DMW_A2_YB,
				0xFF000030,
				0xFF0000FF)
		end
	end

	-------------------------------------
	-- Draw Afterimages Boxes

	--Hitbox 1
	if Character == 6 then --Are you Alice?
		if DMW_ATKState > 0 and DMW_Facing == 1 then
			gui.box(
				DMW_XPos_SCR + DMW_A1_XR - 1,
				0 + (DMW_YPos_SCR) + DMW_A1_YT - 1,
				DMW_XPos_SCR + DMW_A1_XL - 1,
				0 + (DMW_YPos_SCR) + DMW_A1_YB - 1,
				0xFF000030,
				0xFF0000FF)
		elseif DMW_ATKState > 0 and DMW_Facing == 0 then
			gui.box(
				DMW_XPos_SCR + DMW_A1_XR,
				0 + (DMW_YPos_SCR) + DMW_A1_YT - 1,
				DMW_XPos_SCR + DMW_A1_XL,
				0 + (DMW_YPos_SCR) + DMW_A1_YB - 1,
				0xFF000030,
				0xFF0000FF)
		end
	end

	--Hitbox 2
	if Character == 6 then --Are you Alice?
		if DMW_ATKState > 0 and DMW_Facing == 1 then
			gui.box(
				DMW_XPos_SCR + DMW_A2_XR - 1,
				0 + (DMW_YPos_SCR) + DMW_A2_YT - 1,
				DMW_XPos_SCR + DMW_A2_XL - 1,
				0 + (DMW_YPos_SCR) + DMW_A2_YB - 1,
				0xFF000030,
				0xFF0000FF)
		elseif DMW_ATKState > 0 and DMW_Facing == 0 then
			gui.box(
				DMW_XPos_SCR + DMW_A2_XR,
				0 + (DMW_YPos_SCR) + DMW_A2_YT - 1,
				DMW_XPos_SCR + DMW_A2_XL,
				0 + (DMW_YPos_SCR) + DMW_A2_YB - 1,
				0xFF000030,
				0xFF0000FF)
		end
	end

	--Hitbox 1
	if (Character == 0 or Character == 3 or Character == 8) and Boost == 1 then --Are you Yashaou/Chen-Mao/Sittara?
		if DMW_ATKState > 0 and DMW_Facing == 1 then
			gui.box(
				DMW_XPos_SCR + DMW_A1_XR - 1,
				0 + (DMW_YPos_SCR) + DMW_A1_YT - 1,
				DMW_XPos_SCR + DMW_A1_XL - 1,
				0 + (DMW_YPos_SCR) + DMW_A1_YB - 1,
				0xFF000030,
				0xFF0000FF)
		elseif DMW_ATKState > 0 and DMW_Facing == 0 then
			gui.box(
				DMW_XPos_SCR + DMW_A1_XR,
				0 + (DMW_YPos_SCR) + DMW_A1_YT - 1,
				DMW_XPos_SCR + DMW_A1_XL,
				0 + (DMW_YPos_SCR) + DMW_A1_YB - 1,
				0xFF000030,
				0xFF0000FF)
		end
	end

	--Hitbox 2
	if (Character == 0 or Character == 3 or Character == 8) and Boost == 1 then --Are you Yashaou/Chen-Mao/Sittara?
		if DMW_ATKState > 0 and DMW_Facing == 1 then
			gui.box(
				DMW_XPos_SCR + DMW_A2_XR - 1,
				0 + (DMW_YPos_SCR) + DMW_A2_YT - 1,
				DMW_XPos_SCR + DMW_A2_XL - 1,
				0 + (DMW_YPos_SCR) + DMW_A2_YB - 1,
				0xFF000030,
				0xFF0000FF)
		elseif DMW_ATKState > 0 and DMW_Facing == 0 then
			gui.box(
				DMW_XPos_SCR + DMW_A2_XR,
				0 + (DMW_YPos_SCR) + DMW_A2_YT - 1,
				DMW_XPos_SCR + DMW_A2_XL,
				0 + (DMW_YPos_SCR) + DMW_A2_YB - 1,
				0xFF000030,
				0xFF0000FF)
		end
	end

	--Clashbox
	if (Character == 0 or Character == 3 or Character == 8) and Boost == 1 then --Are you Yashaou/Chen-Mao/Sittara?
		if DMW_ATKState > 0 and DMW_Facing == 1 then
			gui.box(
				DMW_XPos_SCR + DMW_C1_XR - 1,
				0 + (DMW_YPos_SCR) + DMW_C1_YT - 1,
				DMW_XPos_SCR + DMW_C1_XL - 1,
				0 + (DMW_YPos_SCR) + DMW_C1_YB - 1,
				0xFFFF0030,
				0xFFFF00FF)
		elseif DMW_ATKState > 0 and DMW_Facing == 0 then
			gui.box(
				DMW_XPos_SCR + DMW_C1_XR,
				0 + (DMW_YPos_SCR) + DMW_C1_YT - 1,
				DMW_XPos_SCR + DMW_C1_XL,
				0 + (DMW_YPos_SCR) + DMW_C1_YB - 1,
				0xFFFF0030,
				0xFFFF00FF)
		end
	end

	--DMW Axis
	if Character == 06 then --Are you Alice?
		gui.drawline((DMW_XPos_SCR - 3), DMW_YPos_SCR, (DMW_XPos_SCR + 3), DMW_YPos_SCR, 0xFFFFFFFF)
		gui.drawline(DMW_XPos_SCR, (-3 + DMW_YPos_SCR), DMW_XPos_SCR, (3 + DMW_YPos_SCR), 0xFFFFFFFF)
	end

	--Afterimage Axis
	if (Character == 00 or Character == 03 or Character == 08) and Boost == 01 then --Are you Yashaou/Chen-Mao/Sittara?
		gui.drawline((DMW_XPos_SCR - 3), DMW_YPos_SCR, (DMW_XPos_SCR + 3), DMW_YPos_SCR, 0xFFFFFFFF)
		gui.drawline(DMW_XPos_SCR, (-3 + DMW_YPos_SCR), DMW_XPos_SCR, (3 + DMW_YPos_SCR), 0xFFFFFFFF)
	end

	-------------------------------------

	gui.drawline((XPos_SCR - 3), YPos_SCR, (XPos_SCR + 3), YPos_SCR, 0xFFFFFFFF)
	gui.drawline(XPos_SCR, (-3 + YPos_SCR), XPos_SCR, (3 + YPos_SCR), 0xFFFFFFFF)
end

function hitboxesReg()
	if hitboxes.enabled then
		P1();
		P2();
	end
end

function hitboxesRegAfter()
	CameraX = rws(0x00400024)
end
