-- ProbablyEngine Rotation Packager
-- Custom Windwalker Monk Rotation
-- Created on Nov 9th 2013 2:50 am

ProbablyEngine.rotation.register_custom(269, "rootWind54",
{
  -- Combat
  { "pause", "modifier.lalt" },
  -- Interrupt
  { "Spear Hand Strike", "modifier.interrupts" },
  -- Buffs
  { "Legacy of the White Tiger", "!player.buff" },
  { "Legacy of the Emperor", "!player.buff" },
  -- Cooldowns
  {{
    { "Lifeblood", "player.spell(121279).exists" },
    { "Berserking", "player.spell(26297).exists" },
    { "Blood Fury", "player.spell(33702).exists" },
    { "Invoke Xuen, the White Tiger", "player.spell(123904).exists" },
    { "#gloves", "@rootWind.useGloves" },
    { "!/use Potion of Virmen's Bite", "@rootWind.usePot" },
  }, "modifier.cooldowns" },

  { "Expel Harm", "player.health < 80" },
  { "!/use healthstone",
    {
      "player.health < 40",
      "@rootWind.checkStone"
    }
  },
  -- Shared
  {{
    { "Chi Brew", "player.spell(115399).charges = 2" },
    { "Chi Brew",
      {
        "player.spell(115399).charges = 1",
        "player.spell(115399).cd <= 10",
      }
    }
  },
    {
     "player.spell(115399).exists",
     "player.chi <= 2"
    }
  },
  { "Tiger Palm",
    {
      "player.buff(Tiger Power)",
      "player.buff(Tiger Power).duration <= 3"
    }
  },
  { "Tiger Palm", "!player.buff(Tiger Power)" },
  {{
    {"Tigereye Brew", "player.buff.count = 20" },
    {"Tigereye Brew",
      {
        "player.chi >= 2",
        "player.buff.count >= 15",
        "player.buff(Tiger Power)",
        "target.debuff(Rising Sun Kick)",
      }
    }
  }, "!player.buff(116740)" },
  { "Energizing Brew", "player.timetomax > 5" },
  { "Rising Sun Kick", "!target.debuff(Rising Sun Kick)" },
  { "Tiger Palm",
    {
      "!player.buff(Tiger Power)",
      "target.debuff(Rising Sun Kick)",
      "target.debuff(Rising Sun Kick).duration > 1",
      "player.timetomax > 1"
    }
  },
  -- AoE
  {{
    { "Rushing Jade Wind", "player.spell(116847).exists" },
    { "Zen Sphere",
      {
        "!player.moving",
        "!target.debuff(Zen Sphere)",
        "player.spell(124081).exists"
      }
    },
    { "Chi Wave", "player.spell(115098).exists" },
    { "Chi Burst",
      {
        "!player.moving",
        "player.spell(123986).exists"
      }
    },
    { "Rising Sun Kick",
    {
      "player.chi = 4",
      "@rootWind.hasNoAscension"
    }
    },
    { "Rising Sun Kick",
      {
        "player.chi = 5",
        "@rootWind.hasAscension"
      }
    },
    { "Spinning Crane Kick" }
  }, "modifier.multitarget" },

  -- Single
  { "Rising Sun Kick" },
  { "Fists of Fury",
    {
      "!player.moving",
      "!player.buff(Energizing Brew)",
      "player.timetomax > 4",
      "player.buff(Tiger Power).duration > 4"
    }
  },
  {{
    { "Chi Wave", "player.spell(115098).exists" },
    { "Chi Burst",
      {
        "!player.moving",
        "player.spell(123986).exists"
      }
    },
    {{
      { "Zen Sphere", "!focus.buff(Zen Sphere)", "focus" },
      { "Zen Sphere", "!player.buff(Zen Sphere)", "player" },
    }, "player.spell(124081).exists" },
  }, "player.timetomax > 2" },
  { "Blackout Kick", "player.buff(Combo Breaker: Blackout Kick)" },
  {{
    { "Tiger Palm", "player.buff(Combo Breaker: Tiger Palm).duration <= 2" },
    { "Tiger Palm", "player.energy >= 2" }
  }, "player.buff(Combo Breaker: Tiger Palm)" },
  { "Jab",
    {
      "player.chi <= 2",
      "!player.spell(115396).exists"
    }
  },
  { "Jab",
    {
      "player.chi <= 3",
      "player.spell(115396).exists"
    }
  },
  { "Blackout Kick", "@rootWind.fillBlackout" }
},
{
  -- Out of Combat
  { "Legacy of the White Tiger", "!player.buff" },
  { "Legacy of the Emperor", "!player.buff" },
  { "Expel Harm", "toggle.chistacker" }
}, ProbablyEngine.library.libs.rootWind.buttons )