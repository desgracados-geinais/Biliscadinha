-- Set a train (de)railed
addCommandHandler("settrainrailed",
        function(player, cmd, vehicleID, state)
                if exports.integration:isPlayerTrialAdmin(player) then
                        local vehicleID = tonumber(vehicleID)
                        local state = tonumber(state)
                        if vehicleID then
                                local vehicle = exports.pool:getElement("vehicle", vehicleID)
                                if vehicle then
                                        if state == 0 then
                                                setTrainDerailed(vehicle, false)
                                        else
                                                setTrainDerailed(vehicle, true)
                                        end
                                        outputChatBox("Você define um trem (#" .. vehicleID .. ") " .. (state == 0 and "railed" or "derailed") .. ".", player, 0, 255, 0, false)
                                        exports.logs:logMessage("[TRAINRAIL] " .. getPlayerName(player) .. " set a train " .. (state == 0 and "railed" or "derailed") .. " (#" .. vehicleID .. ")", 9)
                                else
                                        outputChatBox("Veículo não encontrado.", player, 255, 0, 0, false)
                                end
                        else
                                outputChatBox("SYNTAX: /" .. cmd .. " [veículo id] [0- Trilhos, 1- Descarrilou]", player, 255, 194, 14, false)
                        end
                end
        end, false, false
)
 
-- Set a train's direction (clockwise or counterclockwise)
addCommandHandler("settraindirection",
        function(player, cmd, vehicleID, direction)
                if exports.integration:isPlayerTrialAdmin(player) then
                        local vehicleID = tonumber(vehicleID)
                        if vehicleID then
                                local vehicle = exports.pool:getElement("vehicle", vehicleID)
                                if vehicle then
                                        if state == 0 then
                                                setTrainDirection(vehicle, true)
                                        else
                                                setTrainDirection(vehicle, false)
                                        end
                                        outputChatBox("You set a train (#" .. vehicleID .. ") " .. (state == 0 and "CW" or "CCW") .. ".", player, 0, 255, 0, false)
                                        exports.logs:logMessage("[TRAINDIR] " .. getPlayerName(player) .. " definir uma direção de trem para " .. (state == 0 and "clockwise" or "counterclockwise") .. " (#" .. vehicleID .. ")", 9)
                                else
                                        outputChatBox("Veículo não encontrado.", player, 255, 0, 0, false)
                                end
                        else
                                outputChatBox("SYNTAX: /" .. cmd .. " [veículo id] [0- CW, 1- CCW]", player, 255, 194, 14, false)
                        end
                end
        end, false, false
)