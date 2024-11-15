--------------------
-- Characters
--------------------
YASHAOU           = 0x00
GOAT              = 0x01
LEON              = 0x02
CHENMAO           = 0x03
ZAMB              = 0x04
TAROS             = 0x05
ALICE             = 0x06
ROSEMARY          = 0x07
SITTARA           = 0x08
ROKUROUTA         = 0x09
ZINSUKE           = 0x0A
ALICE_HIDDEN      = 0x0B
NANAMI            = 0x0C
VEBEL             = 0x0D
DRAGON            = 0x0E
KING              = 0x0F
--------------------
-- Animation states
--------------------
ANIMATIONS        = {
    LANDING_LAUNCH   = 0x15,
    AIR_TECH         = 0x39,
    WAKEUP_FROLL     = 0x3D,
    WAKEUP_BROLL     = 0x3E,
    WAKEUP_JUMP      = 0x3F,
    HITSTUN_KD       = 0x40,
    HITSTUN_V_LAUNCH = 0x41,
    HITSTUN_LAUNCH   = 0x42,
    HITSTUN_LAUNCH_2 = 0x43,
    HITSTUN_SKD      = 0x44,
    LANDING_SKD      = 0x47,
    KNOCKDOWN        = 0x48,
    WAKEUP_NEUTRAL   = 0x4A,
    HITSTUN_STAGGER  = 0xF2,
    HITSTUN_LIGHT_S  = 0xF3,
    HITSTUN_MEDIUM_S = 0xF4,
    HITSTUN_HEAVY_S  = 0xF5,
    HITSTUN_LIGHT_C  = 0xF6,
    HITSTUN_MEDIUM_C = 0xF7,
    HITSTUN_HEAVY_C  = 0xF8,
    HITSTUN_AIR      = 0xF9
}

ANIMATIONS_STUN = { 0x15, 0x39, 0x3D, 0x3E, 0x3F, 0x40, 0x41, 0x42, 0x43, 0x44, 0x47, 0x48, 0x4A, 0xF2, 0xF3, 0xF4, 0xF5, 0xF6, 0xF7, 0xF8, 0xF9 }

ANIMATIONS_WAKEUP = { 0x39, 0x3D, 0x3E, 0x3F, 0x4A }

--------------------
-- Stance values
--------------------
STANDING          = 0x00
CROUCHING         = 0x01
AIRBORNE          = 0x02
DASHING           = 0x03
GROUNDED_SPECIAL  = 0x04
KNOCKED_DOWN      = 0x05
LAUNCHED_BLOCKING = 0x07 -- applies for both of them. don't ask. i don't know either.
