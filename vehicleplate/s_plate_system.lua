--Warning, not sure who originally made this but it's very noobish and messy. If you're about to modify this, better remake a new one :< / maxime
local mysql = exports.mysql
local serverRegFee = 2000

function getPlateList()
	local allVehicles = getElementsByType("vehicle")
	local vehicleTable = { }
	local playerDBID = getElementData(client,"dbid")
	if not playerDBID then
		return
	end
	for _,vehicleElement in ipairs( exports.pool:getPoolElementsByType("vehicle") ) do
		if (getElementData(vehicleElement, "owner")) and (tonumber(getElementData(vehicleElement, "owner")) == tonumber(playerDBID)) and exports['vehicle-system']:hasVehiclePlates(vehicleElement) then
			local vehicleID = getElementData(vehicleElement, "dbid")
			table.insert(vehicleTable, { vehicleID, vehicleElement } )
		end
	end
	triggerClientEvent(client, "vehicle-plate-system:clist", client, vehicleTable)
end
addEvent("vehicle-plate-system:list", true)
addEventHandler("vehicle-plate-system:list", getRootElement(), getPlateList)

function getRegisterList()
	local allVehicles = getElementsByType("vehicle")
	local vehicleTable = { }
	local playerDBID = getElementData(client,"dbid")
	if not playerDBID then
		return
	end
	for _,vehicleElement in ipairs( exports.pool:getPoolElementsByType("vehicle") ) do
		if (getElementData(vehicleElement, "owner")) and (tonumber(getElementData(vehicleElement, "owner")) == tonumber(playerDBID)) and exports['vehicle-system']:hasVehiclePlates(vehicleElement) then
			local vehicleID = getElementData(vehicleElement, "dbid")
			table.insert(vehicleTable, { vehicleID, vehicleElement } )
		end
	end
	triggerClientEvent(client, "vehicle-plate-system:rlist", client, vehicleTable)
end
addEvent("vehicle-plate-system:registerlist", true)
addEventHandler("vehicle-plate-system:registerlist", getRootElement(), getRegisterList)

function pedTalk(state)
	if (state == 1) then
		--exports.global:sendLocalText(source, "Gabrielle McCoy says: Welcome! Would you be unregistering, registering or changing your vehice plates today?", 255, 255, 255, 10)
		--outputChatBox("The fee is $".. exports.global:formatMoney(serverRegFee) .. " per vehicle.", source, 200, 200, 200)
	elseif (state == 2) then
		--exports.global:sendLocalText(source, "[English] Gabrielle McCoy says: Sorry but the fee to register new plates is $" .. exports.global:formatMoney(serverRegFee) .. ". Please come back once you have the money.", 255, 255, 255, 10)
		outputChatBox(source, "Você não tem GCs para ativar este recurso.", 255,0,0)
	elseif (state == 3) then
		--exports.global:sendLocalText(source, "[English] Gabrielle McCoy says: That is great! Lets get everything set up for you in our system.", 255, 255, 255, 10)
	elseif (state == 4) then
		exports.global:sendLocalText(source, "[Português] Gabrielle McCoy diz: Não? Bem, eu espero que você mude de idéia mais tarde. Tenha um bom dia!", 255, 255, 255, 10)
	elseif (state == 5) then
		exports.global:sendLocalText(source, " * Gabrielle McCoy começa a inserir as informações em seu computador.", 255, 51, 102)
		exports.global:sendLocalText(source, "[Português]Gabrielle McCoy diz: Tudo bem, você deveria estar pronto para ir. Tenha um bom dia!", 255, 255, 255, 10)
	elseif (state == 6) then
		exports.global:sendLocalText(source, "[Português] Gabrielle McCoy diz: Hmmm. De acordo com nossos registros, isso já é uma placa registrada.", 255, 255, 255, 10)
	elseif (state == 7) then
		exports.global:sendLocalText(source, "[Português] Gabrielle McCoy diz: Bem, me desculpe, mas seu veículo não exige uma placa ou documentos registrados.", 255, 255, 255, 10)
	elseif (state == 8) then
		exports.global:sendLocalText(source, "[Português] Gabrielle McCoy diz: Me desculpe, mas você é o dono deste veículo nos jornais?", 255, 255, 255, 10)
	end
end
addEvent("platePedTalk", true)
addEventHandler("platePedTalk", getRootElement(), pedTalk)

function setNewInfo(data, car)
	if not (data) or not (car) then
		outputChatBox("Erro interno", source, 255,0,0)
		return false
	end

	local tvehicle = exports.pool:getElement("vehicle", car)
	if not exports['vehicle-system']:hasVehiclePlates(tvehicle) then
		triggerEvent("platePedTalk", source, 7)
		return false
	end

	if getElementData(source, "dbid") ~= getElementData(tvehicle, "owner") then
		triggerEvent("platePedTalk", source, 8)
		return false
	end

	local cquery = mysql:query_fetch_assoc("SELECT COUNT(*) as no FROM `vehicles` WHERE `plate`='".. mysql:escape_string(data).."'")
	if (tonumber(cquery["no"]) > 0) then
		triggerEvent("platePedTalk", source, 6)
		return false
	end

	local accountID = getElementData(source, "account:id")
	local credits = mysql:query_fetch_assoc("SELECT `credits` FROM `accounts` WHERE `id`='".. mysql:escape_string(accountID).."'")
	credits = tonumber(credits["credits"])
	if credits < 2 then
		triggerEvent("platePedTalk", source, 2)
		return false
	end

	mysql:query_free("UPDATE `accounts` SET `credits`=`credits`-2 WHERE `id`='"..accountID.."' ")
	mysql:query_free("UPDATE `vehicles` SET `plate`='" .. mysql:escape_string(data) .. "' WHERE `id` = '" .. mysql:escape_string(car) .. "'")

	exports.anticheat:changeProtectedElementDataEx(tvehicle, "plate", data, true)
	--exports.anticheat:changeProtectedElementDataEx(tvehicle, "show_plate", 1, true)
	setVehiclePlateText(tvehicle, data )

	triggerEvent("platePedTalk", source, 5)
end
addEvent("sNewPlates", true)
addEventHandler("sNewPlates", getRootElement(), setNewInfo)

function setNewReg(car)
	if not (car) then
		return false
	end

	local tvehicle = exports.pool:getElement("vehicle", car)
	if getElementData(source, "dbid") ~= getElementData(tvehicle, "owner") then
		triggerEvent("platePedTalk", source, 8)
		return false
	end
	
	if not exports['vehicle-system']:hasVehiclePlates(tvehicle) then
		triggerEvent("platePedTalk", source, 7)
		return false
	end

	if getElementData(tvehicle, "registered") == 0 then
		data = 1
	else
		data = 0
	end

	if not exports.global:takeMoney(source, data == 1 and 175 or 50) then
		exports.global:sendLocalText(source, "[English] Gabrielle McCoy says: Could I have $"..(data == 1 and 175 or 50).." please?", 255, 255, 255, 10)
	end

	exports.anticheat:changeProtectedElementDataEx(tvehicle, "registered", data, true)
	mysql:query_free("UPDATE vehicles SET registered='"..(data).."' WHERE id = '" .. mysql:escape_string(car) .. "'")
	triggerEvent("platePedTalk", source, 5)
end
addEvent("sNewReg", true)
addEventHandler("sNewReg", getRootElement(), setNewReg)

function givePaperToSellVehicle(thePlayer)
	source = thePlayer
	exports.global:takeMoney(thePlayer, 100)
	exports.global:giveItem(thePlayer, 173, 1)
end
addEvent("givePaperToSellVehicle", true)
addEventHandler("givePaperToSellVehicle", getResourceRootElement(), givePaperToSellVehicle)