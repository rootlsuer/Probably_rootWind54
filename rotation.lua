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
    { "!/use Potion of Virmen's Bite", "@rootWind.usePot" },
  }, "modifier.cooldowns" },

  { "Expel Harm", "player.health < 80" },
  { "!/use healthstone",
    {
      "player.health < 40",
      "@rootWind.checkStone"
    }
  },

  { "#gloves",
		{
			"modifier.cooldowns",
      "!player.moving",
      "@rootWind.useGloves"
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
  { "Energizing Brew", "player.energy < 70" },
  { "Rising Sun Kick", "!target.debuff(Rising Sun Kick)" },
  { "Tiger Palm",
    {
      "!player.buff(Tiger Power)",
      "target.debuff(Rising Sun Kick)",
      "target.debuff(Rising Sun Kick).duration > 1",
      "player.energy < 90"
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
      "!player.energy < 60",
      "player.buff(Tiger Power).duration < 4"
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
    { "Zen Sphere",
      {
        "!player.moving",
        "!target.debuff(Zen Sphere)",
        "player.spell(124081).exists"
      }
    }
  }, "player.energy < 70" },
  { "Blackout Kick", "player.buff(Combo Breaker: Blackout Kick)" },
  {{
    { "Tiger Palm", "player.buff(Combo Breaker: Tiger Palm).duration <= 2" },
    { "Tiger Palm", "player.energy <= 85" }
  }, "player.buff(Combo Breaker: Tiger Palm)" },
  { "Jab",
    {
      "player.chi <= 2",
      "@rootWind.hasNoAscension"
    }
  },
  { "Jab",
    {
      "player.chi <= 3",
      "@rootWind.hasAscension"
    }
  },
  { "Blackout Kick", "player.energy > 20" }
  
  
},
{
  -- Out of Combat
  { "Legacy of the White Tiger", "!player.buff" },
  { "Legacy of the Emperor", "!player.buff" },
  { "Expel Harm", "toggle.chistacker" }
}, ProbablyEngine.library.libs.rootWind.buttons )