-------------------------------------------------------
-- Memory addresses for Asura Buster: Eternal Warriors
-- Inspired by Grouflon's 3rd Strike Training mode and Mcmic + Asunaro's Super Turbo training mode
-- https://github.com/Grouflon/3rd_training_lua
-- https://github.com/Asunarooo/fbneo-training-mode
-- Made by ViviMayoi and Xenn
-------------------------------------------------------

global = {
  Hitstop = 0x400007, -- byte
  CameraX = 0x400024, -- word
}
players = {
  {
    --Hitbox 1
    A1_XR               = 0x4033F6,
    A1_YT               = 0x4033F8,
    A1_XL               = 0x4033FA,
    A1_YB               = 0x4033FC,
    --Hitbox 2
    A2_XR               = 0x4033FE,
    A2_YT               = 0x403400,
    A2_XL               = 0x403402,
    A2_YB               = 0x403404,
    --Clashbox
    C1_XR               = 0x403406,
    C1_YT               = 0x403408,
    C1_XL               = 0x40340A,
    C1_YB               = 0x40340C,

    --Pushbox
    P_XR                = 0x403504,
    P_YT                = 0x403506,
    P_XL                = 0x403508,
    P_YB                = 0x40350A,
    --Hurtbox 1
    H1_XR               = 0x40350C,
    H1_YT               = 0x40350E,
    H1_XL               = 0x403510,
    H1_YB               = 0x403512,
    --Hurtbox 2
    H2_XR               = 0x403514,
    H2_YT               = 0x403516,
    H2_XL               = 0x403518,
    H2_YB               = 0x40351A,

    -- Secondary entities (DMW, boost mode afterimages)
    DMW_XPos_SCR        = 0x404D42,
    DMW_YPos_SCR        = 0x404D44,
    DMW_Facing          = 0x404D4E,
    DMW_ATKState        = 0x404D64,
    --Hitbox 1
    DMW_A1_XR           = 0x404D6A,
    DMW_A1_YT           = 0x404D6C,
    DMW_A1_XL           = 0x404D6E,
    DMW_A1_YB           = 0x404D70,
    --Hitbox 2
    DMW_A2_XR           = 0x404D72,
    DMW_A2_YT           = 0x404D74,
    DMW_A2_XL           = 0x404D76,
    DMW_A2_YB           = 0x404D78,
    --Clashbox
    DMW_C1_XR           = 0x404D7A,
    DMW_C1_YT           = 0x404D7C,
    DMW_C1_XL           = 0x404D7E,
    DMW_C1_YB           = 0x404D80,
    ---------------------------------------

    ---------------------------------------
    -- Projectiles
    pOn                 = 0x4039B0,
    pType               = 0x4039B1,
    pID                 = 0x4039B2,
    pXPos               = 0x4039B4,
    pYPos               = 0x4039B6,
    pFacing             = 0x4039B8,
    pTime               = 0x4039BB,
    pHit                = 0x4039BF,

    -- Other
    IncomingAnimationID = 0x4033C0, -- word
    SPRFrame            = 0x4033C2, -- word
    SPRTime             = 0x4033C4, -- word
    AnimationID         = 0x4033C8, -- word
    XPos_SCR            = 0x4033CE,
    YPos                = 0x4033D0,
    IsUsingSpecial      = 0x4033EC, -- word
    Facing              = 0x4033DA,
    ActionLock          = 0x4033E6, -- word
    AttackState         = 0x4033F0, -- word
    IsCrouching         = 0x40342A, -- word
    IsAirActionable     = 0x403420, -- word
    IsDashing           = 0x403436, -- word
    KnockdownTime       = 0x403442, -- word
    IsKnockedDown1      = 0x4034D6, -- word
    IsKnockedDown2      = 0x4034D8, -- word
    AirOptions          = 0x4034DA, -- word (really 4 nybbles)
    LaunchCount         = 0x4034DC, -- word
    Airborne            = 0x4034FC, -- word
    CanCancel           = 0x403500, -- word
    Hitstun             = 0x403522, -- word
    IsLaunched          = 0x403526, -- word
    Character           = 0x4039A6, -- word
    StanceState         = 0x403DDA, -- word
    Unused_3DE2         = 0x403DE2, -- word
    Unused_3DE4         = 0x403DE4, -- word
    Unused_3DEE         = 0x403DEE, -- word
    HitstunType         = 0x403E50, -- word
    Boost               = 0x403F56,
    Blockstun           = 0x404028, -- word
    InAirborneHitstun   = 0x40404E, -- word
    CounterState        = 0x404068, -- word
  },

  -- Player 2
  {
    AnimationID     = 0x404076, -- word
    SPRFrame        = 0x404078, -- word
    SPRTime         = 0x404080, -- word
    PrevAnimID      = 0x40407E, -- byte
    AttackState     = 0x4040A8, -- word
    Hitstun         = 0x4041DE, -- word
    StanceState     = 0x404A9A, -- word
    HitstunType     = 0x404B10, -- word
    HitFrameCounter = 0x404B12, -- word
    Blockstun       = 0x404CE8, -- word
    CounterState    = 0x404D26  -- word
  }
}
