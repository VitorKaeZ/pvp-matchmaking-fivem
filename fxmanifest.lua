fx_version 'cerulean'
games { 'gta5' }

author 'Vetto'
description 'Matchmaking PVP'

lua54 'yes'

client_scripts {
    'client/*.lua',
    'client/class/*.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/*.lua',
    'server/modules/*.lua'

}

-- ui_page 'web-side/main.html'

escrow_ignore {
    'config/*.lua'
}

shared_scripts {
    "config/*.lua",
}

-- files {
--     'web-side/index.html',
--     'web-side/style.css',
--     'web-side/script.js',
-- }
