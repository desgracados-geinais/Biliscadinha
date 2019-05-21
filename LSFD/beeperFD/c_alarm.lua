--client
function notifyAnFdMember() 
	outputChatBox("[BEEPER] " .. exports.global:getPlayerName(source) .. " has triggered the LSFD-wide alarm.",245, 40, 135)
end
addEvent("notifyAnFdMember", true)
addEventHandler("notifyAnFdMember", root, notifyAnFdMember) 

function playAlarmAroundTheArea()
	playSound3D("alarm.mp3", 1721.361328125, -1120.359375, 24.085935592651)
end
addEvent("playAlarmAroundTheArea", true)
addEventHandler("playAlarmAroundTheArea", root, playAlarmAroundTheArea)

function playPagerSfxAround()
	local x, y, z = getElementPosition(source)
	local pagerSound = playSound3D("pager.mp3", x, y, z) -- Aqui. Não obtém o  x y z.
	setSoundVolume(pagerSound, 0.8)
end
addEvent("playPagerSfxAround", true)
addEventHandler("playPagerSfxAround", root, playPagerSfxAround)  

--
-- Aqui é onde eu recebo mais problemas. O que é suposto fazer: tocar alarm.mp3 no posto de bombeiros, e tocar pager.mp3 em todas as coordenadas dos membros do FD (assim como o outputChatBox para todos os membros do FD)

-- O que faz agora: toca o som no FD, envia o outputChatBox TWICE e não reproduz o pager porque ele não obtém as coordenadas dos membros do fd.k
