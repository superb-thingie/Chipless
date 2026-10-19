
SMODS.Atlas{
	key = "modicon",
	path = "modicon.png",
	px = 34,
	py = 34
}

SMODS.Gradient {
    key = "rainbow",
    colours = {
        HEX("e0483e"),
        HEX("fda200"),
        HEX("8dae5f"),
        HEX("33966e"),
        HEX("403fb2"),
        HEX("726ca0"),
        HEX("ae6c98"),

    },
    cycle = 5
}
SMODS.Gradient {
    key = "warn",
    colours = {
        HEX("e0483e"),
        HEX("fda200"),

    },
    cycle = 5
}

chip = {
    show_options_button = true,
}

chip = SMODS.current_mod
chip_config = chip.config
chip.enabled = copy_table(chip_config)


SMODS.Scoring_Calculation{
    key = "mult",
    func = function(self, chips, mult, flames)
	    return mult
	end,
    parameters = {'chips', 'mult'},
    replace_ui = function (self) 
        local w = 3
        local h = 1
		local scale = 0.4
        return
        {n=G.UIT.R, config={align = "cm", minh = 1, padding = 0.1}, nodes={
            {n=G.UIT.C, config={align = 'cm'}, nodes = { 
                SMODS.GUI.operator(scale)
            }},
            {n=G.UIT.C, config={align = 'cm'}, nodes = { 
                {n=G.UIT.R, config={align = 'cm', id = 'hand_mult'}, nodes={
                    SMODS.GUI.score_container({
                        type = 'mult',
                        align = 'cl',
                        w = w,
                        h = h,
						scale = scale,
                    })
                }},
            }},
        }}
    end
}
SMODS.Scoring_Calculation{
    key = "chult",
    func = function(self, chips, mult, flames)
	    return mult + chips
	end,
    parameters = {'chips', 'mult'},
    replace_ui = function (self) 
        local w = 3
        local h = 1
		local scale = 0.4
        return
        {n=G.UIT.R, config={align = "cm", minh = 1}, nodes={
            {n=G.UIT.R, config={align = "cm", minh = 1, padding = 0.1}, nodes={
                {n=G.UIT.C, config={align = 'cm'}, nodes = { 
                    SMODS.GUI.operator(scale)
                }},
                {n=G.UIT.C, config={align = 'cm'}, nodes = { 
                    {n=G.UIT.R, config={align = 'cm', id = 'hand_mult'}, nodes={
                        SMODS.GUI.score_container({
                            type = 'mult',
                            align = 'cl',
                            w = w,
                            h = h,
                            scale = scale,
                        })
                    }},
                }},
            }},
            {n=G.UIT.R, config={align = "cm", minh = 1, padding = 0.1}, nodes={
                {n=G.UIT.C, config={align = "cm", id = 'hand_operator_container'}, nodes={
                    {n=G.UIT.T, config={text = "+", scale = scale, colour = G.C.UI_MULT, shadow = true}},
                }}, 
                {n=G.UIT.C, config={align = 'cm', id = 'hand_chips'}, nodes={
                    SMODS.GUI.score_container({
                        type = 'chips',
                        text = 'chip_text',
                        align = 'cl',
                        w = w / 2,
                        h = h / 2,
                        scale = scale / 2,
                        colour = G.C.UI_MULT
                    })
                }},
            }},
        }}
    end
}

SMODS.Scoring_Calculation{
    key = "supermult",
    func = function(self, chips, mult, flames)
	    return mult ^ 2
	end,
    parameters = {'chips', 'mult'},
    replace_ui = function (self) 
        local w = 3
        local h = 1
		local scale = 0.4
        return
        {n=G.UIT.R, config={align = "cm", minh = 1, padding = 0.1}, nodes={
            {n=G.UIT.C, config={align = 'cm'}, nodes = { 
                SMODS.GUI.operator(scale)
            }},
            {n=G.UIT.C, config={align = 'cm'}, nodes = { 
                {n=G.UIT.R, config={align = 'cm', id = 'hand_mult'}, nodes={
                    SMODS.GUI.score_container({
                        type = 'mult',
                        align = 'cl',
                        w = w,
                        h = h,
						scale = scale,
                    })
                }},
            }},
			{n=G.UIT.C, config={align = "cl", id = 'hand_operator_container'}, nodes={
				{n=G.UIT.T, config={text = "^2", scale = scale * 2, colour = SMODS.Gradients.chip_rainbow, shadow = true}},
			}},
        }}
    end
}
local start_run_ref = Game.start_run
function Game:start_run(args)
    local ret = start_run_ref(self, args)
    SMODS.set_scoring_calculation("chip_mult")
    return ret
end

local quadratic_ante_scaling = get_blind_amount
get_blind_amount = function(ante)
    if rquadratic_ante_scaling == true then
        return ante ^ 2 * 50
    end
    return quadratic_ante_scaling(ante)
end

if (chip.config.convert) then
    function Game:start_run(args)
        local ret = start_run_ref(self, args)
        SMODS.set_scoring_calculation("chip_chult")
        return ret
    end
end

if (chip.config.square) then
    function Game:start_run(args)
        local ret = start_run_ref(self, args)
        SMODS.set_scoring_calculation("chip_supermult")
        return ret
    end
end

if (chip.config.compress) then
    rquadratic_ante_scaling = true
end
chip.config_tab = function()
    return {
        n = G.UIT.ROOT,
        config = {
            align = "cm",
            padding = 0.1,
            colour = G.C.BLACK
        },
        nodes = {
            { n = G.UIT.C, config = { align = "cl", padding = 0.1 }, nodes = {
                    { n = G.UIT.R, config = {
                            align = "cl",
                            padding = 0.05,
                            tooltip = { text = localize("chip_chult_tip") }
                        },
                        nodes = {
                            create_toggle {
                                label = "Turn chips to mult",
                                active_colour = G.C.MONEY,
                                ref_table = chip.config,
                                ref_value = "convert"
                            }
                        }
                    },
                    { n = G.UIT.R, config = {
                            align = "cl",
                            padding = 0.05,
                            tooltip = { text = localize("chip_cubic_mult_tip") }
                        },
                        nodes = {
                            create_toggle {
                                label = "Quadratic mult",
                                active_colour = G.C.MONEY,
                                ref_table = chip.config,
                                ref_value = "square"
                            }
                        }
                    },
                    { n = G.UIT.R, config = {
                            align = "cl",
                            padding = 0.05,
                            tooltip = { text = localize("chip_compress_tip") }
                        },
                        nodes = {
                            create_toggle {
                                label = "Compressed ante scaling",
                                active_colour = G.C.MONEY,
                                ref_table = chip.config,
                                ref_value = "compress"
                            }
                        }
                    }
                }
            }
        }
    }
end