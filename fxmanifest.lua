fx_version 'cerulean'
lua54 'yes' -- enable Lua 5.4
game 'gta5'

author 'YourName'
description 'Duty System with Department Permissions and Discord Logging'
version '1.4.0'

client_script 'client.lua'

server_script {
    'config.lua',
    'server.lua'
}
