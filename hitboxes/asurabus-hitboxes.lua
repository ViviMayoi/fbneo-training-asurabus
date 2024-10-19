-- This template lives at `.../Lua/.template.lua`.

-- client.SetGameExtraPadding(0,0,0,0)
local rb, rbs, rw, rws, rd = memory.readbyte, memory.readbytesigned, memory.readword, memory.readwordsigned, memory.readdword
local wb, ww, wd = memory.writebyte, memory.writeword, memory.writedword

function P1() --P1 Info

Sprite=rw(0x000C6EA4) --ROM offset
Align=rw(0x000CC768) --ROM offset
Hitbox=rw(0x000D95A8) --ROM offset
SPRTime=rws(0x004033C4)
SPRFrame=rws(0x004033CA)
XPos_SCR=rws(0x004033CE)
YPos_SCR=rws(0x004033D0)
Action=rbs(0x004033D3)
XPos=rws(0x004033D4)
YPos=rws(0x004033D6)

A1_XR=rws(0x004033F6)
A1_YT=rws(0x004033F8)
A1_XL=rws(0x004033FA)
A1_YB=rws(0x004033FC)
A2_XR=rws(0x004033FE)
A2_YT=rws(0x00403400)
A2_XL=rws(0x00403402)
A2_YB=rws(0x00403404)
A3_XR=rws(0x00403406)
A3_YT=rws(0x00403408)
A3_XL=rws(0x0040340A)
A3_YB=rws(0x0040340C)

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
--Draw Boxes

--Pushbox
if Action then
		gui.box(
		XPos_SCR+P_XR,
		0+(YPos_SCR)+P_YT,
		XPos_SCR+P_XL,
		0+(YPos_SCR)+P_YB,
		0x00FF0030,
		0x00FF00FF)
end

--Hurtbox 1
if Action then
		gui.box(
		XPos_SCR+H1_XR,
		0+(YPos_SCR)+H1_YT,
		XPos_SCR+H1_XL,
		0+(YPos_SCR)+H1_YB,
		0x7777FF30,
		0x7777FFFF)
end

--Hurtbox 2
if Action then
		gui.box(
		XPos_SCR+H2_XR,
		0+(YPos_SCR)+H2_YT,
		XPos_SCR+H2_XL,
		0+(YPos_SCR)+H2_YB,
		0x7777FF30,
		0x7777FFFF)
end

--Hitbox 1
if Action then
		gui.box(
		XPos_SCR+A1_XR,
		0+(YPos_SCR)+A1_YT,
		XPos_SCR+A1_XL,
		0+(YPos_SCR)+A1_YB,
		0xFF000030,
		0xFF0000FF)
end

--Hitbox 2
if Action then
		gui.box(
		XPos_SCR+A2_XR,
		0+(YPos_SCR)+A2_YT,
		XPos_SCR+A2_XL,
		0+(YPos_SCR)+A2_YB,
		0xFF000030,
		0xFF0000FF)
end

--Clash Hitbox
if Action then
		gui.box(
		XPos_SCR+A3_XR,
		0+(YPos_SCR)+A3_YT,
		XPos_SCR+A3_XL,
		0+(YPos_SCR)+A3_YB,
		0xFFFF0030,
		0xFFFF00FF)
end

gui.drawline((XPos_SCR - 3),YPos_SCR, (XPos_SCR + 3), YPos_SCR, 0xFFFFFFFF)
gui.drawline(XPos_SCR,(-3+YPos_SCR), XPos_SCR, (3+YPos_SCR), 0xFFFFFFFF)

end

function P2() --P2 Info

XPos_SCR=rws(0x004033CE+0xCB6)
YPos_SCR=rws(0x004033D0+0xCB6)
Action=rbs(0x004033D3+0xCB6)
XPos=rws(0x004033D4+0xCB6)
YPos=rws(0x004033D6+0xCB6)

A1_XR=rws(0x004040AE)
A1_YT=rws(0x004040B0)
A1_XL=rws(0x004040B2)
A1_YB=rws(0x004040B4)
A2_XR=rws(0x004040B6)
A2_YT=rws(0x004040B8)
A2_XL=rws(0x004040BA)
A2_YB=rws(0x004040BC)
A3_XR=rws(0x004040BE)
A3_YT=rws(0x004040C0)
A3_XL=rws(0x004040C2)
A3_YB=rws(0x004040C4)

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
--Draw Boxes

--Pushbox
if Action then
		gui.box(
		XPos_SCR+P_XR,
		0+(YPos_SCR)+P_YT,
		XPos_SCR+P_XL,
		0+(YPos_SCR)+P_YB,
		0x00FF0030,
		0x00FF00FF)

end

--Hurtbox 1
if Action then
		gui.box(
		XPos_SCR+H1_XR,
		0+(YPos_SCR)+H1_YT,
		XPos_SCR+H1_XL,
		0+(YPos_SCR)+H1_YB,
		0x7777FF30,
		0x7777FFFF)
end

--Hurtbox 2
if Action then
		gui.box(
		XPos_SCR+H2_XR,
		0+(YPos_SCR)+H2_YT,
		XPos_SCR+H2_XL,
		0+(YPos_SCR)+H2_YB,
		0x7777FF30,
		0x7777FFFF)
end

--Hitbox 1
if Action then
		gui.box(
		XPos_SCR+A1_XR,
		0+(YPos_SCR)+A1_YT,
		XPos_SCR+A1_XL,
		0+(YPos_SCR)+A1_YB,
		0xFF000030,
		0xFF0000FF)
end

--Hitbox 2
if Action then
		gui.box(
		XPos_SCR+A2_XR,
		0+(YPos_SCR)+A2_YT,
		XPos_SCR+A2_XL,
		0+(YPos_SCR)+A2_YB,
		0xFF000030,
		0xFF0000FF)
end

--Clash Hitbox
if Action then
		gui.box(
		XPos_SCR+A3_XR,
		0+(YPos_SCR)+A3_YT,
		XPos_SCR+A3_XL,
		0+(YPos_SCR)+A3_YB,
		0xFFFF0030,
		0xFFFF00FF)
end

gui.drawline((XPos_SCR - 3),YPos_SCR, (XPos_SCR + 3), YPos_SCR, 0xFFFFFFFF)
gui.drawline(XPos_SCR,(-3+YPos_SCR), XPos_SCR, (3+YPos_SCR), 0xFFFFFFFF)

end

function hitboxesReg()
	if hitboxes.enabled then
		P1();
	    P2();
	end
end

function hitboxesRegAfter()
end
