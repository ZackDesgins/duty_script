local dutyStatus = {}

RegisterCommand("duty", function(source, args)
    local departmentKey = args[1] and args[1]:lower()
    if not departmentKey or not Config.Departments[departmentKey] then
        TriggerClientEvent("dutySystem:notifyDutyStatus", source, "Invalid department. Usage: /duty [civ/sahp/bcso/lspd/safr]")
        return
    end

    local dept = Config.Departments[departmentKey]
    if not IsPlayerAceAllowed(source, dept.permission) then
        TriggerClientEvent("dutySystem:notifyDutyStatus", source, "You do not have permission to go on duty as " .. dept.label)
        return
    end

    local isOnDuty = not (dutyStatus[source] and dutyStatus[source].onDuty)
    dutyStatus[source] = {
        onDuty = isOnDuty,
        department = isOnDuty and departmentKey or nil
    }

    local statusText = isOnDuty and ("on duty as " .. dept.label) or "off duty"
    TriggerClientEvent("dutySystem:notifyDutyStatus", source, statusText)

    local name = GetPlayerName(source)
    print(("[DutySystem] %s is now %s"):format(name, statusText))

    -- Send to Discord if enabled
    if Config.WebhookEnabled and Config.WebhookURL and Config.WebhookURL ~= "" then
        sendDutyLogToDiscord(name, source, dept.label, isOnDuty)
    end
end, false)

AddEventHandler("playerDropped", function()
    dutyStatus[source] = nil
end)

exports("isPlayerOnDuty", function(playerId)
    return dutyStatus[playerId] and dutyStatus[playerId].onDuty
end)

exports("getPlayerDepartment", function(playerId)
    return dutyStatus[playerId] and dutyStatus[playerId].department
end)

function sendDutyLogToDiscord(playerName, playerId, department, isOnDuty)
    local embed = {
        {
            ["title"] = isOnDuty and "🟢 Duty Clock-In" or "🔴 Duty Clock-Out",
            ["color"] = isOnDuty and 65280 or 16711680,
            ["fields"] = {
                { name = "Player", value = playerName, inline = true },
                { name = "Server ID", value = tostring(playerId), inline = true },
                { name = "Department", value = department, inline = true },
                { name = "Status", value = isOnDuty and "On Duty" or "Off Duty", inline = true }
            },
            ["footer"] = {
                ["text"] = os.date("Clocked %A, %B %d %Y at %X"),
            }
        }
    }

    local payload = {
        username = Config.WebhookUsername or "Duty System",
        embeds = embed
    }

    PerformHttpRequest(Config.WebhookURL, function(err, text, headers)
        if err ~= 204 and err ~= 200 then
            print(("[DutySystem] Webhook failed (err=%s): %s"):format(tostring(err), tostring(text)))
        end
    end, "POST", json.encode(payload), { ["Content-Type"] = "application/json" })
end
