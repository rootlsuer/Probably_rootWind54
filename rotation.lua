-- ProbablyEngine Rotation Packager
-- Custom Windwalker Monk Rotation
-- Created on Nov 9th 2013 2:50 am

ProbablyEngine.rotation.register_custom(269, "rootWind54",
{
  -- Combat
  { "pause", "modifier.lalt" },
  -- Interrupt
  { "116705", "modifier.interrupts" },
  -- Buffs
  { "116781", -- Legacy of the White Tiger
    {
      "!player.buff(116781)",
      "!player.buff(17007)",
      "!player.buff(1459)",
      "!player.buff(61316)",
      "!player.buff(24604)",
      "!player.buff(90309)",
      "!player.buff(126373)",
      "!player.buff(126309)"
    }
  },
  { "117666", -- Legacy of the Emperor
    {
      "!player.buff(117666)",
      "!player.buff(1126)",
      "!player.buff(20217)",
      "!player.buff(90363)"
    }
  },
  -- Cooldowns
  {{
    { "121279", "player.spell(121279).exists" },
    { "26297", "player.spell(26297).exists" },
    { "20572", "player.spell(20572).exists" },
    { "33697", "player.spell(33697).exists" },
    { "33702", "player.spell(33702).exists" },
    { "123904", "player.spell(123904).exists" },
    { "#gloves", "@rootWind.useGloves" },
    { "!/run UseItemByName(76089)", "@rootWind.usePot" },
  }, "modifier.cooldowns" },

  { "115072", "player.health < 80" },
  { "!/use healthstone",
    {
      "player.health < 40",
      "@rootWind.checkStone"
    }
  },
  -- Shared
  {{
    { "115399", "player.spell(115399).charges = 2" },
    { "115399",
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
  { "100787", -- Tiger Palm
    {
      "player.buff(125359)",
      "player.buff(125359).duration <= 3"
    }
  },
  { "100787", "!player.buff(125359)" },
  {{
    {"116740", {"player.buff(125195).count = 20",  "@rootWind.returnTrue"} },
    {"116740",
      {
        "player.chi >= 2",
        "player.buff(125195).count >= 15",
        "player.buff(125359)",
        "target.debuff(130320)"
      }
    }
  }, "!player.buff(116740)" },
  { "115288", "player.timetomax > 5" },
  { "107428", "!target.debuff(130320)" },
  { "100787", -- Tiger Palm
    {
      "!player.buff(125359)",
      "target.debuff(130320)",
      "target.debuff(130320).duration > 1",
      "player.timetomax > 1"
    }
  },
  -- AoE
  {{
    { "116847", "player.spell(116847).exists" },
    { "115098", "player.spell(115098).exists" },
    { "123986",
      {
        "!player.moving",
        "player.spell(123986).exists"
      }
    },
    { "107428",
    {
      "player.chi = 4",
      "!player.spell(115396).exists"
    }
    },
    { "107428", -- Rising Sun Kick
      {
        "player.chi = 5",
        "player.spell(115396).exists"
      }
    },
    { "101546" }
  }, "modifier.multitarget" },

  -- Single
  { "107428" },
  { "113656",
    {
      "!player.moving",
      "!player.buff(115288)",
      "player.timetomax > 4",
      "player.buff(125359).duration > 4"
    }
  },
  {{
    { "115098", "player.spell(115098).exists" },
    { "123986",
      {
        "!player.moving",
        "player.spell(123986).exists"
      }
    },
    {{
      { "124081", "!focus.buff(124081)", "focus" },
      { "124081", "!player.buff(124081)", "player" },
    }, "player.spell(124081).exists" },
  }, "player.timetomax > 2" },
  { "100784", "player.buff(116768)" },
  {{
    { "100787", "player.buff(118864).duration <= 2" },
    { "100787", "player.energy >= 2" }
  }, "player.buff(118864)" },
  { "115687",
    {
      "player.chi <= 2",
      "!player.spell(115396).exists"
    }
  },
  { "115687",
    {
      "player.chi <= 3",
      "player.spell(115396).exists"
    }
  },
  { "100784", "@rootWind.fillBlackout" }
},
{
  -- Out of Combat
  -- Buffs
  { "116781",
    {
      "!player.buff(116781)",
      "!player.buff(17007)",
      "!player.buff(1459)",
      "!player.buff(61316)",
      "!player.buff(24604)",
      "!player.buff(90309)",
      "!player.buff(126373)",
      "!player.buff(126309)",
      "@rootWind.returnTrueTest",
    }
  },
  { "117666",
    {
      "!player.buff(117666)",
      "!player.buff(1126)",
      "!player.buff(20217)",
      "!player.buff(90363)"
    }
  },
  { "115072", "toggle.chistacker" }
}, ProbablyEngine.library.libs.rootWind.buttons )