
--Servidor
local x1, y1, z1 = 1721.361328125, -1120.359375, 24.085935592651 
function triggerTheAlarm(thePlayer)
	if getPlayerTeam(thePlayer) ~= getTeamFromName("Los Santos Fire Department") then
		return false
	end

	local x, y, z = getElementPosition(thePlayer)
	local distance = getDistanceBetweenPoints3D(x1, y1, z1, x, y, z)
	if (distance > 5) then
		return false
	end
	
	--Faz /me emote para cada membro fd.
	local fireTeam = getTeamFromName("Los Santos Fire Department")
    if (fireTeam) then
		local playersOnFireTeam = getPlayersInTeam ( fireTeam ) 
        for k, v in ipairs (playersOnFireTeam) do
			exports.global:sendLocalDoAction(v, "The sound of a beeper going off can be heard off " .. exports.global:getPlayerName(v) .."'s person.")
		end
	end
	local players = getElementsByType("player")
	for i, player in ipairs (players) do
		--Começa a tocar o som do alarme para todos os jogadores no local.
		x, y, z = getElementPosition(player)
		if getDistanceBetweenPoints3D(x1, y1, z1, x, y, z) <= 5 then
			triggerClientEvent(player,"playAlarmAroundTheArea", thePlayer)
		end
		--Começa a tocar o som do pager para todos que estiverem ao redor do player que recebeu o aviso.
		local theTeam = getPlayerTeam(player)
		if theTeam and getTeamName(theTeam) == "Los Santos Fire Department" then
			triggerClientEvent(player,"notifyAnFdMember", thePlayer) --Start sending pager to FD members.
			for k, p in ipairs(players) do
				local x2, y2, z2 = getElementPosition(p)
				if getDistanceBetweenPoints3D(x, y, z, x2, y2, z2) <= 5 then
					triggerClientEvent(p,"playPagerSfxAround", player)
				end
			end
		end
	end 
end
addCommandHandler("alarm", triggerTheAlarm)
-- Está feito, eu acho, vamos testar. Quer vir no servidor dev? ou eu pergunto a alguém? ya eu vou - senha: yesyesyes k
-- É o jogador porque é ok, entendi. haha
-- Isso tudo funciona perfeitamente. Aciona o evento do cliente (linha 12), diga quando você está aqui.

-- Isso. 
