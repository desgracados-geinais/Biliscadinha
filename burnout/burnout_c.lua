-- infernus and jester
vehiclesList = { 
			
				602, 496, 401, 518, 527, 589, 419, 533, 526, 
				474, 545, 517, 410, 600, 436, 580, 439, 549, 
				491, 445, 604, 507, 585, 587, 466, 492, 546, 
				551, 516, 467, 426, 547, 405, 409, 550, 566, 
				540, 421, 529, 431, 438, 420, 525, 408, 416, 
				433, 427, 490, 528, 407, 544, 523, 470, 598, 
				596, 597, 599, 601, 428, 499, 609, 498, 524,
				578, 455, 588, 403, 514, 423, 414, 443, 515,
				531, 456, 459, 422, 482, 605, 418, 572, 582, 
				413, 440, 543, 583, 478, 554, 536, 575, 534, 
				567, 535, 576, 412, 402, 542, 603, 475, 568, 
				424, 504, 843, 508, 500, 429, 541, 415, 480, 
				562, 565, 434, 494, 502, 503, 411, 559, 561, 
				560, 506, 451, 558, 555, 477, 579, 400, 404, 
				489, 505, 479, 442, 458 
			}

-- could be "cars", "list" or any other value
-- "cars" will make burout work only for cars, not bikes/boats/planes
-- list - will use vehiclesList
-- any value will allow any vehicle to use burnout
restrictionMode = 'cars'

imCool = false




--------------------------------------------------------------------------------------





--[[

DO NOT TOUCH ANYTHING BELOW THIS !!!!

--]]


function in_array(e, t)
	for _,v in pairs(t) do
		if (v==e) then return true end
	end
	return false
end


localPlayer = getLocalPlayer()

pressingUp = false
pressingDown = false
isEventHandler = false
isBurnoutDecreasing = false
isBurnoutIncreasing = false
isPopDecreasing = false
isPopIncreasing = false
isSpeedEffect = false
burnPoints = 0
popPoints = 0
multiplier = 0.01

alpha=0

color = tocolor(255,255,0,alpha)

width, height = guiGetScreenSize()


function allowed(veh)
	local allow = false
	if restrictionMode=='cars' then
		if getVehicleType(veh) == 'Automobile' then
			allow = true
		end
	elseif (restrictionMode=='list') then
		if in_array(getElementModel(veh), vehiclesList) then
			allow = true
		end
	else
		allow = true
	end
	return allow
end


function startAcc()
	local veh = getPedOccupiedVehicle(localPlayer)
	if (veh and getVehicleOccupant(veh, 0)==localPlayer and isVehicleOnGround(veh)) then
		local allow = allowed(veh)
		if (allow) then
			pressingUp=true
			startStopHandler()
		end
	end
end
function stopAcc()
	pressingUp=false
	startStopHandler()
end
function startRev()
local veh = getPedOccupiedVehicle(localPlayer)
	if (veh and getVehicleOccupant(veh, 0)==localPlayer and isVehicleOnGround(veh)) then
		pressingDown=true
		startStopHandler()
	end
end
function stopRev()
	pressingDown=false
	startStopHandler()
end

function speedMe()
	local veh = getPedOccupiedVehicle(localPlayer)
	if (pressingUp and veh and getVehicleOccupant(veh, 0)==localPlayer and isVehicleOnGround(veh)) then
		local xx,yy,zz = getElementVelocity(veh)
		local speed = math.floor(getActualVelocity(veh, getElementVelocity(veh))*100*1.61)
		local speedMulti = 0
		if (speed>7 and speed<20) then
			speedMulti = 1.2
		elseif (speed>20 and speed<40) then
			speedMulti = 1.18
		elseif (speed>40 and speed<60) then
			speedMulti = 1.15
		elseif (speed>60 and speed<80) then
			speedMulti = 1.12
		elseif (speed>80 and speed<100) then
			speedMulti = 1.09
		elseif (speed>100 and speed<120) then
			speedMulti = 1.04
		else
			speedMulti = 1.02
		end
		if (speed>0 and speed < 250) then
			imCool = true
			--setElementVelocity(veh, xx*speedMulti, yy*speedMulti, zz*speedMulti)
		end
	end
end

function startSpeedEffect()
	if (not isSpeedEffect) then
		addEventHandler("onClientRender", getRootElement(), speedMe)
	end
	isSpeedEffect = true
	setTimer(function()
		if (isSpeedEffect) then
			isSpeedEffect = false
			removeEventHandler("onClientRender", getRootElement(), speedMe)
		end
	end, 3000, 1)
end

function decreaseBurnout()
	if burnPoints > 0 then
		burnPoints = burnPoints - multiplier*4
		if (burnPoints <= 0) then
			burnPoints = 0 -- to be sure
			color = tocolor(255, 255, 0, alpha)
			removeEventHandler("onClientRender", getRootElement(), decreaseBurnout)
			isBurnoutDecreasing = false	
		end
	else
		color = tocolor(255, 255, 0, alpha)
		removeEventHandler("onClientRender", getRootElement(), decreaseBurnout)
		isBurnoutDecreasing = false	
	end
end

function decreasePop()
	if popPoints > 0 then
		popPoints = popPoints - multiplier*5
		if (popPoints <= 0) then
			popPoints = 0
			removeEventHandler("onClientRender", getRootElement(), decreasePop)
			isPopDecreasing = false
		end
	else
		removeEventHandler("onClientRender", getRootElement(), decreasePop)
		isPopDecreasing = false
	end
end

function increaseBurnout()
	if burnPoints < 1 then
		burnPoints = burnPoints + multiplier
		if (burnPoints >= 1) then
			burnPoints = 1 -- to be sure
			color = tocolor(255, 0, 0, 255)
			removeEventHandler("onClientRender", getRootElement(), increaseBurnout)
			isBurnoutIncreasing = false
		end
	else
		color = tocolor(255, 0, 0, 255)
		removeEventHandler("onClientRender", getRootElement(), increaseBurnout)
		isBurnoutIncreasing = false
	end
end

function increasePop()
	popPoints = popPoints + multiplier
	if popPoints >= 2 then
		local number = math.random(1,1000)
		if number < 20 then
			popRandomTire()
		end
	end
end

function popRandomTire()
	local veh = getPedOccupiedVehicle(localPlayer)
	if (veh) then
		local x1,x2,x3,x4 = getVehicleWheelStates(veh)
		local clean = { }
		if (x2==0) then table.insert(clean,"x3") end
		if (x4==0) then table.insert(clean,"x4") end
		local cleanCount = #clean
		if (cleanCount==0) then
			local y1,y2,y3,y4 = getVehicleWheelStates(veh)
			local notRemoved = { }
			if (y2~=2) then table.insert(notRemoved,"x3") end
			if (y4~=2) then table.insert(notRemoved,"x4") end
			local notRemovedCount = #notRemoved
			if (notRemovedCount==2 or 4) then
				setTimer(function()
					local tire = math.random(notRemovedCount)
					local tireToRemove = notRemoved[tire]
					if (tireToRemove=="x3") then
						setVehicleWheelStates(veh, -1, 2)
					elseif (tireToRemove=="x4") then
						setVehicleWheelStates(veh, -1, -1, -1, 2)
					end
				end, 3000, 1)	
			end
		else
			local tire = math.random(cleanCount)
			local tireToPop = clean[tire]
			if (tireToPop=="x3") then
				setVehicleWheelStates(veh, -1, 1)
			elseif (tireToPop=="x4") then
				setVehicleWheelStates(veh, -1, -1, -1, 1)
			end
		end
	end
end

function startBurnout()
	if (isBurnoutDecreasing) then
		removeEventHandler("onClientRender", getRootElement(), decreaseBurnout)
		isBurnoutDecreasing = false
	end
	if (not isBurnoutIncreasing) then
		addEventHandler("onClientRender", getRootElement(), increaseBurnout)
		isBurnoutIncreasing = true
	end
	if (isPopDecreasing) then
		removeEventHandler("onClientRender", getRootElement(), decreasePop)
		isPopDecreasing = false
	end
	if (not isPopIncreasing) then
		addEventHandler("onClientRender", getRootElement(), increasePop)
		isPopIncreasing = true
	end
end

function stopBurnout()
	if (burnPoints >= 1) then
		startSpeedEffect()
	end
	if (isBurnoutIncreasing) then
		removeEventHandler("onClientRender", getRootElement(), increaseBurnout)
		isBurnoutIncreasing = false
	end
	if (not isBurnoutDecreasing) then
		addEventHandler("onClientRender", getRootElement(), decreaseBurnout)
		isBurnoutDecreasing = true
	end
	if (isPopIncreasing) then
		removeEventHandler("onClientRender", getRootElement(), increasePop)
		isPopIncreasing = false
	end
	if (not isPopDecreasing) then
		addEventHandler("onClientRender", getRootElement(), decreasePop)
		isPopDecreasing = true
	end
	
end

function burnGain()
	local veh = getPedOccupiedVehicle(localPlayer)
	if veh then
		local speed = math.floor(getActualVelocity(veh, getElementVelocity(veh))*100)
		if (speed <= 3) then
			startBurnout()
		else
			stopBurnout()
		end
	end
end

function startStopHandler()
	if (pressingUp and pressingDown) then
		if not isEventHandler then
			addEventHandler("onClientRender", getRootElement(), burnGain)
			isEventHandler = true
		end
	else
		if isEventHandler then
			stopBurnout()
			removeEventHandler("onClientRender", getRootElement(), burnGain)
			isEventHandler = false
		end
	end
end

function fireUp(howMuch)
	local keys = getBoundKeys ('accelerate')
	if keys then
		for keyName, state in pairs(keys) do
			bindKey(keyName, "down", startAcc)
			bindKey(keyName, "up", stopAcc)
		end
	end
	
	local keys = getBoundKeys ('brake_reverse')
	if keys then
		for keyName, state in pairs(keys) do
			bindKey(keyName, "down", startRev)
			bindKey(keyName, "up", stopRev)
		end
	end
end


function getActualVelocity( element, x, y, z )
	return (x^2 + y^2 + z^2) ^ 0.5
end

function round2(num, idp)
	return tonumber(string.format("%." .. (idp or 0) .. "f", num))
end

function showPanel()
	--[[dxDrawText("burnout", width-18, height-150, width-18, 0, tocolor(255,255,0,alpha), 1, "pricedown", "right", "top")
	if (alpha>180) then tmpAlpha = 180 else tmpAlpha=alpha end
	dxDrawRectangle(width-115, height-120, 102, 10, tocolor(0,0,0,tmpAlpha), false)
	dxDrawRectangle(width-115+1, height-120+1, round2(burnPoints,2)*100, 8, color, false)]]
end

addEventHandler("onClientRender", getRootElement(), showPanel)


function enterCar(veh, seat)
	if (seat==0) then
		local allow = false
		
		allow=allowed(veh)
		
		if (allow) then
			if (isTimer(alpTimer)) then killTimer(alpTimer) end
			alpTimer = setTimer(function()
				if (alpha >= 255) then
					alpha = 255
					killTimer(alpTimer)
				else
					alpha = alpha+15
				end
			end, 50)
		end
	end
end

function leaveCar(veh, seat)
	if (isTimer(alpTimer)) then killTimer(alpTimer) end
	alpTimer = setTimer(function()
		if (alpha <= 0) then
			alpha = 0
			killTimer(alpTimer)
		else
			alpha = alpha-15
		end
	end, 50)
end


addEventHandler("onClientPlayerVehicleEnter", localPlayer, enterCar)
addEventHandler("onClientPlayerVehicleExit", localPlayer, leaveCar)


fireUp()