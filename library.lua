local rootWind = { }

rootWind.items = { }
rootWind.flagged = GetTime()
rootWind.unflagged = GetTime()
rootWind.tempNum = 0
rootWind.chiButton = false
rootWind.queueSpell = nil
rootWind.queueTime = 0

rootWind.buttons = 
  ProbablyEngine.toggle.create(
    'chistacker',
    'Interface\\Icons\\ability_monk_expelharm',
    'Stack Chi',
    'Keep Chi at full even OoC...')
    
SLASH_ECAST1 = "/root"
function SlashCmdList.ECAST(msg, editbox)		
	local command = msg:match("^(.*)$")
	if command == "Leg Sweep" or command == 119381 then
		rootWind.queueSpell = 119381
	elseif command == "Touch of Karma" or command == 122470 then
    rootWind.queueSpell = 122470
  elseif command == "Grapple Weapon" or command == 117368 then
    rootWind.queueSpell = 117368
  elseif command == "Diffuse Magic" or command == 122783 then
    rootWind.queueSpell = 122783
  elseif command == "Dampen Harm" or command == 122278 then
    rootWind.queueSpell = 122278
  elseif command == "Ring of Peace" or command == 116844 then
    rootWind.queueSpell = 116844
  elseif command == "Tiger's Lust" or command == 116841 then
    rootWind.queueSpell = 116841
  elseif command == "Healing Sphere" or command == 115460 then
    rootWind.queueSpell = 115460
  else
    rootWind.queueSpell = nil
  end
  if rootWind.queueSpell ~= nil then rootWind.queueTime = GetTime() end
end

rootWind.checkQueue = function (spellId)
  if (GetTime() - rootWind.queueTime) > 4 then
    rootWind.queueTime = 0
    rootWind.queueSpell = nil
    return false
  else
    if rootWind.queueSpell then
      if rootWind.queueSpell == spellId then
        if ProbablyEngine.parser.lastCast == GetSpellName(spellId) then
          rootWind.queueSpell = nil
          rootWind.queueTime = 0
        end
        return true
      end
    end
  end
  return false
end

rootWind.setFlagged = function (self, ...)
  rootWind.flagged = GetTime()
end

rootWind.setUnflagged = function (self, ...)
  rootWind.unflagged = GetTime()
  if rootWind.items[77589] then
    rootWind.items[77589].exp = rootWind.unflagged + 60
  end
end

rootWind.eventHandler = function(self, ...)
  local subEvent		= select(1, ...)
  local source		= select(4, ...)
  local destGUID		= select(7, ...)
  local spellID		= select(11, ...)
  local failedType = select(14, ...)
  
  if UnitName("player") == source then
    if subEvent == "SPELL_CAST_SUCCESS" then
      if spellID == 6262 then -- Healthstone
        rootWind.items[6262] = { lastCast = GetTime() }
      end
      if spellID == 124199 then -- Landshark (itemId 77589)
        rootWind.items[77589] = { lastCast = GetTime(), exp = 0 }
      end
    end
  end
end

ProbablyEngine.listener.register("rootWind", "COMBAT_LOG_EVENT_UNFILTERED", rootWind.eventHandler)
ProbablyEngine.listener.register("rootWind", "PLAYER_REGEN_DISABLED", rootWind.setFlagged)
ProbablyEngine.listener.register("rootWind", "PLAYER_REGEN_DISABLED", rootWind.resetLists)
ProbablyEngine.listener.register("rootWind", "PLAYER_REGEN_DISABLED", rootWind.setUnflagged)
ProbablyEngine.listener.register("rootWind", "PLAYER_REGEN_ENABLED", rootWind.resetLists)

function rootWind.spellCooldown(spell)
  local spellName = GetSpellInfo(spell)
  if spellName then
    local spellCDstart,spellCDduration,_ = GetSpellCooldown(spellName)
    if spellCDduration == 0 then
      return 0
    elseif spellCDduration > 0 then
      local spellCD = spellCDstart + spellCDduration - GetTime()
      return spellCD
    end
  end
  return 0
end

function rootWind.fillBlackout()
  local energy = UnitPower("player")
  local regen = select(2, GetPowerRegen("player"))
  local start, duration, enabled = GetSpellCooldown(107428)
  if not start then return false end
  if start ~= 0 then
    local remains = start + duration - GetTime()
    return (energy + regen * remains) >= 40
  end
  return 0
  
end

function rootWind.usePot(target)
	if not (UnitBuff("player", 2825) or
			UnitBuff("player", 32182) or 
			UnitBuff("player", 80353) or
			UnitBuff("player", 90355)) then
		return false
	end
	if GetItemCount(76089) < 1 then return false end
	if GetItemCooldown(76089) ~= 0 then return false end
	if not ProbablyEngine.condition["modifier.cooldowns"] then return false end
	if UnitLevel(target) ~= -1 then return false end
  if rootWind.t2d(target) > 30 then return false end
	return true 
end

function rootWind.t2d(target)
  if ProbablyEngine.condition["deathin"](target) then
    return ProbablyEngine.condition["deathin"](target)
	end
  return 600
end

function rootWind.validTarget(unit)
  if not UnitIsVisible(unit) then return false end
  if not UnitExists(unit) then return false end
  if not (UnitCanAttack("player", unit) == 1) then return false end
  if UnitIsDeadOrGhost(unit) then return false end
  local inRange = IsSpellInRange(GetSpellInfo(116), unit) -- Frostbolt
  if not inRange then return false end
  if inRange == 0 then return false end
  if not rootWind.immuneEvents(unit) then return false end
  return true
end


function rootWind.itemCooldown(itemID)
  return GetItemCooldown(itemID)
end

function rootWind.immuneEvents(unit)
  if not UnitAffectingCombat(unit) then return false end
  -- Crowd Control
  local cc = {
    49203, -- Hungering Cold
     6770, -- Sap
     1776, -- Gouge
    51514, -- Hex
     9484, -- Shackle Undead
      118, -- Polymorph
    28272, -- Polymorph (pig)
    28271, -- Polymorph (turtle)
    61305, -- Polymorph (black cat)
    61025, -- Polymorph (serpent) -- FIXME: gone ?
    61721, -- Polymorph (rabbit)
    61780, -- Polymorph (turkey)
     3355, -- Freezing Trap
    19386, -- Wyvern Sting
    20066, -- Repentance
    90337, -- Bad Manner (Monkey) -- FIXME: to check
     2637, -- Hibernate
    82676, -- Ring of Frost
   115078, -- Paralysis
    76780, -- Bind Elemental
     9484, -- Shackle Undead
     1513, -- Scare Beast
   115268, -- Mesmerize
  }
  if rootWind.hasDebuffTable(unit, cc) then return false end
  if UnitAura(unit,GetSpellInfo(116994))
		or UnitAura(unit,GetSpellInfo(122540))
		or UnitAura(unit,GetSpellInfo(123250))
		or UnitAura(unit,GetSpellInfo(106062))
		or UnitAura(unit,GetSpellInfo(110945))
		or UnitAura(unit,GetSpellInfo(143593)) -- General Nazgrim: Defensive Stance
    or UnitAura(unit,GetSpellInfo(143574)) -- Heroic Immerseus: Swelling Corruption
		then return false end
  return true
end

function rootWind.hasDebuffTable(target, spells)
  for i = 1, 40 do
    local _,_,_,_,_,_,_,_,_,_,spellId = _G['UnitDebuff'](target, i)
    for k,v in pairs(spells) do
      if spellId == v then return true end
    end
  end
end

function rootWind.checkShark(target)
  if GetItemCount(77589, false, false) > 0 then
    if not rootWind.items[77589] then return true end
    if rootWind.items[77589].exp ~= 0 and
      rootWind.items[77589].exp < GetTime() then return true end
  end
end

function rootWind.touchOfDeath(target)
  return UnitHealth(target) < UnitHealth("player")
end

function rootWind.detox(target)
  local debuffType
  for i = 1, 40 do
    debuffType = select(5, UnitDebuff("player", i))
    if debuffType == "Poison" or debuffType == "Disease" then
      return true
    end
  end
end

ProbablyEngine.library.register("rootWind", rootWind)