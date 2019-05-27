local currentWeather = 10
local interior = false
local timeSavedHour, timeSavedMinute
local x, y, z = nil

function ChangePlayerWeather(weather, blended)
	currentWeather = weather
	interior = false
	if blended then
		if getElementInterior( getLocalPlayer( ) ) == 0 then
			 timeHour, timeMinute = getTime()
			 timeSavedHour, timeSavedMinute = getTime()
			timeHour = timeHour - 1
			setTime(timeHour, timeMinute)
			setWeatherBlended( currentWeather )
			setTimer( forceWeather, 60000, 1)
			setTimer( updateTime, 1000, 60)
		end
	end
end
addEvent( "weather:update", true )
addEventHandler( "weather:update", getRootElement(), ChangePlayerWeather )

function updateTime()
	local timeHour, timeMinute = getTime()
	timeMinute = timeMinute + 1
	if timeMinute == 60 then
		timeHour = timeHour + 1
		timeMinute = 0
	end
	if timeHour == 24 then
		timeHour = 0
	end
	setTime(timeHour, timeMinute)
	--outputDebugString("step "..timeHour ..":"..timeMinute)
end

function updateInterior()
	if getElementInterior( getLocalPlayer( ) ) > 0 then
		interior = true
		if getWeather( ) ~= 3 then
			setWeather( 3 )
			setSkyGradient( 0, 0, 0, 0, 0, 0 )
		end
	else
		interior = false
		local currentWeatherID, blended = getWeather( )
		if currentWeatherID ~= currentWeather and not blended then
			setWeather( currentWeather )
			resetSkyGradient( )
		end
	end
end
setTimer( updateInterior, 2000, 0)

function forceWeather(  )
	setWeather( currentWeather )
	resetSkyGradient( )
	setTime(timeSavedHour, timeSavedMinute+1)
	--outputDebugString("force step "..timeSavedHour ..":"..timeSavedMinute)
end

addEventHandler( "onClientResourceStart", getResourceRootElement( ),
	function( )
		triggerServerEvent( "weather:request", getLocalPlayer( ) )
		return
	end
)
setDevelopmentMode(true)

addCommandHandler("fw", function()
	if exports.integration:isPlayerAdmin(localPlayer) then
	outputChatBox("Fireworks created!", getRootElement())
	fxAddSparks(x, y, z+1, 0, 0, 0, 5, 1000, 0, 0, 1, false, 2, 2)
	--fxAddGunshot(x, y+0.5, z+1, 1, 3, 2, true)
	--fxAddTankFire(x, y+0.5, z+1, 1, 3, 2, true)
	--fxAddGunshot(x, y+0.5, z+1, 1, 3, 2, true)
	--fxAddTyreBurst(x, y+0.5, z+1, 1, 3, 2)
	--fxAddTyreBurst(x, y+0.5, z+1, 1, 3, 2)
	outputChatBox("Fireworks created!", getRootElement())
	else
	end
end)

addCommandHandler("setfw", function()
	if exports.integration:isPlayerAdmin(localPlayer) then
	x, y, z = getElementPosition(localPlayer)
	outputChatBox("Fireworks position set!", getRootElement())
	else
	end
end)

addCommandHandler("resetfw", function()
	if exports.integration:isPlayerAdmin(localPlayer) then
	x, y, z = nil, nil, nil
	outputChatBox("Fireworks position reset!", getRootElement())
	else
	end
end)

GUIEditor = {
    tab = {},
    tabpanel = {},
    button = {},
    window = {},
    memo = {}
}
function snowInfoGUI()
	if isElement(GUIEditor.window[1]) then destroyElement(GUIEditor.window[1]) end
	GUIEditor.window[1] = guiCreateWindow(576, 198, 464, 522, "Informações sobre o jogo de neve", false)
	guiWindowSetSizable(GUIEditor.window[1], false)

	GUIEditor.button[1] = guiCreateButton(11, 487, 436, 25, "Fechar", false, GUIEditor.window[1])
	addEventHandler("onClientGUIClick", GUIEditor.button[1], function ()
			if isElement(GUIEditor.window[1]) then destroyElement(GUIEditor.window[1]) end
		end, false)
	GUIEditor.tabpanel[1] = guiCreateTabPanel(9, 23, 439, 459, false, GUIEditor.window[1])

	GUIEditor.tab[1] = guiCreateTab("Inicio", GUIEditor.tabpanel[1])

	GUIEditor.memo[1] = guiCreateMemo(5, 7, 427, 424, [[ Olá,

Dezembro está chegando, com o inverno a apenas duas semanas e a neve caindo ao redor do globo. Nossa zona de roleplay ficcional, San Andreas está agora começando a experimentar a queda de neve e temperatura de todas as faixas. Este é realmente um evento de todo o servidor, se você quiser ou não participar visualmente, espera-se que você siga as regras.

	Reminder:
	/snow para alternar a queda de neve.
	/groundsnow para alternar os shaders de neve do solo.
	/snowsettings para personalizar a queda de neve.

	* Nota violação destas regras pode resultar em punição administrativa para powergaming.
	* Observe que as snowplows e snowmobiles podem operar como se tivessem pneus de neve instalados.
	* Observe que os snowmobiles não são motocicletas no caso de restrições de uso. ]], false, GUIEditor.tab[1])
	guiMemoSetReadOnly(GUIEditor.memo[1], true)

	GUIEditor.tab[2] = guiCreateTab("Level 0", GUIEditor.tabpanel[1])

	GUIEditor.memo[2] = guiCreateMemo(5, 7, 427, 424, [[ Geada, temperaturas abaixo de zero (Level 0)

	Temperatura: Variando de -5?C para 0?C | Variando de 23?F para 32?F

	Aviso meteorológico: Pneus de neve aconselhados

	Configurações de neve: 0 (somente /snow, não se incomode, edição para 0)

	REGRAS
	Veículo:
	Velocidade máxima no pavimento: 120 km/h, 135 km/h com pneus de neve
	Velocidade máxima fora da estrada: 50 km/h, 60 km/h com pneus de neve.
	Mostrar medo de gelo
	Preferir o uso de estradas recentemente pavimentadas. (Se o serviço de pavimentação for anunciado)
	Intervalo de visibilidade: Regular, controlado pela densidade de névoa, se houver.

	Pessoa:
	Desgaste do inverno jogo de neve, caso contrário, evitar vadiagem no frio por nenhuma razão.\
	Intervalo de visibilidade: Regular, controlado pela densidade de névoa, se houver. ]], false, GUIEditor.tab[2])
	guiMemoSetReadOnly(GUIEditor.memo[2], true)

	GUIEditor.tab[3] = guiCreateTab("Level 1", GUIEditor.tabpanel[1])

	GUIEditor.memo[3] = guiCreateMemo(5, 7, 427, 424, [[ Rajada de neve (Level 1)

	Temperatura: Variando de -12?C para -6?C | Variando de 10?F para 21?F

	Aviso meteorológico: Pneus de neve aconselhados

	Configurações de neve:
	Densidade; 1000
	Tamanho do floco de neve: 1-3
	Velocidade do vento de neve: 7
	Velocidade de queda de neve: 1-3

	REGRAS
	Veículo:
	Velocidade máxima no pavimento: 80 km/h, 90 km/h com pneus de neve
	Velocidade máxima fora da estrada: 20 km/h, 30 km/h com pneus de neve.
	Mostrar medo de gelo
	Prefere o uso de estradas recentemente pavimentadas. (Se o serviço de pavimentação for anunciado)
	Motocicletas usadas menos.
	Alcance de visibilidade: 80 pés (70 para motos)

	Pessoa:
	Roupa de inverno
	Jogar neve, caso contrário, evite vadiagem no frio sem motivo.
	Alcance de visibilidade: 65 pés ]], false, GUIEditor.tab[3])
	guiMemoSetReadOnly(GUIEditor.memo[3], true)

	GUIEditor.tab[4] = guiCreateTab("Level 2", GUIEditor.tabpanel[1])

	GUIEditor.memo[4] = guiCreateMemo(5, 7, 427, 424, [[ Tempestade de neve (Level 2)

	Temperatura: Variando de -18 ° C a -9 ° C | Variando de -0.4? F a 16? F

	Aviso meteorológico: Pneus de neve aconselhados
	Aviso meteorológico: aviso de congelamento
	Ameteorológico: Aeronave aterrada (IC)

	Configurações de neve:
	Densidade; 3500
	Tamanho do floco de neve: 2-4
	Velocidade do Vento de Neve: 40
	Velocidade de Queda de Neve: 5-9

	REGRAS
	Veículo:
	Velocidade máxima no pavimento: 50 km/ h, 65 km/h com pneus de neve
	Máxima velocidade fora de estrada: 15 km/h, 20 km/h com pneus de neve
	Mostrar medo de gelo
	Prefere o uso de estradas recentemente pavimentadas. (Se o serviço de pavimentação for anunciado)
	Motocicletas usadas menos
	Alcance de visibilidade: 50 pés (30 para motocicletas)

	Pessoa:
	Artigos de inverno obrigatórios
	Jogar neve, caso contrário, evite vadiagem no frio sem motivo.
	Alcance de visibilidade: 30 pés
	 ]], false, GUIEditor.tab[4])
	guiMemoSetReadOnly(GUIEditor.memo[4], true)

	GUIEditor.tab[5] = guiCreateTab("Level 3", GUIEditor.tabpanel[1])

	GUIEditor.memo[5] = guiCreateMemo(5, 7, 427, 424, [[ Nevasca (Level 3)

	Temperatura: Variando de -22 ° C a -9 ° C | Variando de -7,6? F a 16? F

	Aviso meteorológico: Pneus de neve aconselhados
	Aviso meteorológico: aviso de congelamento severo
	Aviso meteorológico: Aeronave aterrada (IC)

	Configurações de neve:
	Densidade; 5000
	Tamanho do floco de neve: 2-4
	Velocidade do Vento de Neve: 80
	Velocidade de Queda de Neve: 7-12

	REGRAS
	Veículo:
	Velocidade máxima no pavimento: 35 km / h, 45 km / h com pneus de neve
	Máxima velocidade fora de estrada: 10 km / h
	Mostrar medo de gelo
	Prefere o uso de estradas recentemente pavimentadas. (Se o serviço de pavimentação for anunciado)
	Motocicletas não utilizadas.
	Aeronave Aterrada (OOC)
	Alcance de visibilidade: 25 pés

	Pessoa:
	Artigos de inverno obrigatórios
	Jogar neve, caso contrário, evite vadiagem no frio sem motivo.
	Neve densa, corrida impossível - correr muito cansativo.
	Afiada neve soprando contra a pele exposta.
	Alcance de visibilidade: 15 pés ]], false, GUIEditor.tab[5])
	guiMemoSetReadOnly(GUIEditor.memo[5], true)

	GUIEditor.tab[6] = guiCreateTab("Level 4", GUIEditor.tabpanel[1])

	GUIEditor.memo[6] = guiCreateMemo(5, 7, 427, 424, [[ Tudo BRANCO (Level 4)

	Temperatura: Variando de -22 ° C a -9 ° C | Variando de -7,6? F a 16? F

	Aviso meteorológico: Pneus de neve aconselhados
	Aviso meteorológico: aviso de congelamento severo
	Aviso meteorológico: Aeronave aterrada (IC)

	Configurações de neve:
	Densidade; 7000
	Tamanho do floco de neve: 3-5
	Velocidade do Vento de Neve: 100
	Velocidade de Queda de Neve: 10-15

	REGRAS
	Veículo:
	Velocidade máxima no pavimento: 20 km / h, 30 km / h com pneus de neve
	Máxima velocidade de pavimentação: fora dos limites
	Mostrar medo de gelo
	Prefere o uso de estradas recentemente pavimentadas. (Se o serviço de pavimentação for anunciado)
	Motocicletas não utilizadas.
	Aeronave Aterrada (OOC)
	Alcance de visibilidade: 10 pés

	Pessoa:
	Artigos de inverno obrigatórios
	Jogar neve, caso contrário, evite vadiagem no frio sem motivo.
	Neve densa, corrida impossível - correr muito cansativo.
	Afiada neve soprando contra a pele exposta.
	Alcance de visibilidade: 1,5 m ]], false, GUIEditor.tab[6])
	guiMemoSetReadOnly(GUIEditor.memo[6], true)
end
--addCommandHandler("snowinfo", snowInfoGUI, false, false)
