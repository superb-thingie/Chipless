
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
SMODS.Scoring_Parameter({
    key = 'chult',
    default_value = 1,
    colour = G.C.UI_MULT,
    calculation_keys = {
        'mult', 'h_mult', 'mult_mod','chips', 'h_chips', 'chip_mod',
        'x_chips', 'xchips', 'Xchip_mod',
        'x_mult', 'Xmult', 'xmult', 'x_mult_mod', 'Xmult_mod'
    },    
    hands = {
            ['Pair'] = {[SMODS.current_mod.prefix..'_chult'] = 2, ['l_'..SMODS.current_mod.prefix..'_chult'] = 1, ['s_'..SMODS.current_mod.prefix..'_chult'] = 2},
            ['Four of a Kind'] = {[SMODS.current_mod.prefix..'_chult'] = 7, ['l_'..SMODS.current_mod.prefix..'_chult'] = 3, ['s_'..SMODS.current_mod.prefix..'_chult'] = 7},
            ["Flush Five"] = {[SMODS.current_mod.prefix..'_chult'] = 16, ['l_'..SMODS.current_mod.prefix..'_chult'] = 3, ['s_'..SMODS.current_mod.prefix..'_chult'] = 16},
            ["Flush House"] = {[SMODS.current_mod.prefix..'_chult'] = 14, ['l_'..SMODS.current_mod.prefix..'_chult'] = 4, ['s_'..SMODS.current_mod.prefix..'_chult'] = 14},
            ["Five of a Kind"] = {[SMODS.current_mod.prefix..'_chult'] = 12, ['l_'..SMODS.current_mod.prefix..'_chult'] = 3, ['s_'..SMODS.current_mod.prefix..'_chult'] = 12},
            ["Straight Flush"] = {[SMODS.current_mod.prefix..'_chult'] = 8, ['l_'..SMODS.current_mod.prefix..'_chult'] = 4, ['s_'..SMODS.current_mod.prefix..'_chult'] = 8},
            ["Full House"] = {[SMODS.current_mod.prefix..'_chult'] = 4, ['l_'..SMODS.current_mod.prefix..'_chult'] = 2, ['s_'..SMODS.current_mod.prefix..'_chult'] = 4},
            ["Flush"] = {[SMODS.current_mod.prefix..'_chult'] = 4, ['l_'..SMODS.current_mod.prefix..'_chult'] = 2, ['s_'..SMODS.current_mod.prefix..'_chult'] = 4},
            ["Straight"] = {[SMODS.current_mod.prefix..'_chult'] = 4, ['l_'..SMODS.current_mod.prefix..'_chult'] = 3, ['s_'..SMODS.current_mod.prefix..'_chult'] = 4},
            ["Three of a Kind"] = {[SMODS.current_mod.prefix..'_chult'] = 3, ['l_'..SMODS.current_mod.prefix..'_chult'] = 2, ['s_'..SMODS.current_mod.prefix..'_chult'] = 3},
            ["Two Pair"] = {[SMODS.current_mod.prefix..'_chult'] = 2, ['l_'..SMODS.current_mod.prefix..'_chult'] = 1, ['s_'..SMODS.current_mod.prefix..'_chult'] = 2},
            ["High Card"] = {[SMODS.current_mod.prefix..'_chult'] = 1, ['l_'..SMODS.current_mod.prefix..'_chult'] = 1, ['s_'..SMODS.current_mod.prefix..'_chult'] = 1},
        },
        calc_effect = function(self, effect, scored_card, key, amount, from_edition)
            local calculation = G.GAME and G.GAME.current_scoring_calculation
            local uses_chult = false

            if calculation and calculation.parameters then
                for _, parameter in ipairs(calculation.parameters) do
                    if parameter == self.key then
                        uses_chult = true
                        break
                    end
                end
            end
            if uses_chult and (key == 'x_chips' or key == 'xchips' or key == 'Xchip_mod' 
                or key == 'x_mult' or key == 'xmult' or key == 'Xmult' or key == 'x_mult_mod' or key == 'Xmult_mod') 
                and amount then
                
                if uses_chult and (key == 'x_chips' or key == 'xchips' or key == 'Xchip_mod' 
                    or key == 'x_mult' or 'x_mult' or key == 'xmult' or key == 'Xmult' 
                    or key == 'x_mult_mod' or key == 'Xmult_mod') then
                    effect.message = nil
                end
                
                if effect.card and effect.card ~= scored_card then juice_card(effect.card) end
                self:modify(self.current * amount - self.current)
                card_eval_status_text(scored_card, 'extra', nil, percent, nil,
                    {sound = "multhit2", 
                    message = 'X'..amount..' Mult', 
                    colour = self.colour})
                return true
            end
            if uses_chult == false and (key == 'x_chips' or key == 'xchips' or key == 'Xchip_mod') and amount ~= 1 then
                if effect.card and effect.card ~= scored_card then juice_card(effect.card) end
			    local chips = SMODS.Scoring_Parameters["chips"]
                chips:modify(chips.current * (amount - 1))
                if not effect.remove_default_message then
                    if from_edition then
                        card_eval_status_text(scored_card, 'jokers', nil, percent, nil, {message = localize{type='variable',key= amount > 0 and 'a_xchips' or 'a_xchips_minus',vars={math.abs(amount)}}, Xchips_mod =  amount, colour =  G.C.EDITION, edition = true})
                    else
                        if key ~= 'Xchip_mod' then
                            if effect.xchip_message then
                                card_eval_status_text(effect.message_card or effect.juice_card or scored_card or effect.card or effect.focus, 'extra', nil, percent, nil, effect.xchip_message)
                            else
                                card_eval_status_text(effect.message_card or effect.juice_card or scored_card or effect.card or effect.focus, 'x_chips', amount, percent)
                            end
                        end
                    end
                end
                return true
            end
            if uses_chult == false and (key == 'x_mult' or key == 'xmult' or key == 'Xmult' or key == 'x_mult_mod' or key == 'Xmult_mod') and amount ~= 1 then
                if effect.card and effect.card ~= scored_card then juice_card(effect.card) end
			    local mult = SMODS.Scoring_Parameters["mult"]
                mult:modify(mult.current * (amount - 1))
                if not effect.remove_default_message then
                    if from_edition then
                        card_eval_status_text(scored_card, 'jokers', nil, percent, nil, {message = localize{type='variable',key= amount > 0 and 'a_xmult' or 'a_xmult_minus',vars={amount}}, Xmult_mod =  amount, colour =  G.C.EDITION, edition = true})
                    else
                        if key ~= 'Xmult_mod' then
                            if effect.xmult_message then
                                card_eval_status_text(effect.message_card or effect.juice_card or scored_card or effect.card or effect.focus, 'extra', nil, percent, nil, effect.xmult_message)
                            else
                                card_eval_status_text(effect.message_card or effect.juice_card or scored_card or effect.card or effect.focus, 'x_mult', amount, percent)
                            end
                        end
                    end
                end
                return true
            end
            if uses_chult and (key == 'mult' or key == 'h_mult' or key == 'mult_mod' or key == 'chips' or key == 'h_chips' or key == 'chip_mod') and amount then
                if uses_chult and (key == 'mult' or key == 'h_mult' or key == 'mult_mod' or key == 'chips' or key == 'h_chips' or key == 'chip_mod') then
                    effect.message = nil
                end
                if effect.card and effect.card ~= scored_card then juice_card(effect.card) end
                self:modify(amount)
                if not effect.remove_default_message then
                    if from_edition then
                        card_eval_status_text(scored_card, 'jokers', nil, percent, nil, {message = localize{type = 'variable', key = amount > 0 and 'a_mult' or 'a_mult_minus', vars = {math.abs(amount)}}, mult_mod = amount, colour = G.C.DARK_EDITION, edition = true})
                    else
                        if key ~= 'mult_mod' then
                            if effect.mult_message then
                                card_eval_status_text(effect.message_card or effect.juice_card or scored_card or effect.card or effect.focus, 'extra', nil, percent, nil, effect.mult_message)
                            else
                                card_eval_status_text(effect.message_card or effect.juice_card or scored_card or effect.card or effect.focus, 'mult', amount, percent)
                            end
                        end
                    end
                end
                return true
            end
            if uses_chult == false and (key == 'chips' or key == 'h_chips' or key == 'chip_mod') and amount then
                if effect.card and effect.card ~= scored_card then juice_card(effect.card) end
			    local chips = SMODS.Scoring_Parameters["chips"]
                chips:modify(amount)
                if not effect.remove_default_message then
                    if from_edition then
                        card_eval_status_text(scored_card, 'jokers', nil, percent, nil, {message = localize{type = 'variable', key = amount > 0 and 'a_chips' or 'a_chips_minus', vars = {math.abs(amount)}}, chip_mod = amount, colour = G.C.EDITION, edition = true})
                    else
                        if key ~= 'chip_mod' then
                            if effect.chip_message then
                                card_eval_status_text(effect.message_card or effect.juice_card or scored_card or effect.card or effect.focus, 'extra', nil, percent, nil, effect.chip_message)
                            else
                                card_eval_status_text(effect.message_card or effect.juice_card or scored_card or effect.card or effect.focus, 'chips', amount, percent)
                            end
                        end
                    end
                end
                return true
            end
            if uses_chult == false and (key == 'mult' or key == 'h_mult' or key == 'mult_mod') and amount then
                if effect.card and effect.card ~= scored_card then juice_card(effect.card) end
			    local mult = SMODS.Scoring_Parameters["mult"]
                mult:modify(amount)
                if not effect.remove_default_message then
                    if from_edition then
                        card_eval_status_text(scored_card, 'jokers', nil, percent, nil, {message = localize{type = 'variable', key = amount > 0 and 'a_mult' or 'a_mult_minus', vars = {math.abs(amount)}}, mult_mod = amount, colour = G.C.DARK_EDITION, edition = true})
                    else
                        if key ~= 'mult_mod' then
                            if effect.mult_message then
                                card_eval_status_text(effect.message_card or effect.juice_card or scored_card or effect.card or effect.focus, 'extra', nil, percent, nil, effect.mult_message)
                            else
                                card_eval_status_text(effect.message_card or effect.juice_card or scored_card or effect.card or effect.focus, 'mult', amount, percent)
                            end
                        end
                    end
                end
                return true
            end
        end
})
SMODS.Scoring_Calculation{
    key = "chult",
    func = function(self, chips, mult, flames)
	    return SMODS.get_scoring_parameter(self.mod.prefix..'_chult', flames)
	end,
    parameters = {SMODS.current_mod.prefix..'_chult'},
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
                {n=G.UIT.R, config={align = 'cm'}, nodes={
                    SMODS.GUI.score_container({
                        type = 'chip_chult',
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
SMODS.Scoring_Calculation{
    key = "superchult",
    func = function(self, chips, mult, flames)
	    return SMODS.get_scoring_parameter(self.mod.prefix..'_chult', flames) ^ 2
	end,
    parameters = {SMODS.current_mod.prefix..'_chult'},
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
                {n=G.UIT.R, config={align = 'cm'}, nodes={
                    SMODS.GUI.score_container({
                        type = 'chip_chult',
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

local quad_ante_scaling = get_blind_amount
get_blind_amount = function(ante)
    if compress_scaling == true then
        return ante ^ 2 * 50
    end
    return quad_ante_scaling(ante)
end

if (chip.config.compress) then
    compress_scaling = true
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

if (chip.config.square) and (chip.config.convert) then
    function Game:start_run(args)
        local ret = start_run_ref(self, args)
        SMODS.set_scoring_calculation("chip_superchult")
        return ret
    end
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
