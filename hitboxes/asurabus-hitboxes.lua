local rb, rbs, rw, rws, rd = memory.readbyte, memory.readbytesigned, memory.readword, memory.readwordsigned, memory.readdword


function P1() --P1 Info

XPos_SCR=rws(0x004033CE)
YPos_SCR=rws(0x004033D0)
Facing=rws(0x004033DA)
ATKState=rws(0x004033F0)
Char=rws(0x004039A6)

A1_XR=rws(0x004033F6)
A1_YT=rws(0x004033F8)
A1_XL=rws(0x004033FA)
A1_YB=rws(0x004033FC)
A2_XR=rws(0x004033FE)
A2_YT=rws(0x00403400)
A2_XL=rws(0x00403402)
A2_YB=rws(0x00403404)
C1_XR=rws(0x00403406)
C1_YT=rws(0x00403408)
C1_XL=rws(0x0040340A)
C1_YB=rws(0x0040340C)

P_XR=rws(0x00403504)
P_YT=rws(0x00403506)
P_XL=rws(0x00403508)
P_YB=rws(0x0040350A)
H1_XR=rws(0x0040350C)
H1_YT=rws(0x0040350E)
H1_XL=rws(0x00403510)
H1_YB=rws(0x00403512)
H2_XR=rws(0x00403514)
H2_YT=rws(0x00403516)
H2_XL=rws(0x00403518)
H2_YB=rws(0x0040351A)

-------------------------------------
-- Alice Stuff
DMW_XPos_SCR=rws(0x00404D42)
DMW_YPos_SCR=rws(0x00404D44)
DMW_Facing=rws(0x00404D4E)
DMW_ATKState=rws(0x00404D64)
DMW_A1_XR=rws(0x00404D6A)
DMW_A1_YT=rws(0x00404D6C)
DMW_A1_XL=rws(0x00404D6E)
DMW_A1_YB=rws(0x00404D70)
DMW_A2_XR=rws(0x00404D72)
DMW_A2_YT=rws(0x00404D74)
DMW_A2_XL=rws(0x00404D76)
DMW_A2_YB=rws(0x00404D78)
-------------------------------------

-------------------------------------
--Draw Boxes

--Pushbox
if (P_XR or P_YT or P_XL or P_YB ~=0) and Facing == 1 then
		gui.box(
		XPos_SCR+P_XR,
		0+(YPos_SCR)+P_YT,
		XPos_SCR+P_XL,
		0+(YPos_SCR)+P_YB,
		0x00FF0030,
		0x00FF00FF)
elseif (P_XR or P_YT or P_XL or P_YB ~=0) and Facing == 0 then
		gui.box(
		XPos_SCR+P_XR-1,
		0+(YPos_SCR)+P_YT,
		XPos_SCR+P_XL-1,
		0+(YPos_SCR)+P_YB,
		0x00FF0030,
		0x00FF00FF)
end

--Hurtbox 1
if (H1_XR or H1_YT or H1_XL or H1_YB ~=0) and Facing == 1 then
		gui.box(
		XPos_SCR+H1_XR,
		0+(YPos_SCR)+H1_YT,
		XPos_SCR+H1_XL,
		0+(YPos_SCR)+H1_YB,
		0x7777FF30,
		0x7777FFFF)
elseif (H1_XR or H1_YT or H1_XL or H1_YB ~=0) and Facing == 0 then
		gui.box(
		XPos_SCR+H1_XR-1,
		0+(YPos_SCR)+H1_YT,
		XPos_SCR+H1_XL-1,
		0+(YPos_SCR)+H1_YB,
		0x7777FF30,
		0x7777FFFF)
end

--Hurtbox 2
if (H2_XR or H2_YT or H2_XL or H2_YB ~=0) and Facing == 1 then
		gui.box(
		XPos_SCR+H2_XR,
		0+(YPos_SCR)+H2_YT,
		XPos_SCR+H2_XL,
		0+(YPos_SCR)+H2_YB,
		0x7777FF30,
		0x7777FFFF)
elseif (H2_XR or H2_YT or H2_XL or H2_YB ~=0) and Facing == 0 then
		gui.box(
		XPos_SCR+H2_XR-1,
		0+(YPos_SCR)+H2_YT,
		XPos_SCR+H2_XL-1,
		0+(YPos_SCR)+H2_YB,
		0x7777FF30,
		0x7777FFFF)
end

--Hitbox 1
if ATKState > 0 and Facing == 1 then
		gui.box(
		XPos_SCR+A1_XR,
		0+(YPos_SCR)+A1_YT,
		XPos_SCR+A1_XL,
		0+(YPos_SCR)+A1_YB,
		0xFF000030,
		0xFF0000FF)
elseif ATKState > 0 and Facing == 0 then
		gui.box(
		XPos_SCR+A1_XR-1,
		0+(YPos_SCR)+A1_YT,
		XPos_SCR+A1_XL-1,
		0+(YPos_SCR)+A1_YB,
		0xFF000030,
		0xFF0000FF)
end

--Hitbox 2
if ATKState > 0 and Facing == 1 then
		gui.box(
		XPos_SCR+A2_XR,
		0+(YPos_SCR)+A2_YT,
		XPos_SCR+A2_XL,
		0+(YPos_SCR)+A2_YB,
		0xFF000030,
		0xFF0000FF)
elseif ATKState > 0 and Facing == 0 then
		gui.box(
		XPos_SCR+A2_XR-1,
		0+(YPos_SCR)+A2_YT,
		XPos_SCR+A2_XL-1,
		0+(YPos_SCR)+A2_YB,
		0xFF000030,
		0xFF0000FF)
end

--Clash Hitbox
if ATKState > 0 and Facing == 1 then
		gui.box(
		XPos_SCR+C1_XR,
		0+(YPos_SCR)+C1_YT,
		XPos_SCR+C1_XL,
		0+(YPos_SCR)+C1_YB,
		0xFFFF0030,
		0xFFFF00FF)
elseif ATKState > 0 and Facing == 0 then
		gui.box(
		XPos_SCR+C1_XR-1,
		0+(YPos_SCR)+C1_YT,
		XPos_SCR+C1_XL-1,
		0+(YPos_SCR)+C1_YB,
		0xFFFF0030,
		0xFFFF00FF)
end

gui.drawline((XPos_SCR - 3),YPos_SCR, (XPos_SCR + 3), YPos_SCR, 0xFFFFFFFF)
gui.drawline(XPos_SCR,(-3+YPos_SCR), XPos_SCR, (3+YPos_SCR), 0xFFFFFFFF)

-------------------------------------
-- Draw DMW Boxes

--Hitbox 1
if Char == 06 then --Are you Alice?
	if DMW_ATKState > 0 and DMW_Facing == 1 then
		gui.box(
		DMW_XPos_SCR+DMW_A1_XR,
		0+(DMW_YPos_SCR)+DMW_A1_YT,
		DMW_XPos_SCR+DMW_A1_XL,
		0+(DMW_YPos_SCR)+DMW_A1_YB,
		0xFF000030,
		0xFF0000FF)
	elseif DMW_ATKState > 0 and DMW_Facing == 0 then
		gui.box(
		DMW_XPos_SCR+DMW_A1_XR-1,
		0+(DMW_YPos_SCR)+DMW_A1_YT,
		DMW_XPos_SCR+DMW_A1_XL-1,
		0+(DMW_YPos_SCR)+DMW_A1_YB,
		0xFF000030,
		0xFF0000FF)
	end
end

--Hitbox 2
if Char == 06 then --Are you Alice?
	if DMW_ATKState > 0 and DMW_Facing == 1 then
		gui.box(
		DMW_XPos_SCR+DMW_A2_XR,
		0+(DMW_YPos_SCR)+DMW_A2_YT,
		DMW_XPos_SCR+DMW_A2_XL,
		0+(DMW_YPos_SCR)+DMW_A2_YB,
		0xFF000030,
		0xFF0000FF)
	elseif DMW_ATKState > 0 and DMW_Facing == 0 then
		gui.box(
		DMW_XPos_SCR+DMW_A2_XR-1,
		0+(DMW_YPos_SCR)+DMW_A2_YT,
		DMW_XPos_SCR+DMW_A2_XL-1,
		0+(DMW_YPos_SCR)+DMW_A2_YB,
		0xFF000030,
		0xFF0000FF)
	end
end

--DMW Axis
if Char == 0x06 then --Are you Alice?
gui.drawline((DMW_XPos_SCR - 3),DMW_YPos_SCR, (DMW_XPos_SCR + 3), DMW_YPos_SCR, 0xFFFFFFFF)
gui.drawline(DMW_XPos_SCR,(-3+DMW_YPos_SCR), DMW_XPos_SCR, (3+DMW_YPos_SCR), 0xFFFFFFFF)
end

-------------------------------------

end

function P2() --P2 Info

XPos_SCR=rws(0x00404084)
YPos_SCR=rws(0x00404086)
Facing=rws(0x00404090)
ATKState=rws(0x004040A8)
Char=rws(0x00404666)

A1_XR=rws(0x004040AE)
A1_YT=rws(0x004040B0)
A1_XL=rws(0x004040B2)
A1_YB=rws(0x004040B4)
A2_XR=rws(0x004040B6)
A2_YT=rws(0x004040B8)
A2_XL=rws(0x004040BA)
A2_YB=rws(0x004040BC)
C1_XR=rws(0x004040BE)
C1_YT=rws(0x004040C0)
C1_XL=rws(0x004040C2)
C1_YB=rws(0x004040C4)

P_XR=rws(0x004041BE)
P_YT=rws(0x004041C0)
P_XL=rws(0x004041C2)
P_YB=rws(0x004041C4)
H1_XR=rws(0x004041C6)
H1_YT=rws(0x004041C8)
H1_XL=rws(0x004041CA)
H1_YB=rws(0x004041CC)
H2_XR=rws(0x004041CE)
H2_YT=rws(0x004041D0)
H2_XL=rws(0x004041D2)
H2_YB=rws(0x004041D4)

-------------------------------------
-- Alice Stuff
DMW_XPos_SCR=rws(0x004059E2)
DMW_YPos_SCR=rws(0x004059E4)
DMW_Facing=rws(0x004059EE)
DMW_ATKState=rws(0x00405A04)
DMW_A1_XR=rws(0x00405A0A)	--Hitbox 1
DMW_A1_YT=rws(0x00405A0C)
DMW_A1_XL=rws(0x00405A0E)
DMW_A1_YB=rws(0x00405A10)
DMW_A2_XR=rws(0x00405A12)	--Hitbox 2
DMW_A2_YT=rws(0x00405A14)
DMW_A2_XL=rws(0x00405A16)
DMW_A2_YB=rws(0x00405A18)
-------------------------------------

-------------------------------------
--Draw Boxes

--Pushbox
if (P_XR or P_YT or P_XL or P_YB ~=0) and Facing == 1 then
		gui.box(
		XPos_SCR+P_XR,
		0+(YPos_SCR)+P_YT,
		XPos_SCR+P_XL,
		0+(YPos_SCR)+P_YB,
		0x00FF0030,
		0x00FF00FF)
elseif (P_XR or P_YT or P_XL or P_YB ~=0) and Facing == 0 then
		gui.box(
		XPos_SCR+P_XR-1,
		0+(YPos_SCR)+P_YT,
		XPos_SCR+P_XL-1,
		0+(YPos_SCR)+P_YB,
		0x00FF0030,
		0x00FF00FF)
end

--Hurtbox 1
if (H1_XR or H1_YT or H1_XL or H1_YB ~=0) and Facing == 1 then
		gui.box(
		XPos_SCR+H1_XR,
		0+(YPos_SCR)+H1_YT,
		XPos_SCR+H1_XL,
		0+(YPos_SCR)+H1_YB,
		0x7777FF30,
		0x7777FFFF)
elseif (H1_XR or H1_YT or H1_XL or H1_YB ~=0) and Facing == 0 then
		gui.box(
		XPos_SCR+H1_XR-1,
		0+(YPos_SCR)+H1_YT,
		XPos_SCR+H1_XL-1,
		0+(YPos_SCR)+H1_YB,
		0x7777FF30,
		0x7777FFFF)
end

--Hurtbox 2
if (H2_XR or H2_YT or H2_XL or H2_YB ~=0) and Facing == 1 then
		gui.box(
		XPos_SCR+H2_XR,
		0+(YPos_SCR)+H2_YT,
		XPos_SCR+H2_XL,
		0+(YPos_SCR)+H2_YB,
		0x7777FF30,
		0x7777FFFF)
elseif (H2_XR or H2_YT or H2_XL or H2_YB ~=0) and Facing == 0 then
		gui.box(
		XPos_SCR+H2_XR-1,
		0+(YPos_SCR)+H2_YT,
		XPos_SCR+H2_XL-1,
		0+(YPos_SCR)+H2_YB,
		0x7777FF30,
		0x7777FFFF)
end

--Hitbox 1
if ATKState > 0 and Facing == 1 then
		gui.box(
		XPos_SCR+A1_XR,
		0+(YPos_SCR)+A1_YT,
		XPos_SCR+A1_XL,
		0+(YPos_SCR)+A1_YB,
		0xFF000030,
		0xFF0000FF)
elseif ATKState > 0 and Facing == 0 then
		gui.box(
		XPos_SCR+A1_XR-1,
		0+(YPos_SCR)+A1_YT,
		XPos_SCR+A1_XL-1,
		0+(YPos_SCR)+A1_YB,
		0xFF000030,
		0xFF0000FF)
end

--Hitbox 2
if ATKState > 0 and Facing == 1 then
		gui.box(
		XPos_SCR+A2_XR,
		0+(YPos_SCR)+A2_YT,
		XPos_SCR+A2_XL,
		0+(YPos_SCR)+A2_YB,
		0xFF000030,
		0xFF0000FF)
elseif ATKState > 0 and Facing == 0 then
		gui.box(
		XPos_SCR+A2_XR-1,
		0+(YPos_SCR)+A2_YT,
		XPos_SCR+A2_XL-1,
		0+(YPos_SCR)+A2_YB,
		0xFF000030,
		0xFF0000FF)
end

--Clash Hitbox
if ATKState > 0 and Facing == 1 then
		gui.box(
		XPos_SCR+C1_XR,
		0+(YPos_SCR)+C1_YT,
		XPos_SCR+C1_XL,
		0+(YPos_SCR)+C1_YB,
		0xFFFF0030,
		0xFFFF00FF)
elseif ATKState > 0 and Facing == 0 then
		gui.box(
		XPos_SCR+C1_XR-1,
		0+(YPos_SCR)+C1_YT,
		XPos_SCR+C1_XL-1,
		0+(YPos_SCR)+C1_YB,
		0xFFFF0030,
		0xFFFF00FF)
end

gui.drawline((XPos_SCR - 3),YPos_SCR, (XPos_SCR + 3), YPos_SCR, 0xFFFFFFFF)
gui.drawline(XPos_SCR,(-3+YPos_SCR), XPos_SCR, (3+YPos_SCR), 0xFFFFFFFF)
-------------------------------------

-------------------------------------
-- Draw DMW Boxes

--Hitbox 1
if Char == 06 then --Are you Alice?
	if DMW_ATKState > 0 and DMW_Facing == 1 then
		gui.box(
		DMW_XPos_SCR+DMW_A1_XR,
		0+(DMW_YPos_SCR)+DMW_A1_YT,
		DMW_XPos_SCR+DMW_A1_XL,
		0+(DMW_YPos_SCR)+DMW_A1_YB,
		0xFF000030,
		0xFF0000FF)
	elseif DMW_ATKState > 0 and DMW_Facing == 0 then
		gui.box(
		DMW_XPos_SCR+DMW_A1_XR-1,
		0+(DMW_YPos_SCR)+DMW_A1_YT,
		DMW_XPos_SCR+DMW_A1_XL-1,
		0+(DMW_YPos_SCR)+DMW_A1_YB,
		0xFF000030,
		0xFF0000FF)
	end
end

--Hitbox 2
if Char == 06 then --Are you Alice?
	if DMW_ATKState > 0 and DMW_Facing == 1 then
		gui.box(
		DMW_XPos_SCR+DMW_A2_XR,
		0+(DMW_YPos_SCR)+DMW_A2_YT,
		DMW_XPos_SCR+DMW_A2_XL,
		0+(DMW_YPos_SCR)+DMW_A2_YB,
		0xFF000030,
		0xFF0000FF)
	elseif DMW_ATKState > 0 and DMW_Facing == 0 then
		gui.box(
		DMW_XPos_SCR+DMW_A2_XR-1,
		0+(DMW_YPos_SCR)+DMW_A2_YT,
		DMW_XPos_SCR+DMW_A2_XL-1,
		0+(DMW_YPos_SCR)+DMW_A2_YB,
		0xFF000030,
		0xFF0000FF)
	end
end

--DMW Axis
if Char == 0x06 then --Are you Alice?
gui.drawline((DMW_XPos_SCR - 3),DMW_YPos_SCR, (DMW_XPos_SCR + 3), DMW_YPos_SCR, 0xFFFFFFFF)
gui.drawline(DMW_XPos_SCR,(-3+DMW_YPos_SCR), DMW_XPos_SCR, (3+DMW_YPos_SCR), 0xFFFFFFFF)
end

-------------------------------------

end

function hitboxesReg()
	if hitboxes.enabled then
		P1();
	    P2();
	end
end

function hitboxesRegAfter()
end
