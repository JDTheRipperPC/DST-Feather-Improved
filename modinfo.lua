name = "Feather Improved"
description = "Feather Improved"
author = "JD The Ripper PC"
version = "1.0"

forumthread = ""

-- This lets other players know if your mod is out of date, update it to match the current varsion in the game
api_version = 10
api_version_dst = 10
dst_compatible = true
dont_starve_compatible = true
reign_of_giants_compatible = true

-- This lets clients know if they need to get the mod from the Steam Workshop to join the game
all_clients_require_mod = false

-- This is basically the opposite; it specifies that this mod doesn't affect other players at all, and if set, won't mark your server as modded
-- client_only_mod = false

-- This lets people search for servers with this mod by these tags
server_filter_tags = {"feathers"}


--[[ 
configuration_options = {
    {
        name = "Dropping feathers from bird cage",
        options = {
            {description = "Disabled", data = 0 },
            {description = "Enabled",  data = 1 }
        },
        default = 0
    }
}
 ]]