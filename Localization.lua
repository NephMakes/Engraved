-- If you want to be super helpful and translate these, I'll credit you here, 
-- on Curse, and on WoWInterface.  Thanks!   -- Neph

local _, Engraved = ...
Engraved.Localization = {};
local Localization = Engraved.Localization;

Localization["enUS"] = {
	-- ACHERUS = "Acherus", 
	AT_REST_OPACITY = "At rest opacity", 
	-- BLACKROCK = "Blackrock", 
	CONFIG_MODE = "Config mode",
	ELDRITCH = "Eldritch",
	FROSTMOURNE = "Frostmourne",
	-- HIDE_OUT_OF_COMBAT = "Hide runes out of combat", 
	NEXUS = "Nexus",
	ICECROWN = "Icecrown", 
	IRONFORGE = "Ironforge", 
	HIGH = "High", 
	HIDDEN = "Hidden", 
	LOCK = "Lock", 
	LOCK_RUNE_DISPLAY = "Lock rune display", 
	LOW = "Low", 
	-- OPAQUE = "Opaque", 
	OPEN_OPTIONS_MENU = "Open options menu", 
	OPTIONS_MENU = "Options menu", 
	OUT_OF_COMBAT_OPACITY = "Out of combat opacity", 
	-- PANDAREN = "Pandaren", 
	PLAY_MODE = "Play mode",
	-- PRIORITIZE_RUNES = "Prioritize runes",
	RESET_POSITIONS = "Reset positions",
	RUNE_COLOR = "Rune color", 
	RUNE = "Rune", 
	RUNE_THEME = "Rune theme", 
	-- SHADOWMOON = "Shadowmoon", 
	SUBTEXT = "These options let you change the appearance of Engraved's combat resource display", 
	ULDUAR = "Ulduar", 
	UNLOCK = "Unlock"
}; 

Localization["zhCN"] = {
-- Thanks to Curse user fyhcslb for the translation! 
	-- ACHERUS = "阿彻鲁斯", 
	AT_REST_OPACITY = "休息时的不透明度", 
	-- BLACKROCK = "黑石", 
	CONFIG_MODE = "设置模式",
	ELDRITCH = "埃尔德齐",
	FROSTMOURNE = "霜之哀伤",
	-- HIDE_OUT_OF_COMBAT = "离开战斗时隐藏符文", 
	NEXUS = "魔枢",
	ICECROWN = "冰冠冰川", 
	IRONFORGE = "铁炉堡", 
	HIGH = "高", 
	HIDDEN = "隐藏", 
	LOCK = "锁定", 
	LOCK_RUNE_DISPLAY = "锁定符文显示", 
	LOW = "低", 
	-- OPAQUE = "不透明", 
	OPEN_OPTIONS_MENU = "打开选项菜单", 
	OPTIONS_MENU = "选项菜单", 
	OUT_OF_COMBAT_OPACITY = "离开战斗时的不透明度", 
	-- PANDAREN = "熊猫人", 
	PLAY_MODE = "游戏模式",
	-- PRIORITIZE_RUNES = "排序符文", -- Needs review
	RESET_POSITIONS = "重置位置",
	RUNE_COLOR = "符文颜色", 
	RUNE = "符文", 
	RUNE_THEME = "符文主题", 
	-- SHADOWMOON = "影月", 
	SUBTEXT = "这些选项可以让你调整 Engraved 战斗资源显示的外观", 
	ULDUAR = "奥杜尔", 
	UNLOCK = "解锁"
};

Localization["zhTW"] = {
-- Thanks to Curse user gaspy10 for the translation! 
	-- ACHERUS = "亞榭洛",
	AT_REST_OPACITY = "休息中不透明度",
	-- BLACKROCK = "黑石",
	CONFIG_MODE = "設定模式",
	ELDRITCH = "Eldritch",
	FROSTMOURNE = "霜之哀傷",
	-- HIDE_OUT_OF_COMBAT = "非戰鬥中隱藏",
	NEXUS = "奧核之心",
	ICECROWN = "冰冠城塞",
	IRONFORGE = "鐵爐堡",
	HIGH = "高",
	HIDDEN = "隱藏",
	LOCK = "鎖定",
	LOCK_RUNE_DISPLAY = "鎖定顯示位置",
	LOW = "低",
	-- OPAQUE = "不透明",
	OPEN_OPTIONS_MENU = "開啟設定選單",
	OPTIONS_MENU = "設定選單",
	OUT_OF_COMBAT_OPACITY = "非戰鬥中不透明度",
	-- PANDAREN = "熊貓人",
	PLAY_MODE = "遊戲模式",
	-- PRIORITIZE_RUNES = "符文優先順序",
	RESET_POSITIONS = "重置位置",
	RUNE_COLOR = "顏色",
	RUNE = "符文",
	RUNE_THEME = "樣式",
	-- SHADOWMOON = "影月",
	SUBTEXT = "這些選項讓你可以更改連擊點數的顯示外觀",
	ULDUAR = "奧杜亞",
	UNLOCK = "解除鎖定"
};

--[[
Localization["deDE"] = {}; 
Localization["esES"] = {}; 
Localization["esMX"] = {}; 
Localization["frFR"] = {}; 
Localization["itIT"] = {}; 
Localization["koKR"] = {}; 
Localization["ptBR"] = {}; 
Localization["ruRU"] = {}; 
--]]

function Engraved:LocalizeStrings()
	Engraved.Strings = Localization[GetLocale()] or Localization["enUS"];
	Engraved:SetAllTheText();
end

function Engraved:SetAllTheText()
	local strings = Engraved.Strings;

	local optionsPanel = _G["InterfaceOptionsEngravedPanel"];
	optionsPanel.subtext:SetText(strings.SUBTEXT);

	optionsPanel.outOfCombatAlpha.Text:SetText(strings.OUT_OF_COMBAT_OPACITY);
	optionsPanel.outOfCombatAlpha.High:SetText(strings.HIGH);
	optionsPanel.outOfCombatAlpha.Low:SetText(strings.HIDDEN);

	optionsPanel.runeColor.Text:SetText(strings.RUNE_COLOR);

	local runeTheme = optionsPanel.runeTheme;
	runeTheme.Text:SetText(strings.RUNE_THEME);
	runeTheme.optionList[1].text = strings.ICECROWN;
	runeTheme.optionList[2].text = strings.NEXUS;
	runeTheme.optionList[3].text = strings.ULDUAR;
	runeTheme.optionList[4].text = strings.FROSTMOURNE;
	runeTheme.optionList[5].text = strings.ELDRITCH;

	optionsPanel.configButton.Text:SetText(strings.CONFIG_MODE);
	optionsPanel.playButton.Text:SetText(strings.PLAY_MODE);
end

