local centerOfMass = {}
local realVeh = nil

function math.round(number, decimals, method)
    decimals = decimals or 0
    local factor = 10 ^ decimals
    if (method == "ceil" or method == "floor") then return math[method](number * factor) / factor
    else return tonumber(("%."..decimals.."f"):format(number)) end
end

function playError()
	playSoundFrontEnd(4)
end

local wHandling, wEdit, bSave , handlingList, theVehicle = nil, nil, nil, nil, nil
local saveToSQL = nil
local btn = {}
function createHandlingWindow(mode)
	--outputDebugString(tostring(mode))
	theVehicle = getPedOccupiedVehicle(localPlayer)
	if not theVehicle or not mode then
		return false
	end
	saveToSQL = mode
	local width, height = 400, 400
	local scrWidth, scrHeight = guiGetScreenSize()
	local x = 0
	local y = scrHeight-height
	
	local year = getElementData(theVehicle, "year") or 0
	local brand = getElementData(theVehicle, "brand") or 0
	local model = getElementData(theVehicle, "maximemodel") or 0
	local vehicle_shop_id = getElementData(theVehicle, "vehicle_shop_id")
	local vehName = year.." "..brand.." "..model
	local title =  ""
	if mode == 0 then
		title = "ALL instances of #"..vehicle_shop_id.." ("..vehName..")"
	elseif mode == 1 then
		title = "Unique Handling of vehicle ID#"..getElementData(theVehicle, "dbid").." ("..vehName..")"
	elseif mode == 2 then
		title = "Vehicle Stats - "..vehName
	else
		title =  ""
	end
	
	if wHandling and isElement(wHandling) then
		closeHandlingWindows()
	end
	
	local handlingCurrent = getVehicleHandling(theVehicle)
	
	wHandling = guiCreateWindow(x, y, width, height, title, false)
	guiWindowSetMovable(wHandling,false)
	guiWindowSetSizable(wHandling,false)
	--guiCreateStaticImage(0.05, 0.02, 0.9, 0.25, "logo.png", true, wHandling)

	handlingList = guiCreateGridList(0, 0.05, 1, 0.875, true, wHandling)
	guiGridListSetSortingEnabled(handlingList, false)
	nameColumn = guiGridListAddColumn(handlingList, "Nome", 0.73)
	valueColumn = guiGridListAddColumn(handlingList, "Valor", 0.2)
	
	-- Engine Handling Lines
	maxVelocity = guiGridListAddRow(handlingList)
		guiGridListSetItemText(handlingList, maxVelocity, nameColumn, "Velocidade máxima (Km/h)", false, false)
		guiGridListSetItemText(handlingList, maxVelocity, valueColumn, ""..tostring(math.round(handlingCurrent["maxVelocity"], 0)).."", false, false)
	acceleration = guiGridListAddRow(handlingList)
		guiGridListSetItemText(handlingList, acceleration, nameColumn, "Aceleração", false, false)
		guiGridListSetItemText(handlingList, acceleration, valueColumn, ""..tostring(math.round(handlingCurrent["engineAcceleration"], 1)).."", false, false)
	engineInertia = guiGridListAddRow(handlingList)
		guiGridListSetItemText(handlingList, engineInertia, nameColumn, "Inércia do motor", false, false)
		guiGridListSetItemText(handlingList, engineInertia, valueColumn, ""..tostring(math.round(handlingCurrent["engineInertia"], 1)).."", false, false)
	
	-- Suspension Handling Lines
	lowerLimit = guiGridListAddRow(handlingList)
		guiGridListSetItemText(handlingList, lowerLimit, nameColumn, "Altura de suspensão", false, false)
		guiGridListSetItemText(handlingList, lowerLimit, valueColumn, ""..tostring(handlingCurrent["suspensionLowerLimit"]).."", false, false)
	suspensionBias = guiGridListAddRow(handlingList)
		guiGridListSetItemText(handlingList, suspensionBias, nameColumn, "Viés da Suspensão", false, false)
		guiGridListSetItemText(handlingList, suspensionBias, valueColumn, ""..tostring(math.round(handlingCurrent["suspensionFrontRearBias"], 1)).."", false, false)
	suspensionForce = guiGridListAddRow(handlingList)
		guiGridListSetItemText(handlingList, suspensionForce, nameColumn, "Força de Suspensão", false, false)
		guiGridListSetItemText(handlingList, suspensionForce, valueColumn, ""..tostring(math.round(handlingCurrent["suspensionForceLevel"], 3)).."", false, false)
	suspensionDamping = guiGridListAddRow(handlingList)
		guiGridListSetItemText(handlingList, suspensionDamping, nameColumn, "Amortecimento da suspensão", false, false)
		guiGridListSetItemText(handlingList, suspensionDamping, valueColumn, ""..tostring(math.round(handlingCurrent["suspensionDamping"], 5)).."", false, false)
	steeringLock = guiGridListAddRow(handlingList)
		guiGridListSetItemText(handlingList, steeringLock, nameColumn, "Bloqueio de direção", false, false)
		guiGridListSetItemText(handlingList, steeringLock, valueColumn, ""..tostring(math.round(handlingCurrent["steeringLock"], 1)).."", false, false)
	driveType = guiGridListAddRow(handlingList)
		guiGridListSetItemText(handlingList, driveType, nameColumn, "Tipo de drive", false, false)
		guiGridListSetItemText(handlingList, driveType, valueColumn, ""..tostring(handlingCurrent["driveType"]).."", false, false)
	massWeight = guiGridListAddRow(handlingList)
		guiGridListSetItemText(handlingList, massWeight, nameColumn, "Peso maciço (Kg)", false, false)
		guiGridListSetItemText(handlingList, massWeight, valueColumn, ""..tostring(math.round(handlingCurrent["mass"], 0)).."", false, false)
	massX = guiGridListAddRow(handlingList)
		guiGridListSetItemText(handlingList, massX, nameColumn, "Centro de massa X", false, false)
		guiGridListSetItemText(handlingList, massX, valueColumn, ""..math.round(handlingCurrent["centerOfMass"][1], 2).."", false, false)
	massY = guiGridListAddRow(handlingList)
		guiGridListSetItemText(handlingList, massY, nameColumn, "Centro de massa Y", false, false)
		guiGridListSetItemText(handlingList, massY, valueColumn, ""..math.round(handlingCurrent["centerOfMass"][2], 2).."", false, false)
	massZ = guiGridListAddRow(handlingList)
		guiGridListSetItemText(handlingList, massZ, nameColumn, "Centro de massa Z", false, false)
		guiGridListSetItemText(handlingList, massZ, valueColumn, ""..math.round(handlingCurrent["centerOfMass"][3], 2).."", false, false)
	dragCoeff = guiGridListAddRow(handlingList)
		guiGridListSetItemText(handlingList, dragCoeff, nameColumn, "Coeficiente de arrasto", false, false)
		guiGridListSetItemText(handlingList, dragCoeff, valueColumn, ""..tostring(math.round(handlingCurrent["dragCoeff"], 1)).."", false, false)
	brakeForce = guiGridListAddRow(handlingList)
		guiGridListSetItemText(handlingList, brakeForce, nameColumn, "Potência de travagem", false, false)
		guiGridListSetItemText(handlingList, brakeForce, valueColumn, ""..tostring(math.round(handlingCurrent["brakeDeceleration"], 1)).."", false, false)
	brakeBias = guiGridListAddRow(handlingList)
		guiGridListSetItemText(handlingList, brakeBias, nameColumn, "Viés de frenagem", false, false)
		guiGridListSetItemText(handlingList, brakeBias, valueColumn, ""..tostring(math.round(handlingCurrent["brakeBias"], 1)).."", false, false)
	tracMultiply = guiGridListAddRow(handlingList)
		guiGridListSetItemText(handlingList, tracMultiply, nameColumn, "Multiplicador de Tracção", false, false)
		guiGridListSetItemText(handlingList, tracMultiply, valueColumn, ""..tostring(math.round(handlingCurrent["tractionMultiplier"], 2)).."", false, false)
	tracBias = guiGridListAddRow(handlingList)
		guiGridListSetItemText(handlingList, tracBias, nameColumn, "Tendência de Tração", false, false)
		guiGridListSetItemText(handlingList, tracBias, valueColumn, ""..tostring(math.round(handlingCurrent["tractionBias"], 2)).."", false, false)
		
	if mode == 0 then -- All Instances
		bReset = guiCreateButton(0.05, 0.925, 0.45, 0.05, "Carregar Padrão", true, wHandling)
		addEventHandler( "onClientGUIClick", bReset,
			function( button )
				if button == "left" then
					triggerServerEvent("handlingSystem:resetHandling", getLocalPlayer(), theVehicle, mode)
					playSuccess()
				end
			end,
		false)
		guiSetEnabled(bReset, false)
		
		bSave = guiCreateButton(0.5, 0.925, 0.45, 0.05, "Salvar no banco de dados", true, wHandling)
		addEventHandler( "onClientGUIClick", bSave,
			function( button )
				if button == "left" then
					applyHandling(theVehicle, saveToSQL)
					showConfirmReloadAllInstances(vehicle_shop_id, vehName)
				end
			end,
		false)
		guiSetEnabled(bSave, false)
	elseif mode == 1 or mode == 2 then -- Car shop test drive or Edit Unique Handling
		local btnW = 0.2
		btn["close"] = guiCreateButton(0.01, 0.925, btnW , 0.05, "Fechar", true, wHandling)
		addEventHandler( "onClientGUIClick", btn["close"],
			function( button )
				if button == "left" then
					closeHandlingWindows()
					--triggerServerEvent("handlingSystem:resetHandling", getLocalPlayer(), theVehicle, mode)
					--playSuccess()
				end
			end,
		false)
		--guiSetEnabled(btn["close"] , false)
		
		if mode == 1 then -- Edit Unique Handling
			btn["reset"] = guiCreateButton(0.01+(btnW*1+0.005), 0.925, btnW, 0.05, "Resetar", true, wHandling)
			addEventHandler( "onClientGUIClick", btn["reset"],
				function( button )
					if button == "left" then
						closeHandlingWindows()
						triggerServerEvent("handlingSystem:resetHandling", getLocalPlayer(), theVehicle, mode)
						playSuccess()
					end
				end,
			false)
			guiSetEnabled(btn["reset"] , false)
			
			btn["save"]  = guiCreateButton(0.01+(btnW*2+0.005), 0.925, btnW*2, 0.05, "Salvar no banco de dados", true, wHandling)
			addEventHandler( "onClientGUIClick", btn["save"],
				function( button )
					if button == "left" then
						applyHandling(theVehicle, mode)
						--showConfirmSaveUniqueHandling(theVehicle, mode)
					end
				end,
			false)
			guiSetEnabled(btn["save"] , false)
		end
	end
	
	addEventHandler("onClientGUIDoubleClick", handlingList, editHandlingWindow)
	if (exports.integration:isPlayerVehicleConsultant(localPlayer) or exports.integration:isPlayerAdmin(localPlayer)) then
		if btn["save"] and isElement(btn["save"]) then
			guiSetEnabled(btn["save"] , true)
		end
		if btn["reset"] and isElement(btn["reset"]) then
			guiSetEnabled(btn["reset"] , true)
		end
		if bSave and isElement(bSave) then
			guiSetEnabled(bSave, true)
		end
		if bReset and isElement(bReset) then
			guiSetEnabled(bReset, true)
		end
	elseif exports.integration:isPlayerVCTMember(localPlayer) then
		if bReset and isElement(bReset) then
			guiSetEnabled(bReset, true)
		end
	else
		removeEventHandler("onClientGUIDoubleClick", handlingList, editHandlingWindow)
	end
		
end
addEvent("veh-manager:handling:edithandling", true)
addEventHandler("veh-manager:handling:edithandling",localPlayer, createHandlingWindow)
addCommandHandler("edithandling", createHandlingWindow)

function closeHandlingWindows()
	if wHandling and isElement(wHandling) then
		destroyElement(wHandling)
		wHandling = nil
	end
	closeEditWindow()
	closeConfirmReloadAllInstances()
end

function applyHandling(veh, saveToSQL)
	local maxVelocityS = guiGridListGetItemText(handlingList, maxVelocity, valueColumn )
	local accelerationS = guiGridListGetItemText(handlingList, acceleration, valueColumn )
	local engineInertiaS = guiGridListGetItemText(handlingList, engineInertia, valueColumn )
	local lowerLimitS = guiGridListGetItemText(handlingList, lowerLimit, valueColumn )
	local suspensionBiasS = guiGridListGetItemText(handlingList, suspensionBias, valueColumn )
	local suspensionForceS = guiGridListGetItemText(handlingList, suspensionForce, valueColumn )
	local suspensionDampingS = guiGridListGetItemText(handlingList, suspensionDamping, valueColumn )
	local steeringLockS = guiGridListGetItemText(handlingList, steeringLock, valueColumn )
	local driveTypeS = guiGridListGetItemText(handlingList, driveType, valueColumn )
	local massWeightS = guiGridListGetItemText(handlingList, massWeight, valueColumn )
	local dragCoeffS = guiGridListGetItemText(handlingList, dragCoeff, valueColumn )
	local brakeForceS = guiGridListGetItemText(handlingList, brakeForce, valueColumn )
	local brakeBiasS = guiGridListGetItemText(handlingList, brakeBias, valueColumn )
	local tracMultiplyS = guiGridListGetItemText(handlingList, tracMultiply, valueColumn )
	local tracBiasS = guiGridListGetItemText(handlingList, tracBias, valueColumn )
	
	local massXS = guiGridListGetItemText(handlingList, massX, valueColumn )
	local massYS = guiGridListGetItemText(handlingList, massY, valueColumn )
	local massZS = guiGridListGetItemText(handlingList, massZ, valueColumn )
	local centerOfMass = {}
	table.insert(centerOfMass, 1, massXS)
	table.insert(centerOfMass, 2, massYS)
	table.insert(centerOfMass, 3, massZS)
	-- Limits
	if tonumber(engineInertiaS) < 0.1 or tonumber(engineInertiaS) > 30 then -- Engine Intertia 0.1 - 30
		outputChatBox("Error: A Intertia do Motor deve estar entre 0,1 e 30.", 255, 0, 0)
		playError()
		return
	elseif tonumber(suspensionDampingS) < 0.01 or tonumber(suspensionDampingS) > 0.2 then -- Suspension Damping 0.01 - 0.2
		outputChatBox("Error: Suspensão O amortecimento deve estar entre 0,01 e 0,2.", 255, 0, 0)
		playError()
		return
	end

	playSuccess() -- If continues play success sound.
	triggerServerEvent("handlingSystem:setHandling", getLocalPlayer(), veh, saveToSQL, maxVelocityS, accelerationS, engineInertiaS, lowerLimitS, suspensionBiasS, suspensionForceS, suspensionDampingS, steeringLockS, driveTypeS, massWeightS, dragCoeffS, brakeForceS, brakeBiasS, tracMultiplyS, tracBiasS, centerOfMass)
end

function editHandlingWindow()
	if saveToSQL == 1 or saveToSQL == 0 then
		local width = 200
		local height = 125
		local screenwidth, screenheight = guiGetScreenSize()
		local x = (screenwidth - width)/2
		local y = (screenheight - height)/2
		
		if not (wEdit) then
			sr, sc = guiGridListGetSelectedItem(handlingList)
			name = guiGridListGetItemText(handlingList, sr, sc)
			value = guiGridListGetItemText(handlingList, sr, valueColumn)
			if (source == handlingList) and not (name == "") then
				guiSetInputEnabled(true)
				
				wEdit = guiCreateWindow(x, y, width, height, "Editar manipulação - ".. name .."", false)
				
				newValue = guiCreateEdit(0.03, 0.20, 2.0, 0.3, ""..value.."", true, wEdit)
				
				finishEdit = guiCreateButton(0.6, 0.75, 0.4, 0.2, "Feito", true, wEdit)
				addEventHandler("onClientGUIClick", finishEdit, newHandling)
				
				cancelEdit = guiCreateButton(0.05, 0.75, 0.4, 0.2, "Cancelar", true, wEdit)
				addEventHandler("onClientGUIClick", cancelEdit, cancelHandling)
				
				if name == "Drive Type" then
					info = guiCreateLabel(0.05,0.55,0.9,0.2, "rwd/fwd/awd", true, wEdit)
					guiLabelSetHorizontalAlign(info, "center", true)
				else
					for k, v in pairs(handlingValues) do
						if name == tostring(v[1]) then
							info = guiCreateLabel(0.05,0.55,0.9,0.2, "Min: "..v[2].." Max: "..v[3].."", true, wEdit)
							guiLabelSetHorizontalAlign(info, "center", true)
						end
					end
				end
				addEventHandler("onClientGUIChanged", newValue, checkValues)
			end
		end
	end
end

function closeEditWindow()
	if wEdit and isElement(wEdit) then
		destroyElement(wEdit)
		wEdit = nil
	end
end

function checkValues()
	for k, v in pairs(handlingValues) do
		if name == tostring(v[1]) then
			if string.len(guiGetText(source)) > 0 then
				if tonumber(guiGetText(source)) > v[2] - 0.0001 and tonumber(guiGetText(source)) < v[3] + 0.0001 then
					guiSetEnabled(finishEdit, true)
				else
					guiSetEnabled(finishEdit, false)
				end
			else
				guiSetEnabled(finishEdit, false)
			end
		elseif name == "Drive Type" then
			if tostring(guiGetText(source)) == "rwd" or tostring(guiGetText(source)) == "fwd" or tostring(guiGetText(source)) == "awd" then
				guiSetEnabled(finishEdit, true)
			else
				guiSetEnabled(finishEdit, false)
			end
		end
	end
end

function newHandling()
	if (source==finishEdit) and (newValue) then
		local data = guiGetText(newValue)
		guiGridListSetItemText(handlingList, sr, valueColumn, data, false, false)
		applyHandling(theVehicle, false)
		destroyElement(wEdit)
		wEdit = nil
		guiSetInputEnabled(false)
		showCursor(false)
		playSuccess()
	end
end

function cancelHandling()
	if (source==cancelEdit) then
		guiSetInputEnabled(false)
		destroyElement(wEdit)
		wEdit = nil
		guiSetInputEnabled(false)
		showCursor(false)
	end
end

local GUIEditor_Window = {}
local GUIEditor_Button = {}
local GUIEditor_Label = {}
local driveTestTimer = nil

function showConfirmReloadAllInstances(vehicle_shop_id, vehName)
	closeConfirmReloadAllInstances()
	local width, height = 522,252
	local scrWidth, scrHeight = guiGetScreenSize()
	local x = (scrWidth-width)/2
	local y = (scrHeight-height)/2
	
	GUIEditor_Window["reloadconfirmw"] = guiCreateWindow(x, y, width, height, "Recarregue todas as instâncias de veículos de #"..vehicle_shop_id.."("..vehName..")",false)
	GUIEditor_Label["reloadconfirml"] = guiCreateLabel(0.0383,0.1429,0.931,0.6468,"Você mudou os manuseios para todas as instâncias da loja de veículos ID #"..vehicle_shop_id.."("..vehName.."). \n\nNo entanto, os veículos existentes no jogo antes deste momento não foram afetados até o próximo reinício do sistema do veículo. \n\nVocê quer forçar a recarregar todas as ocorrências de veículos deste modelo?\n\n*Recarregar todas as instâncias do veículo pode causar atraso considerável no servidor, tente evitar o recarregamento de todas as instâncias desnecessariamente usando /reloadveh [id] em vez disso*",true,GUIEditor_Window["reloadconfirmw"])
	guiLabelSetHorizontalAlign(GUIEditor_Label["reloadconfirml"],"left",true)
	GUIEditor_Button["reloadconfirm_ok"] = guiCreateButton(0.0172,0.8294,0.4808,0.127,"Recarregue ALL, eu sei o que estou fazendo",true,GUIEditor_Window["reloadconfirmw"])
	addEventHandler( "onClientGUIClick", GUIEditor_Button["reloadconfirm_ok"],
		function( button )
			if button == "left" then
				triggerServerEvent("vehicle-manager:handling:reloadAllInstancesOf", localPlayer, vehicle_shop_id )
				playSuccess()
				closeConfirmReloadAllInstances()
			end
		end,
	false)
	GUIEditor_Button["reloadconfirml_cancel"] = guiCreateButton(0.4981,0.8294,0.4789,0.127,"Cancelar",true,GUIEditor_Window["reloadconfirmw"])
	addEventHandler( "onClientGUIClick", GUIEditor_Button["reloadconfirml_cancel"],
		function( button )
			if button == "left" then
				closeConfirmReloadAllInstances()
			end
		end,
	false)
end

function closeConfirmReloadAllInstances()
	if GUIEditor_Window["reloadconfirmw"] and isElement(GUIEditor_Window["reloadconfirmw"]) then
		destroyElement(GUIEditor_Window["reloadconfirmw"])
		GUIEditor_Window["reloadconfirmw"] = nil
	end
end

function showDriveTestTimer(veh, driveTestTimeSec, thePed)
	realVeh = veh
	closeCountdownDriveTest()
	local width, height = 314,83
	local scrWidth, scrHeight = guiGetScreenSize()
	local x = scrWidth/2 - (width/2)
	local y = 20
	GUIEditor_Window["drivetest"] = guiCreateWindow(x, y, width, height,"",false)
	guiSetAlpha(GUIEditor_Window["drivetest"],0.80000001192093)
	guiWindowSetMovable(GUIEditor_Window["drivetest"],false)
	guiWindowSetSizable(GUIEditor_Window["drivetest"],false)
	guiSetProperty(GUIEditor_Window["drivetest"],"AlwaysOnTop","true")
	--guiSetProperty(GUIEditor_Window["drivetest"],"TitlebarEnabled","false")
	GUIEditor_Label["second"] = guiCreateLabel(5,22,305,18,"Você tem "..driveTestTimeSec.." segundos antes que este test drive termine.",false,GUIEditor_Window["drivetest"])
	guiLabelSetHorizontalAlign(GUIEditor_Label["second"],"center",false)
	GUIEditor_Button["finish"] = guiCreateButton(15,46,286,26,"TERMINAR",false,GUIEditor_Window["drivetest"])
	addEventHandler( "onClientGUIClick", GUIEditor_Button["finish"], function()
		if source == GUIEditor_Button["finish"] then
			exports.global:fadeToBlack()
			setTimer(function ()
				closeCountdownDriveTest()
				triggerServerEvent("vehicle-manager:handling:finishTestDrive", localPlayer, veh, thePed )
			end, 1000, 1)
			playSuccess()
			
			setTimer(function ()
				exports.global:fadeFromBlack(source)
			end, 3000, 1)
		end
	end)
	if thePed then
		guiSetSize(GUIEditor_Window["drivetest"], width, height+28, false)
		GUIEditor_Button["orderfinish"] = guiCreateButton(15,46+28,286,26,"ENCOMENDAR & TERMINAR",false,GUIEditor_Window["drivetest"])
		addEventHandler( "onClientGUIClick", GUIEditor_Button["orderfinish"], function()
			if source == GUIEditor_Button["orderfinish"] then
				exports.global:fadeToBlack()
				setTimer(function ()
					closeCountdownDriveTest()
					triggerServerEvent("vehicle-manager:handling:finishTestDrive", localPlayer, veh, thePed, true )
				end, 1000, 1)
				playSuccess()
				
				setTimer(function ()
					exports.global:fadeFromBlack(source)
				end, 3000, 1)
			end
		end)
	end
	countdownDriveTest(driveTestTimeSec)
	setTimer(function()
		exports.global:fadeFromBlack()
	end, 1000, 1)
end
addEvent("veh-manager:handling:testdrivetimerGUI", true)
addEventHandler("veh-manager:handling:testdrivetimerGUI",localPlayer, showDriveTestTimer)



function countdownDriveTest(driveTestTimeSec)
	if isElement(GUIEditor_Label["second"]) then
		driveTestTimer = setTimer(function()
			driveTestTimeSec = driveTestTimeSec - 1
			guiSetText(GUIEditor_Label["second"], "Você tem "..driveTestTimeSec.." segundos antes que este test drive termine.")
			if driveTestTimeSec <= 0 then
				closeCountdownDriveTest()
			end
		end, 1000, 0)
	end
end


function closeCountdownDriveTest()
	if GUIEditor_Window["drivetest"] and isElement(GUIEditor_Window["drivetest"]) then
		
		destroyElement(GUIEditor_Window["drivetest"])
		GUIEditor_Window["drivetest"] = nil
		
	end
	killDriveTestTimer()
	closeHandlingWindows()
	realVeh = nil
end

function killDriveTestTimer()
	if isTimer(driveTestTimer) then
		killTimer(driveTestTimer)
	end
end

function start_cl_resource()
	exports.global:fadeFromBlack()
end
addEventHandler("onClientResourceStart",getResourceRootElement(getThisResource()),start_cl_resource)

function killTestDrive()
	if realVeh then
		closeCountdownDriveTest()
		triggerServerEvent("vehicle-manager:handling:finishTestDrive", localPlayer, realVeh, thePed, false, true )
	end
end
-- changing chars should kill dis
addEventHandler('onClientChangeChar', root, killTestDrive)
addEventHandler('onClientPlayerChangeNick', localPlayer, killTestDrive)
