local GUIEditor_Window = {}
local GUIEditor_Edit = {}
local GUIEditor_Label = {}
local GUIEditor_Button = {}
local GUIEditor_Memo = {}
local GUIEditor_Combo = {}

function openEditVehicleWindow(data)
	closeEditVehicleWindow()
	local existed = true
	if not data or not data.id then
		existed = false
	end
	
	local theVehicle = getPedOccupiedVehicle(localPlayer) or false
	if not theVehicle then
		outputChatBox( "Você deve estar em um veículo.", 255, 194, 14)
		return false
	end
	--outputDebugString(data.id)
	local vehdbid = getElementData(theVehicle, "dbid")
	if not vehdbid or vehdbid <=0 or (existed and tonumber(data.id) ~= vehdbid) then
		outputChatBox( "Este veículo não pode ter propriedades personalizadas.", 255, 194, 14)
		return false
	end
	
	guiSetInputEnabled(true)
	showCursor(true)
	
	local model = getElementModel(theVehicle)
	local name = getVehicleNameFromModel(model)
	
	local width, height = 438,392
	local screenwidth, screenheight = guiGetScreenSize()
	local x = (screenwidth - width)/2
	local y = (screenheight - height)/2
	
	GUIEditor_Window["uniqueVehWindow"] = guiCreateWindow(x, y, width, height,(existed and "Atualizar informações exclusivas do veículo - Veículo ID#"..vehdbid or "Criar informações exclusivas de veículo - veículo ID#"..vehdbid),false)
	GUIEditor_Label[1] = guiCreateLabel(0.0251,0.0867,0.4292,0.0459,"Modelo de veículo do MTA (nome ou ID):",true,GUIEditor_Window["uniqueVehWindow"])
	guiSetFont(GUIEditor_Label[1],"default-bold-small")
	GUIEditor_Edit[1] = guiCreateEdit(0.0388,0.1327,0.4155,0.0791,(model),true,GUIEditor_Window["uniqueVehWindow"])
	guiSetEnabled(GUIEditor_Edit[1], false)
	GUIEditor_Label[2] = guiCreateLabel(0.0251,0.2372,0.4292,0.0459,"Marca:",true,GUIEditor_Window["uniqueVehWindow"])
	guiSetFont(GUIEditor_Label[2],"default-bold-small")
	GUIEditor_Edit[2] = guiCreateEdit(0.0388,0.2832,0.4155,0.0791,(getElementData(theVehicle, "brand") or name),true,GUIEditor_Window["uniqueVehWindow"])
	
	GUIEditor_Label[3] = guiCreateLabel(0.0251,0.3878,0.4292,0.0459,"Modelo:",true,GUIEditor_Window["uniqueVehWindow"])
	guiSetFont(GUIEditor_Label[3],"default-bold-small")
	GUIEditor_Edit[3] = guiCreateEdit(0.0388,0.4337,0.4155,0.0791,(getElementData(theVehicle, "maximemodel") or ""),true,GUIEditor_Window["uniqueVehWindow"])
	
	GUIEditor_Label[4] = guiCreateLabel(0.516,0.0867,0.4292,0.0459,"Ano:",true,GUIEditor_Window["uniqueVehWindow"])
	guiSetFont(GUIEditor_Label[4],"default-bold-small")
	GUIEditor_Edit[4] = guiCreateEdit(0.5411,0.1327,0.4155,0.0791,(getElementData(theVehicle, "year") or ""),true,GUIEditor_Window["uniqueVehWindow"])
	
	GUIEditor_Label[5] = guiCreateLabel(0.516,0.2372,0.4292,0.0459,"Preço:",true,GUIEditor_Window["uniqueVehWindow"])
	guiSetFont(GUIEditor_Label[5],"default-bold-small")
	GUIEditor_Edit[5] = guiCreateEdit(0.5388,0.2832,0.4178,0.0791,(existed and data.price or "0"),true,GUIEditor_Window["uniqueVehWindow"])
	
	GUIEditor_Label[6] = guiCreateLabel(0.516,0.3878,0.15,0.0459,"Taxa:",true,GUIEditor_Window["uniqueVehWindow"])
	guiSetFont(GUIEditor_Label[6],"default-bold-small")
	GUIEditor_Edit[6] = guiCreateEdit(0.5434,0.4337,0.15,0.0791,(existed and data.tax or "0"),true,GUIEditor_Window["uniqueVehWindow"])
	
	GUIEditor_Label[7] = guiCreateLabel(0.0251,0.5383,0.4292,0.0459,"Nota(s):",true,GUIEditor_Window["uniqueVehWindow"])
	guiSetFont(GUIEditor_Label[7],"default-bold-small")
	GUIEditor_Memo[1] = guiCreateMemo(0.0388,0.6224,0.9178,0.199,(existed and data.notes or ""),true,GUIEditor_Window["uniqueVehWindow"])

	GUIEditor_Label["doortype"] = guiCreateLabel(0.716,0.3878,0.4292,0.0459,"Portas:",true,GUIEditor_Window["uniqueVehWindow"])
	guiSetFont(GUIEditor_Label["doortype"],"default-bold-small")

	GUIEditor_Combo["doortype"] = guiCreateComboBox(0.736,0.4337,0.21,0.0459, "Padrão", true, GUIEditor_Window["uniqueVehWindow"])
	guiComboBoxAdjustHeight(GUIEditor_Combo["doortype"], 3)
	guiComboBoxAddItem(GUIEditor_Combo["doortype"], "Default")
	guiComboBoxAddItem(GUIEditor_Combo["doortype"], "Scissor")
	guiComboBoxAddItem(GUIEditor_Combo["doortype"], "Butterfly")
	guiComboBoxSetSelected(GUIEditor_Combo["doortype"], getElementData(theVehicle, "vDoorType") or 0 )

	
	GUIEditor_Button[1] = guiCreateButton(0.0388,0.8622,0.2275,0.0944,"Cancelar",true,GUIEditor_Window["uniqueVehWindow"])
	guiSetFont(GUIEditor_Button[1],"default-bold-small")
	addEventHandler( "onClientGUIClick", GUIEditor_Button[1],
		function( button )
			if button == "left" then
				closeEditVehicleWindow()
			end
		end,
	false)
	
	GUIEditor_Button[3] = guiCreateButton(0.2588+0.013,0.8622,0.2275,0.0944,"Resetar",true,GUIEditor_Window["uniqueVehWindow"])
	guiSetFont(GUIEditor_Button[3],"default-bold-small")
	addEventHandler( "onClientGUIClick", GUIEditor_Button[3],
		function( button )
			if button == "left" then
				showResetConfirm(vehdbid )
			end
		end,
	false)
	guiSetEnabled(GUIEditor_Button[3], false)
	
	GUIEditor_Button[4] = guiCreateButton(0.4788+0.025,0.8622,0.2275,0.0944,"Manuseio Exclusivo",true,GUIEditor_Window["uniqueVehWindow"])
	guiSetFont(GUIEditor_Button[4],"default-bold-small")
	addEventHandler( "onClientGUIClick", GUIEditor_Button[4],
		function( button )
			if button == "left" then
				triggerServerEvent("vehlib:handling:openUniqueHandling", localPlayer, vehdbid, existed)
				closeEditVehicleWindow()
			end
		end,
	false)
	guiSetEnabled(GUIEditor_Button[4], false)
	
	GUIEditor_Button[2] = guiCreateButton(0.736,0.8622,0.2206,0.0944,"Salvar",true,GUIEditor_Window["uniqueVehWindow"])
	guiSetFont(GUIEditor_Button[2],"default-bold-small")
	addEventHandler( "onClientGUIClick", GUIEditor_Button[2],
		function( button )
			if button == "left" then
				local veh = {}
				veh.mtaModel = guiGetText(GUIEditor_Edit[1])
				if not tonumber(veh.mtaModel) then
					veh.mtaModel = getVehicleModelFromName(veh.mtaModel)
				end
				veh.brand = guiGetText(GUIEditor_Edit[2])
				veh.model = guiGetText(GUIEditor_Edit[3])
				veh.year = guiGetText(GUIEditor_Edit[4])
				veh.price = guiGetText(GUIEditor_Edit[5])
				veh.tax = guiGetText(GUIEditor_Edit[6])
				veh.note = guiGetText(GUIEditor_Memo[1])
				veh.id = vehdbid

				local item =  guiComboBoxGetSelected ( GUIEditor_Combo["doortype"] )
				veh.doortype = item == -1 and 0 or item

				showSaveConfirm(vehdbid, existed, veh )
			end
		end,
	false)
	guiSetEnabled(GUIEditor_Button[2], false)
	
	if exports.integration:isPlayerVehicleConsultant(localPlayer) or exports.integration:isPlayerAdmin(localPlayer) then
		guiSetEnabled(GUIEditor_Button[2], true) -- SAVE
		if existed then
			guiSetEnabled(GUIEditor_Button[4], true) -- HANDLINGS
			guiSetEnabled(GUIEditor_Button[3], true) -- RESET
		end
	elseif exports.integration:isPlayerVCTMember(localPlayer) then
		if existed then
			guiSetEnabled(GUIEditor_Button[4], true) -- HANDLINGS
			guiSetEnabled(GUIEditor_Button[3], true) -- RESET
		end
	end
end
addEvent("vehlib:handling:editVehicle", true)
addEventHandler("vehlib:handling:editVehicle",getLocalPlayer(), openEditVehicleWindow)

function closeEditVehicleWindow()
	if GUIEditor_Window["uniqueVehWindow"] and isElement(GUIEditor_Window["uniqueVehWindow"]) then
		destroyElement(GUIEditor_Window["uniqueVehWindow"])
		GUIEditor_Window["uniqueVehWindow"] = nil
		guiSetInputEnabled(false)
		showCursor(false)
	end
	closeSaveConf()
	closeResetConfirm()
end

function showSaveConfirm(vehdbid, existed, veh )
	closeSaveConf()
	local width, height = 522,252
	local scrWidth, scrHeight = guiGetScreenSize()
	local x = (scrWidth-width)/2
	local y = (scrHeight-height)/2
	
	GUIEditor_Window["saveconfirmw"] = guiCreateWindow(x, y, width, height, "Veículo Único - Veículo ID#"..vehdbid,false)
	GUIEditor_Label["saveconfirml"] = guiCreateLabel(0.0383,0.1429,0.931,0.6468,"Você está prestes a "..(existed and "update" or "create").." um registro único no veículo ID #"..vehdbid.."\n\nUma vez que o veículo único é criado, qualquer alteração que você fizer na biblioteca do veículo no futuro não afetará mais este veículo.\n\n*Por favor, considere cuidadosamente*",true,GUIEditor_Window["saveconfirmw"])
	guiLabelSetHorizontalAlign(GUIEditor_Label["saveconfirml"],"left",true)
	GUIEditor_Button["saveconf_ok"] = guiCreateButton(0.0172,0.8294,0.4808,0.127,(existed and "Save" or "Create")..", Eu sei o que estou fazendo",true,GUIEditor_Window["saveconfirmw"])
	addEventHandler( "onClientGUIClick", GUIEditor_Button["saveconf_ok"],
		function( button )
			if button == "left" then
				triggerServerEvent("vehlib:handling:createUniqueVehicle", localPlayer, veh, existed)
				playSuccess()
				closeEditVehicleWindow()
			end
		end,
	false)
	GUIEditor_Button["saveconf_cancel"] = guiCreateButton(0.4981,0.8294,0.4789,0.127,"Cancelar",true,GUIEditor_Window["saveconfirmw"])
	addEventHandler( "onClientGUIClick", GUIEditor_Button["saveconf_cancel"],
		function( button )
			if button == "left" then
				closeSaveConf()
			end
		end,
	false)
end

function closeSaveConf()
	if GUIEditor_Window["saveconfirmw"] and isElement(GUIEditor_Window["saveconfirmw"]) then
		destroyElement(GUIEditor_Window["saveconfirmw"])
		GUIEditor_Window["saveconfirmw"] = nil
	end
end

function showResetConfirm(vehdbid )
	closeResetConfirm()
	local width, height = 522,252
	local scrWidth, scrHeight = guiGetScreenSize()
	local x = (scrWidth-width)/2
	local y = (scrHeight-height)/2
	
	GUIEditor_Window["resetconfw"] = guiCreateWindow(x, y, width, height, "Remover veículo único - veículo ID#"..vehdbid,false)
	GUIEditor_Label["resetconfl"] = guiCreateLabel(0.0383,0.1429,0.931,0.6468,"Você está prestes a remover um registro exclusivo no Veículo ID #"..vehdbid.."\n\nUma vez que o veículo único é removido, este veículo herdará estatísticas (movimentos incluídos) de seu modelo na biblioteca do veículo.",true,GUIEditor_Window["resetconfw"])
	guiLabelSetHorizontalAlign(GUIEditor_Label["resetconfl"],"left",true)
	GUIEditor_Button["resetconf_ok"] = guiCreateButton(0.0172,0.8294,0.4808,0.127,"Redefinir agora",true,GUIEditor_Window["resetconfw"])
	addEventHandler( "onClientGUIClick", GUIEditor_Button["resetconf_ok"],
		function( button )
			if button == "left" then
				triggerServerEvent("vehlib:handling:resetUniqueVehicle", localPlayer, vehdbid)
				playSuccess()
				closeEditVehicleWindow()
			end
		end,
	false)
	
	
	GUIEditor_Button["resetconf_cancel"] = guiCreateButton(0.4981,0.8294,0.4789,0.127,"Cancelar",true,GUIEditor_Window["resetconfw"])
	addEventHandler( "onClientGUIClick", GUIEditor_Button["resetconf_cancel"],
		function( button )
			if button == "left" then
				closeResetConfirm()
			end
		end,
	false)
end

function closeResetConfirm()
	if GUIEditor_Window["resetconfw"] and isElement(GUIEditor_Window["resetconfw"]) then
		destroyElement(GUIEditor_Window["resetconfw"])
		GUIEditor_Window["resetconfw"] = nil
	end
end

--HANDLINGS
function showConfirmSaveUniqueHandling(veh, mode)
	closeConfirmSaveUniqueHandling()
	
	local dbid = getElementData(veh, "dbid")
	if not dbid then
		return false
	end
	local width, height = 522,252
	local scrWidth, scrHeight = guiGetScreenSize()
	local x = (scrWidth-width)/2
	local y = (scrHeight-height)/2
	
	GUIEditor_Window["saveuniconfw"] = guiCreateWindow(x, y, width, height, "Salvar veículo único - veículo ID#"..dbid,false)
	GUIEditor_Label["saveuniconfl"] = guiCreateLabel(0.0383,0.1429,0.931,0.6468,"Você está prestes a salvar um registro de tratamento exclusivo no Veículo ID #"..dbid.."\n\nUma vez que o manuseio exclusivo é salvo, este veículo NÃO herdará mais os manuseios de seu modelo na biblioteca do veículo.",true,GUIEditor_Window["saveuniconfw"])
	guiLabelSetHorizontalAlign(GUIEditor_Label["saveuniconfl"],"left",true)
	GUIEditor_Button["bsaveuniconf_ok"] = guiCreateButton(0.0172,0.8294,0.4808,0.127,"Salve, eu sei o que estou fazendo",true,GUIEditor_Window["saveuniconfw"])
	addEventHandler( "onClientGUIClick", GUIEditor_Button["bsaveuniconf_ok"],
		function( button )
			if button == "left" then
				applyHandling(veh, mode)
				playSuccess()
				closeConfirmSaveUniqueHandling()
			end
		end,
	false)
	
	
	GUIEditor_Button["bsaveuniconf_can"] = guiCreateButton(0.4981,0.8294,0.4789,0.127,"Cancelar",true,GUIEditor_Window["saveuniconfw"])
	addEventHandler( "onClientGUIClick", GUIEditor_Button["bsaveuniconf_can"],
		function( button )
			if button == "left" then
				closeConfirmSaveUniqueHandling()
			end
		end,
	false)
end

function closeConfirmSaveUniqueHandling()
	if GUIEditor_Window["saveuniconfw"] and isElement(GUIEditor_Window["saveuniconfw"]) then
		destroyElement(GUIEditor_Window["saveuniconfw"])
		GUIEditor_Window["saveuniconfw"] = nil
	end
end