local rootWind = { }

rootWind.items = { }
rootWind.flagged = GetTime()
rootWind.unflagged = GetTime()
rootWind.tempNum = 0
rootWind.chiButton = false

rootWind.buttons = 
  ProbablyEngine.toggle.create(
    'chistacker',
    'Interface\\Icons\\ability_monk_expelharm',
    'Stack Chi',
    'Keep Chi at full even OoC...')

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

function rootWind.useGloves(target)
  local hasEngi = false
  for i=1,9 do
    if select(7,GetProfessionInfo(i)) == 202 then hasEngi = true end
  end
  if hasEngi == false then return false end
  if GetItemCooldown(GetInventoryItemID("player", 10)) > 0 then return false end
  return true
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
  if ProbablyEngine.module.combatTracker.enemy[UnitGUID(target)] then
    local ttdest = ProbablyEngine.module.combatTracker.enemy[UnitGUID(target)]['ttdest']
    local ttdsamp = ProbablyEngine.module.combatTracker.enemy[UnitGUID(target)]['ttdsamples']
    print (ttdest /ttdsamp)
    return (ttdest / ttdsamp)
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

function rootWind.checkStone(target)
  if GetItemCount(6262, false, true) > 0 then
    if not rootWind.items[6262] then
      return true
    elseif (GetTime() - rootWind.items[6262].lastCast) > 120 then
      return true
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

ProbablyEngine.library.register("rootWind", rootWind)