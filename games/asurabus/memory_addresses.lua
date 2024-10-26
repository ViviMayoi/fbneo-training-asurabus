-------------------------------------------------------
-- Memory addresses for ST
-- Inspired by Grouflon 3rd Strike Training mode
-- https://github.com/Grouflon/3rd_training_lua
-- Made by Mcmic and Asunaro
-------------------------------------------------------
addresses = {
  global = {
      hitstop = 0x400007
  },
  players = {
    {
      attackState = 0x4033F0 -- word
      animationID = 0x4033C0 -- word
      prevAnimID = 0x4033C9 -- byte
      hitstun = 0x403523 -- byte
      blockstun = 0x404029 -- byte
      counterHitState = 0x404069 -- byte
      stanceState = 0x403DDB -- byte
      hitState = 0x404B10 -- word
      hitFrameCounter = 0x404B12 --word
    },
    {
      attackState = 0x4040A8 -- word
      animationID = 0x404076 -- word
      prevAnimID = 0x40407F -- byte
      hitstun = 0x4041DF -- byte
      counterHitState = 0x40326A -- byte
      stanceState = 0x404A9B -- byte
      hitState = 0x404B10 -- word
      hitFrameCounter = 0x404B12 -- word
    }
  }
}