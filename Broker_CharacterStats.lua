----------------------------------------------------------------------------------
--- Broker Character Stats
--- The addon's main lua code.
----------------------------------------------------------------------------------
--- Copyright 2019 Abdessattar Sassi (oss.abde.sassi at gmail.com)
---
--- Distributed under the 3-Clause BSD License.(See accompanying file LICENSE or
--- copy at https://opensource.org/licenses/BSD-3-Clause)
----------------------------------------------------------------------------------

-- All addon's .lua files are passed the addon name and a table they all share to use a common namespace.
-- It's common for addons to use this namespace to group functions or variables to use across its various files.
local addonName = ...

-- Table of classes, their spec and the stats by spec
-- All classes and specs get Leech and Avoidance
local Classes = {
	-- https://wowwiki.fandom.com/wiki/API_UnitClass
	-- Warrior
	[1] = {
		defaultSpec = 1,
		specs = {
			-- Arms
			[1] = { type = "melee", stats = {"Haste", "Crit", "Versatility", "Mastery", "Strength"}},
			-- Fury
			[2] = { type = "melee", stats = {"Crit", "Mastery", "Haste", "Versatility", "Strength"}},
			-- Protection
			[3] = { type = "melee", stats = {"Haste", "Versatility", "Mastery", "Crit", "Strength", "Armor", "--", "Block", "Parry"}},
		}
	},
	-- Paladin
	[2] = {
		defaultSpec = 3,
		specs = {
			-- Holy
			[1] = { type = "caster", stats = {"Intellect", "Crit", "Mastery", "Haste", "Versatility", "--", "MP5"}},
			-- Protection
			[2] = { type = "melee", stats = {"Strength", "Haste", "Mastery", "Versatility", "Crit", "--", "Block", "Parry"}},
			-- Retribution
			[3] = { type = "melee", stats = {"Strength", "Haste", "Crit", "Mastery", "Versatility"}},
		}
	},
	-- Hunter
	[3] = {
		defaultSpec = 1,
		specs = {
			-- BM
			[1] = { type = "ranged", stats = {"Agility", "Crit", "Haste", "Mastery", "Versatility"}},
			-- MM
			[2] = { type = "ranged", stats = {"Agility", "Mastery", "Haste", "Crit", "Versatility"}},
			-- Survival
			[3] = { type = "melee", stats = {"Agility", "Haste", "Crit", "Versatility", "Mastery"}},
		}
	},
	-- Rogue
	[4] = {
		defaultSpec = 1,
		specs = {
			-- Assassination
			[1] = { type = "melee", stats = {"Agility", "Haste", "Crit", "Mastery", "Versatility"}},
			-- Outlaw
			[2] = { type = "melee", stats = {"Agility", "Crit", "Haste", "Versatility", "Mastery"}},
			-- Subtlety
			[3] = { type = "melee", stats = {"Agility", "Versatility", "Crit", "Mastery", "Haste"}},
		}
	},
	-- Priest
	[5] = {
		defaultSpec = 1,
		specs = {
			-- Discipline
			[1] = { type = "caster", stats = {"Intellect", "Haste", "Crit", "Versatility", "Mastery"}},
			-- Holy
			[2] = { type = "caster", stats = {"Crit", "Haste", "Versatility", "Intellect", "Mastery"}},
			-- Shadow
			[3] = { type = "caster", stats = {"Haste", "Crit", "Versatility", "Mastery", "Intellect"}},
		}
	},
	-- DeathKnight
	[6] = {
		defaultSpec = 3,
		specs = {
			-- Blood
			[1] = { type = "melee", stats = {"Strength", "Versatility", "Haste", "Crit", "Mastery", "Armor", "--", "Parry"}},
			-- Frost
			[2] = { type = "melee", stats = {"Strength", "Mastery", "Crit", "Versatility", "Haste"}},
			-- Unholy
			[3] = { type = "melee", stats = {"Strength", "Haste", "Crit", "Versatility", "Mastery"}},
		}
	},
	-- Shaman
	[7] = {
		defaultSpec = 1,
		specs = {
			-- Elemental
			[1] = { type = "caster", stats = {"Intellect", "Versatility", "Crit", "Haste", "Mastery"}},
			-- Enhancement
			[2] = { type = "melee", stats = {"Haste", "Crit", "Mastery", "Versatility", "Agility"}},
			-- Restoration
			[3] = { type = "caster", stats = {"Intellect", "Crit", "Versatility", "Haste", "Mastery", "--", "MP5"}},
		}
	},
	-- Mage
	[8] = {
		defaultSpec = 3,
		specs = {
			-- Arcane
			[1] = { type = "caster", stats = {"Intellect", "Crit", "Haste", "Mastery", "Versatility"}},
			-- Fire
			[2] = { type = "caster", stats = {"Intellect", "Mastery", "Versatility", "Haste", "Crit"}},
			-- Frost
			[3] = { type = "caster", stats = {"Intellect", "Crit", "Haste", "Versatility", "Mastery"}},
		}
	},
	-- Warlock
	[9] = {
		defaultSpec = 1,
		specs = {
			-- Affliction
			[1] = { type = "caster", stats = {"Mastery", "Intellect", "Haste", "Crit", "Versatility"}},
			-- Demonology
			[2] = { type = "caster", stats = {"Intellect", "Haste", "Crit", "Versatility", "Mastery"}},
			-- Destruction
			[3] = { type = "caster", stats = {"Mastery", "Haste", "Crit", "Intellect", "Versatility"}},
		}
	},
	-- Monk
	[10] = {
		defaultSpec = 3,
		specs = {
			-- Brewmaster
			[1] = { type = "melee", stats = {"Agility", "Mastery", "Crit", "Versatility", "Haste", "Armor", "--", "Dodge"}},
			-- Mistweaver
			[2] = { type = "caster", stats = {"Crit", "Mastery", "Versatility", "Intellect", "Haste", "--", "MP5"}},
			-- Windwalker
			[3] = { type = "melee", stats = {"Agility", "Versatility", "Mastery", "Crit", "Haste"}},
		}
	},
	-- Druid
	[11] = {
		defaultSpec = 2,
		specs = {
			-- Balance
			[1] = { type = "caster", stats = {"Haste", "Mastery", "Crit", "Versatility", "Intellect"}},
			-- Feral
			[2] = { type = "melee", stats = {"Crit", "Mastery", "Versatility", "Haste", "Agility"}},
			-- Guardian
			[3] = { type = "melee", stats = {"Armor", "Agility", "Stamina", "Versatility", "Mastery", "Haste", "Crit", "--", "Dodge"}},
			-- Restoration
			[4] = { type = "caster", stats = {"Mastery", "Haste", "Versatility", "Crit", "Intellect", "--", "MP5"}},
		}
	},
	-- Demon Hunter
	[12] = {
		defaultSpec = 1,
		specs = {
			-- Havoc
			[1] = { type = "melee", stats = {"Versatility", "Crit", "Haste", "Agility", "Mastery"}},
			-- Vengeance
			[2] = { type = "melee", stats = {"Agility", "Haste", "Versatility", "Mastery", "Crit", "--", "Dodge"}},
		}
	}
}

-- Load Libraries
local ldb = LibStub:GetLibrary("LibDataBroker-1.1")

-- Main addon object
--@type CharacterStats
local CharacterStats = {
	addonName = addonName,
	versionString = GetAddOnMetadata(addonName, "Version");
	addonColor = "EE2200",
}
function CharacterStats.print(message)
	print('|c00'..CharacterStats.addonColor..'['..CharacterStats.addonName..' v'..CharacterStats.versionString..']|r ' .. message)
end

CharacterStats.dataObject = ldb:NewDataObject(
		"Character Stats", {
			type = "data source",
			label = "Stats",
			text = "",
			icon = ""
		})

-- Unit class and spec
CharacterStats.unitClassIndex = nil
CharacterStats.unitSpecIndex = nil
-- Event listener on PLAYER_SPECIALIZATION_CHANGED and update the spec index
CharacterStats.listeners = {
	["PLAYER_SPECIALIZATION_CHANGED"] = function(unitID)
		if unitID ~= 'player' then return end
		CharacterStats.unitSpecIndex = GetSpecialization()
		CharacterStats.print("new spec ("..CharacterStats.unitSpecIndex..")")
	end,
}

--
-- Helper functions to determine what type of stat is more relevant.
--

-- Is it a melee DPS/Tank class (basically using a melee weapon to dps)
local function is_melee(class, spec)
	return Classes[class].specs[spec].type == "melee"
end

-- Is it a ranged physical DPS class (basically using a ranged weapon to dps)
local function is_ranged(class, spec)
	return Classes[class].specs[spec].type == "ranged"
end

-- Is it a spell caster DPS
local function is_spellCaster(class, spec)
	return Classes[class].specs[spec].type == "caster"
end

-- All supported stats
local StatsUpdateFunctions = {
	["Strength"] = function(class, spec)
		local base, stat, posBuff, negBuff = UnitStat("player", 1);
		return stat end,

	["Agility"] = function(class, spec)
		local base, stat, posBuff, negBuff = UnitStat("player", 2);
		return stat end,

	["Stamina"] = function(class, spec)
		local base, stat, posBuff, negBuff = UnitStat("player", 3);
		return stat end,

	["Intellect"] = function(class, spec)
		local base, stat, posBuff, negBuff = UnitStat("player", 4);
		return stat end,

	["Spirit"] = function(class, spec)
		local base, stat, posBuff, negBuff = UnitStat("player", 5);
		return stat end,

	["MP5"] = function(class, spec)
		local base, casting = GetManaRegen()
		return string.format("%.0f", casting * 5) end,

	-- Offense
	["Attack Power"] = function(class, spec)
		local base, posBuff, negBuff = UnitAttackPower("player")
		return (base + posBuff + negBuff) end,

	-- Defense
	["Dodge"] = function(class, spec)
		local value = GetDodgeChance()
		return string.format("%.2f%%", value) end,

	["Parry"] = function(class, spec)
		local value = GetParryChance()
		return string.format("%.2f%%", value) end,

	["Block"] = function(class, spec)
		local value = GetBlockChance()
		return string.format("%.2f%%", value) end,

	["Armor"] = function(class, spec)
		local baselineArmor, effectiveArmor, armor, bonusArmor = UnitArmor("player")
		local armorReduction = PaperDollFrame_GetArmorReduction(effectiveArmor, UnitEffectiveLevel("player"))
		return string.format("%.2f%%", armorReduction) end,

	-- Enhancements
	["Crit"] = function(class, spec)
		local value = 0
		if is_melee(class, spec) then
			value = GetCritChance("player")
		elseif is_ranged(class, spec) then
			value = GetRangedCritChance()
		elseif is_spellCaster(class, spec) then
			local holySchool = 2;
			local minCrit = GetSpellCritChance(holySchool);
			local spellCrit;
			for i=(holySchool+1), 7 do
				spellCrit = GetSpellCritChance(i);
				minCrit = min(minCrit, spellCrit);
			end
			value = minCrit
		end
		return string.format("%.2f%%", value) end,

	["Haste"] = function(class, spec)
		local value = 0
		if is_melee(class, spec) then
			value = GetMeleeHaste("player")
		elseif is_ranged(class, spec) then
			value = GetRangedHaste("player")
		elseif is_spellCaster(class, spec) then
			value = UnitSpellHaste("player")
		end
		return string.format("%.2f%%", value) end,

	["Mastery"] = function(class, spec)
		local value = GetMasteryEffect("player")
		return string.format("%.2f%%", value) end,

	["Versatility"] = function(class, spec)
		local value = GetCombatRatingBonus("29") + GetVersatilityBonus("29")
		return string.format("%.2f%%", value) end,

	["Avoidance"] = function(class, spec)
		local value = GetCombatRatingBonus("21")
		return string.format("%.2f%%", value) end,

	["Leech"] = function(class, spec)
		local value = GetLifesteal("player")
		return string.format("%.2f%%", value) end,

	["Speed"] = function(class, spec)
		local value = GetUnitSpeed("player")
		return string.format("%.2f%%", value / 7 * 100) end,

}

--
--
--
local CharacterStats_Frame = CreateFrame("frame")
CharacterStats_Frame:SetScript("OnEvent", function(self, event, ...)
	if not CharacterStats.listeners[event] then return end
	CharacterStats.listeners[event](...)
end)
for k, v in pairs(CharacterStats.listeners) do
	CharacterStats_Frame:RegisterEvent(k); -- Register all events for which handlers have been defined
end


CharacterStats_Frame:SetScript("OnUpdate", function(self, elap)
	local bdo = CharacterStats.dataObject
	local class = CharacterStats.unitClassIndex
	if class == nil then
		local localizedClass, englishClass, classIndex = UnitClass("player");
		CharacterStats.unitClassIndex = classIndex
		class = classIndex
	end
	local spec = CharacterStats.unitSpecIndex
	if spec == nil then
		local specIndex = GetSpecialization()
		CharacterStats.unitSpecIndex = (specIndex == nil) and Classes[class].defaultSpec or specIndex
		spec = CharacterStats.unitSpecIndex
	end

	-- check for unknown class
	if not Classes[class] then
		CharacterStats.print("unknown class: "..class)
		return end
	-- check for unknown spec
	if not Classes[class].specs[spec] then
		CharacterStats.print("unknown spec: "..spec)
		return end

	local stats = Classes[class].specs[spec].stats

	local text = ""
	for index, stat in ipairs(stats) do
		if stat == "--" then
			text = text.."\n"
		else
			local value = StatsUpdateFunctions[stat](class, spec)
			text = text..string.format("%-13s : %s\n", stat, value)
		end
	end
	-- Append Leech and Avoidance
	text = text.."\n"
	text = text..string.format("%-13s : %s\n", "Leech", StatsUpdateFunctions["Leech"](class, spec))
	text = text..string.format("%-13s : %s\n", "Avoidance", StatsUpdateFunctions["Avoidance"](class, spec))

	-- Append Speed
	text = text.."\n"
	text = text..string.format("%-13s : %s\n", "Speed", StatsUpdateFunctions["Speed"](class, spec))

	bdo.text = text
end)
