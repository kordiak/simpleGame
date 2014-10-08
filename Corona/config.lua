--require("code.otherLibrary.console")
--log = logging.console()
--logTable = logging.logTable
--shallowLogTable = logging.shallowLogTable
--traceback = logging.traceback

application = {
	content = {
		width = 640,
		height = 960, 
		scale = "letterBox",
		fps = 60,
		
		--[[
        imageSuffix = {
		    ["@2x"] = 2,
		}
		--]]
	},

    --[[
    -- Push notifications

    notification =
    {
        iphone =
        {
            types =
            {
                "badge", "sound", "alert", "newsstand"
            }
        }
    }
    --]]    
}
