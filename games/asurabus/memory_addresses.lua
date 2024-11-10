-------------------------------------------------------
-- Memory addresses for Asura Buster: Eternal Warriors
-- Inspired by Grouflon's 3rd Strike Training mode and Mcmic + Asunaro's Super Turbo training mode
-- https://github.com/Grouflon/3rd_training_lua
-- https://github.com/Asunarooo/fbneo-training-mode
-- Made by ViviMayoi and Xenn
-------------------------------------------------------

  global = {
      Hitstop      = 0x400007,
      CameraX      = 0x00400024,
  }
  players = {
    {
      SPRTime      = 0x004033C4,
      SPRFrame     = 0x004033CA,
      XPos_SCR     = 0x004033CE,
      YPos_SCR     = 0x004033D0,
      Facing       = 0x004033DA,
      Character    = 0x004039A6,
      Boost        = 0x00403F56,
    
      --Hitbox 1
      A1_XR        = 0x004033F6,
      A1_YT        = 0x004033F8,
      A1_XL        = 0x004033FA,
      A1_YB        = 0x004033FC,
      --Hitbox 2
      A2_XR        = 0x004033FE,
      A2_YT        = 0x00403400,
      A2_XL        = 0x00403402,
      A2_YB        = 0x00403404,
      --Clashbox
      C1_XR        = 0x00403406,
      C1_YT        = 0x00403408,
      C1_XL        = 0x0040340A,
      C1_YB        = 0x0040340C,
    
        --Pushbox
      P_XR         = 0x00403504,
      P_YT         = 0x00403506,
      P_XL         = 0x00403508,
      P_YB         = 0x0040350A,
      --Hurtbox 1
      H1_XR        = 0x0040350C,
      H1_YT        = 0x0040350E,
      H1_XL        = 0x00403510,
      H1_YB        = 0x00403512,
      --Hurtbox 2
      H2_XR        = 0x00403514,
      H2_YT        = 0x00403516,
      H2_XL        = 0x00403518,
      H2_YB        = 0x0040351A,
    
      -- Secondary entities (DMW, boost mode afterimages)
      DMW_XPos_SCR = 0x00404D42,
      DMW_YPos_SCR = 0x00404D44,
      DMW_Facing   = 0x00404D4E,
      DMW_ATKState = 0x00404D64,
      --Hitbox 1
      DMW_A1_XR    = 0x00404D6A,
      DMW_A1_YT    = 0x00404D6C,
      DMW_A1_XL    = 0x00404D6E,
      DMW_A1_YB    = 0x00404D70,
      --Hitbox 2
      DMW_A2_XR    = 0x00404D72,
      DMW_A2_YT    = 0x00404D74,
      DMW_A2_XL    = 0x00404D76,
      DMW_A2_YB    = 0x00404D78,
      --Clashbox
      DMW_C1_XR    = 0x00404D7A,
      DMW_C1_YT    = 0x00404D7C,
      DMW_C1_XL    = 0x00404D7E,
      DMW_C1_YB    = 0x00404D80,
      ---------------------------------------
    
      ---------------------------------------
      -- Projectiles
      pOn          = 0x004039B0,
      pType        = 0x004039B1,
      pID          = 0x004039B2,
      pXPos        = 0x004039B4,
      pYPos        = 0x004039B6,
      pFacing      = 0x004039B8,
      pTime        = 0x004039BB,
      pHit         = 0x004039BF,

      -- Other
      AttackState = 0x4033F0, -- word
      AnimationID = 0x4033C0, -- word
      PrevAnimID = 0x4033C9, -- byte
      Hitstun = 0x403523, -- byte
      Blockstun = 0x404029, -- byte
      CounterHitState = 0x404069, -- byte
      StanceState = 0x403DDB, -- byte
      HitState = 0x404B10, -- word
      HitFrameCounter = 0x404B12, --word
      AirOptions = 0x4034DA, --word (really 4 nybbles)
      CancelOptions = 0x403500, --word
      LaunchCount = 0x4034DC, --word
      Actionable   = 0x004033E6 -- more testing needed
    },
    {
      AttackState = 0x4040A8, -- word
      AnimationID = 0x404076, -- word
      PrevAnimID = 0x40407F, -- byte
      Hitstun = 0x4041DF, -- byte
      CounterHitState = 0x40326A, -- byte
      StanceState = 0x404A9B, -- byte
      HitState = 0x404B10, -- word
      HitFrameCounter = 0x404B12 -- word
    }
  }