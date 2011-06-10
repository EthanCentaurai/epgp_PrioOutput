
local _, data = ...

local msg = "%s: %.2f (EP: %d, GP: %d)"
local minEP


local function sort(a, b)
	return a.pr > b.pr
end

local function output(num, ...)
	if GetNumRaidMembers() == 0 then
		print(ERR_NOT_IN_RAID)
		return
	end

	num = tonumber(num) or 5
	data = wipe(data)
	minEP = EPGP:GetMinEP()

	for i = 1, GetNumRaidMembers() do
		local name = UnitName("raid"..i)
		local ep, gp, pr = 0, 0, 0

		if UnitIsInMyGuild(name) then
			ep, gp = EPGP:GetEPGP(name)

			if ep >= minEP and (ep >= 0 or gp >= 0) then
				pr = ep / gp
			end
		end

		table.insert(data, { name = name, ep = ep, gp = gp, pr = pr })
	end

	table.sort(data, sort)
	SendChatMessage("EPGP Loot Priority:", "RAID")

	for i = 1, num do
		if not data[i] then break end

		local t = data[i]

		SendChatMessage(msg:format(t.name, t.pr, t.ep, t.gp), "RAID")
	end
end


_G["SLASH_EPGP_PRIOOUTPUT1"] = "/priooutput"
_G["SLASH_EPGP_PRIOOUTPUT2"] = "/prio"
_G.SlashCmdList["EPGP_PRIOOUTPUT"] = output
