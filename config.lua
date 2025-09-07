Config = {}

-- Department labels and permissions
Config.Departments = {
    civ = {
        label = "Civilian",
        permission = "duty.civ"
    },
    sahp = {
        label = "San Andreas Highway Patrol",
        permission = "duty.sahp"
    },
    bcso = {
        label = "Blaine County Sheriff's Office",
        permission = "duty.bcso"
    },
    lspd = {
        label = "Los Santos Police Department",
        permission = "duty.lspd"
    },
    safr = {
        label = "San Andreas Fire Rescue",
        permission = "duty.safr"
    }
}

-- Webhook URL for duty logs (paste your webhook here)
Config.WebhookURL = "https://discord.com/api/webhooks/your_webhook_url_here"

-- Optional: Username that appears in Discord
Config.WebhookUsername = "Duty System"

-- Optional: Enable or disable webhook (true/false)
Config.WebhookEnabled = true
