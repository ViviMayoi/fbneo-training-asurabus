-------------------------------------------------------
-- Memory addresses for ST
-- Inspired by Grouflon 3rd Strike Training mode
-- https://github.com/Grouflon/3rd_training_lua
-- Made by Mcmic and Asunaro
-------------------------------------------------------
-- ch state
-- current animation
-- in hitstop
-- airborne state
-- hitstun
-- blockstun
addresses = {
  global = {
      hitstop = 0x400007
  },
  players = {
    {
      attackState = 0x4033F0 -- word
      animationID = 0x4033C1 -- byte
      prevAnimID = 0x4033C9 -- byte
      hitstun = 0x403523 -- byte
      blockstun = 0x404029 -- byte
      counterHitState = 0x404069 -- byte
      stanceState = 0x403DDB -- byte
    },
    {
      attackState = 0x4040A8 -- word
      animationID = 0x404077 -- byte
      prevAnimID = 0x40407F -- byte
      hitstun = 0x4041DF -- byte
      counterHitState = 0x40326A -- byte
      stanceState = 0x404A9B -- byte
      -- blockstop = 0x404109 -- byte
    }
  }
}