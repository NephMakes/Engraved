local _, Engraved = ...

function Engraved:AddSlashCommand()
	SlashCmdList["ENGRAVED"] = Engraved.SlashCommand
	SLASH_ENGRAVED1 = "/engraved"
end

function Engraved.SlashCommand()
	Engraved:ToggleLockUnlock()
end
