-- Commands for MMBN 1 scripting, enjoy.

local commands = require("All/Commands"); -- Menu, Flags, Battle, Items, RNG, Progress, Real, Digital, Setups

local game = require("BN1/Game");
local setup_groups = require("BN1/Setups");

---------------------------------------- Flags ----------------------------------------

local function fun_flag_helper(fun_flag, fun_text)
    if game.fun_flags[fun_flag] then
        fun_text = "[ ON] " .. fun_text;
    else
        fun_text = "[off] " .. fun_text;
    end
    return { value = fun_flag; text = fun_text; };
end

local command_fun_flags = {};
command_fun_flags.selection = 1;
command_fun_flags.description = function() return "These Fun Flags Are:"; end;
function command_fun_flags.update_options(option_value)
    command_fun_flags.options = {};
    table.insert( command_fun_flags.options, fun_flag_helper("modulate_steps"     , "Step Modulation"           ) );
    table.insert( command_fun_flags.options, fun_flag_helper("always_fullcust"    , "Always Fullcust"           ) );
    table.insert( command_fun_flags.options, fun_flag_helper("no_chip_cooldown"   , "No Chip Cooldown"          ) );
    table.insert( command_fun_flags.options, fun_flag_helper("delete_time_zero"   , "Set Delete Time to 0"      ) );
    table.insert( command_fun_flags.options, fun_flag_helper("chip_selection_one" , "Always Choose  1 Chip"     ) );
    table.insert( command_fun_flags.options, fun_flag_helper("chip_selection_max" , "Always Choose 15 Chips"    ) );
    table.insert( command_fun_flags.options, fun_flag_helper("no_encounters"      , "Lock RNG to No  Encounters") );
    table.insert( command_fun_flags.options, fun_flag_helper("yes_encounters"     , "Lock RNG to Yes Encounters") );
end
command_fun_flags.update_options();
function command_fun_flags.doit(value)
    game.fun_flags[value] = not game.fun_flags[value];
    command_fun_flags.update_options();
end
table.insert(commands, command_fun_flags);

---------------------------------------- Battle ----------------------------------------

local command_battle = {};
command_battle.selection = 1;
command_battle.description = function() return "Battle Options:"; end;
command_battle.options = {
    { value = function() game.kill_enemy(0);     end; text = "Delete Everything"; };
    { value = function() game.kill_enemy(1);     end; text = "Delete Enemy 1"   ; };
    { value = function() game.kill_enemy(2);     end; text = "Delete Enemy 2"   ; };
    { value = function() game.kill_enemy(3);     end; text = "Delete Enemy 3"   ; };
    { value = function() game.draw_only_slot(0); end; text = "Draw Only Slot 1" ; };
    { value = function() game.draw_in_order();   end; text = "Draw In Order"    ; };
};
command_battle.doit = function(value) value(); end;
table.insert(commands, command_battle);

---------------------------------------- Items ----------------------------------------

local command_items = {};
command_items.sub_selection = 1;
function command_items.update_options(option_value)
    command_items.options = {};
    command_items.FUNction = nil;
    
    if not option_value then
        command_items.selection = command_items.sub_selection;
        command_items.description = function() return "What will U buy?"; end;
        table.insert( command_items.options, { value = 1; text = "Zenny"       ; } );
        table.insert( command_items.options, { value = 2; text = "PowerUP"     ; } );
        table.insert( command_items.options, { value = 3; text = "HPMemory"    ; } );
        table.insert( command_items.options, { value = 4; text = "Equipment"   ; } );
        table.insert( command_items.options, { value = 5; text = "IceBlock"    ; } );
        table.insert( command_items.options, { value = 6; text = "Chip Folders"; } );
    else
        command_items.sub_selection = command_items.selection;
        command_items.selection = 1;
        table.insert( command_items.options, { value = nil; text = "Previous Menu"; } );
        if option_value == 1 then
            command_items.description = function() return string.format("Zenny: %11u", game.get_zenny()); end;
            table.insert( command_items.options, { value =  100000; text = "Increase by 100000"; } );
            table.insert( command_items.options, { value =   10000; text = "Increase by  10000"; } );
            table.insert( command_items.options, { value =    1000; text = "Increase by   1000"; } );
            table.insert( command_items.options, { value =     100; text = "Increase by    100"; } );
            table.insert( command_items.options, { value =    -100; text = "Decrease by    100"; } );
            table.insert( command_items.options, { value =   -1000; text = "Decrease by   1000"; } );
            table.insert( command_items.options, { value =  -10000; text = "Decrease by  10000"; } );
            table.insert( command_items.options, { value = -100000; text = "Decrease by 100000"; } );
            command_items.FUNction = function(value) game.add_zenny(value); end;
        elseif option_value == 2 then
            command_items.description = function() return string.format("PowerUPs: %2u", game.get_PowerUPs()); end;
            table.insert( command_items.options, { value =  10; text = "Give 10"; } );
            table.insert( command_items.options, { value =   1; text = "Give  1"; } );
            table.insert( command_items.options, { value =  -1; text = "Take  1"; } );
            table.insert( command_items.options, { value = -10; text = "Take 10"; } );
            command_items.FUNction = function(value) game.add_PowerUPs(value); end;
        elseif option_value == 3 then
            command_items.description = function() return string.format("HPMemory: %2u", game.get_HPMemory_count()); end;
            table.insert( command_items.options, { value = nil; text = "Apologies... That is sold out..."; } );
            command_items.FUNction = function(value) game.add_zenny(value); end;
        elseif option_value == 4 then
            command_items.description = function() return string.format("Power Level: %4u", game.calculate_mega_level()); end;
            table.insert( command_items.options, { value = game.reset_buster_stats; text = "Reset Buster Stats"     ; } );
            table.insert( command_items.options, { value = game.max_buster_stats;   text = "Max   Buster Stats"     ; } );
            table.insert( command_items.options, { value = game.hub_buster_stats;   text = "Hub   Buster Stats"     ; } );
            table.insert( command_items.options, { value = game.op_buster_stats;    text = "OP    Buster Stats"     ; } );
            table.insert( command_items.options, { value = game.give_armor;         text = "Get equiped with Armor!"; } );
            command_items.FUNction = function(value) value(); end;
        elseif option_value == 5 then
            command_items.description = function() return string.format("IceBlocks: %2u", game.get_IceBlocks()); end;
            table.insert( command_items.options, { value =  53; text = "Give 53"; } );
            table.insert( command_items.options, { value =   1; text = "Give  1"; } );
            table.insert( command_items.options, { value =  -1; text = "Take  1"; } );
            table.insert( command_items.options, { value = -53; text = "Take 53"; } );
            command_items.FUNction = function(value) game.add_IceBlocks(value); end;
        elseif option_value == 6 then
            command_items.description = function() return string.format("Customize or Randomize!"); end;
            table.insert( command_items.options, { value = function() game.set_all_folder_code_to(1,0);      end; text = "Monocode A Folder"     ; } );
            table.insert( command_items.options, { value = function() game.randomize_folder_codes(1);        end; text = "Randomize Folder Codes"; } );
            table.insert( command_items.options, { value = function() game.randomize_folder_IDs_standard(1); end; text = "Randomize Folder IDs"  ; } );
            table.insert( command_items.options, { value = function() game.set_all_folder_ID_to(1,109);      end; text = "Only Draw BstrBomb"    ; } );
            table.insert( command_items.options, { value = function() game.set_all_folder_ID_to(1,102);      end; text = "Only Draw Invis3"      ; } );
            table.insert( command_items.options, { value = function() game.set_all_folder_ID_to(1, 33);      end; text = "Only Draw HeroSwrd"    ; } );
            command_items.FUNction = function(value) value(); end;
        else
            command_items.description = function() return "Bzzt! (something broke)"; end;
        end
    end
end
command_items.update_options();
function command_items.doit(value)
    if command_items.FUNction and value then
        command_items.FUNction(value);
    else
        command_items.update_options(value);
    end
end
table.insert(commands, command_items);

---------------------------------------- Routing ----------------------------------------

local command_routing = {};
command_routing.sub_selection = 1;
function command_routing.update_options(option_value)
    command_routing.options = {};
    command_routing.FUNction = nil;
    
    if not option_value then
        command_routing.selection = command_routing.sub_selection;
        command_routing.description = function() return "Wanna see some RNG manip?"; end;
        table.insert( command_routing.options, { value = 1; text = "Main RNG Index"; } );
        table.insert( command_routing.options, { value = 2; text = "Step Counter"  ; } );
        table.insert( command_routing.options, { value = 3; text = "Flag Flipper"  ; } );
    else
        command_routing.sub_selection = command_routing.selection;
        command_routing.selection = 1;
        table.insert( command_routing.options, { value = nil; text = "Previous Menu"; } );
        if option_value == 1 then
            command_routing.description = function() return string.format("RNG Index: %5s", (game.ram.get.main_RNG_index() or "?????")); end;
            table.insert( command_routing.options, { value =  1000; text = "Increase by 1000"; } );
            table.insert( command_routing.options, { value =   100; text = "Increase by  100"; } );
            table.insert( command_routing.options, { value =    10; text = "Increase by   10"; } );
            table.insert( command_routing.options, { value =     1; text = "Increase by    1"; } );
            table.insert( command_routing.options, { value =    -1; text = "Decrease by    1"; } );
            table.insert( command_routing.options, { value =   -10; text = "Decrease by   10"; } );
            table.insert( command_routing.options, { value =  -100; text = "Decrease by  100"; } );
            table.insert( command_routing.options, { value = -1000; text = "Decrease by 1000"; } );
            command_routing.FUNction = function(value) game.ram.adjust_main_RNG(value); end;
        elseif option_value == 2 then
            command_routing.description = function() return string.format("Modify Steps: %5s", game.get_steps()); end;
            table.insert( command_routing.options, { value =  1024; text = "Increase by 1024"; } );
            table.insert( command_routing.options, { value =    64; text = "Increase by   64"; } );
            table.insert( command_routing.options, { value =     2; text = "Increase by    2"; } );
            table.insert( command_routing.options, { value =     1; text = "Increase by    1"; } );
            table.insert( command_routing.options, { value =    -1; text = "Decrease by    1"; } );
            table.insert( command_routing.options, { value =    -2; text = "Decrease by    2"; } );
            table.insert( command_routing.options, { value =   -64; text = "Decrease by   64"; } );
            table.insert( command_routing.options, { value = -1024; text = "Decrease by 1024"; } );
            command_routing.FUNction = function(value) game.add_steps(value); end;
        elseif option_value == 3 then
            command_routing.description = function() return "Bits, Nibbles, Bytes, and Words."; end;
            table.insert( command_routing.options, { value = game.go_mode;               text = "Go Mode"              ; } );
            table.insert( command_routing.options, { value = game.set_star_flag;         text = "Set Star Flag"        ; } );
            table.insert( command_routing.options, { value = game.clear_star_flag;       text = "Clear Star Flag"      ; } );
            table.insert( command_routing.options, { value = game.ignite_oven_fires;     text = "Ignite Oven Fires"    ; } );
            table.insert( command_routing.options, { value = game.extinguish_oven_fires; text = "Extinguish Oven Fires"; } );
            table.insert( command_routing.options, { value = game.ignite_WWW_fires;      text = "Ignite WWW Fires"     ; } );
            table.insert( command_routing.options, { value = game.extinguish_WWW_fires;  text = "Extinguish WWW Fires" ; } );
            table.insert( command_routing.options, { value = game.reset_main_RNG;        text = "Restart Main RNG"     ; } );
            command_routing.FUNction = function(value) value(); end;
        else
            command_routing.description = function() return "Bzzt! (something broke)"; end;
        end
    end
end
command_routing.update_options();
function command_routing.doit(value)
    if command_routing.FUNction and value then
        command_routing.FUNction(value);
    else
        command_routing.update_options(value);
    end
end
table.insert(commands, command_routing);

---------------------------------------- Progress ----------------------------------------

local command_progress = {};
command_progress.sub_selection = 1;
function command_progress.update_options(option_value)
    command_progress.options = {};
    command_progress.scenario = nil;
    
    if not option_value then
        command_progress.selection = command_progress.sub_selection;
        command_progress.description = function() return "Select a Progress scenario:"; end;
        table.insert( command_progress.options, { value = 0x00; text = "0x00 ProbablyAVirus";  } );
        table.insert( command_progress.options, { value = 0x10; text = "0x10 School Takeover"; } );
        table.insert( command_progress.options, { value = 0x20; text = "0x20 Complex Complex"; } );
        table.insert( command_progress.options, { value = 0x30; text = "0x30 City Traffic";    } );
        table.insert( command_progress.options, { value = 0x40; text = "0x40 Power Plant";     } );
        table.insert( command_progress.options, { value = 0x50; text = "0x50 Get the Memos";   } );
    else
        command_progress.sub_selection = command_progress.selection;
        command_progress.selection = 1;
        command_progress.scenario = option_value;
        command_progress.description = function() return "Select a Progress value:"; end;
        table.insert( command_progress.options, { value = nil; text = "Previous Menu"; } );
        for i=option_value,option_value+0xF do
            if game.is_progress_valid(i) then
                table.insert( command_progress.options, { value = i; text = string.format("0x%02X: %s", i, game.get_progress_name(i)); } );
            end
        end
    end
end
command_progress.update_options();
function command_progress.doit(value)
    if command_progress.scenario and value then
        game.set_progress(value);
    else
        command_progress.update_options(value);
    end
end
table.insert(commands, command_progress);

---------------------------------------- Real Areas ----------------------------------------

local teleport_real_world = {};
teleport_real_world.sub_selection = 1;
function teleport_real_world.update_options(option_value)
    teleport_real_world.options = {};
    teleport_real_world.main_area = nil;
    
    if not option_value then
        teleport_real_world.selection = teleport_real_world.sub_selection;
        teleport_real_world.description = function() return "Select a real world group:"; end;
        for i,group in pairs(game.get_area_groups_real()) do
            table.insert( teleport_real_world.options, { value = group; text = game.get_area_group_name(group); } );
        end
    else
        teleport_real_world.sub_selection = teleport_real_world.selection;
        teleport_real_world.selection = 1;
        teleport_real_world.main_area = option_value;
        teleport_real_world.description = function() return "Select an area:"; end;
        table.insert( teleport_real_world.options, { value = nil; text = "Previous Menu"; } );
        for i=0,0xF do
            if game.does_area_exist(option_value, i) then
                table.insert( teleport_real_world.options, { value = i; text = game.get_area_name(option_value, i); } );
            end
        end
    end
end
teleport_real_world.update_options();
function teleport_real_world.doit(value)
    if teleport_real_world.main_area and value then
        game.teleport(teleport_real_world.main_area, value);
        return true; -- exit command mode
    else
        teleport_real_world.update_options(value);
    end
end
table.insert(commands, teleport_real_world);

---------------------------------------- Digital Areas ----------------------------------------

local teleport_digital_world = {};
teleport_digital_world.sub_selection = 1;
function teleport_digital_world.update_options(option_value)
    teleport_digital_world.options = {};
    teleport_digital_world.main_area = nil;
    
    if not option_value then
        teleport_digital_world.selection = teleport_digital_world.sub_selection;
        teleport_digital_world.description = function() return "Select a digital world group:"; end;
        for i,group in pairs(game.get_area_groups_digital()) do
            table.insert( teleport_digital_world.options, { value = group; text = game.get_area_group_name(group); } );
        end
    else
        teleport_digital_world.sub_selection = teleport_digital_world.selection;
        teleport_digital_world.selection = 1;
        teleport_digital_world.main_area = option_value;
        teleport_digital_world.description = function() return "Select an area:"; end;
        table.insert( teleport_digital_world.options, { value = nil; text = "Previous Menu"; } );
        for i=0,0xF do
            if game.does_area_exist(option_value, i) then
                table.insert( teleport_digital_world.options, { value = i; text = game.get_area_name(option_value, i); } );
            end
        end
    end
end
teleport_digital_world.update_options();
function teleport_digital_world.doit(value)
    if teleport_digital_world.main_area and value then
        game.teleport(teleport_digital_world.main_area, value);
        return true; -- exit command mode
    else
        teleport_digital_world.update_options(value);
    end
end
table.insert(commands, teleport_digital_world);

---------------------------------------- Setups ----------------------------------------

local command_setups = {};
command_setups.sub_selection = 1;
function command_setups.update_options(option_value)
    command_setups.options = {};
    command_setups.FUNction = nil;
    
    if not option_value then
        command_setups.selection = command_setups.sub_selection;
    command_setups.description = function() return "What Kind Of Button Pressing?"; end;
        for i,setup_group in pairs(setup_groups) do
            table.insert( command_setups.options, { value = i; text = setup_group.description; } );
        end
    else
        command_setups.sub_selection = command_setups.selection;
        command_setups.selection = 1;
        table.insert( command_setups.options, { value = nil; text = "Previous Menu"; } );
        command_setups.description = function() return setup_groups[option_value].description; end;
        for i,setup in pairs(setup_groups[option_value].setups) do
            table.insert( command_setups.options, { value = setup.doit; text = setup.description; } );
        end
        command_setups.FUNction = function(value) value(); end;
    end
end
command_setups.update_options();
function command_setups.doit(value)
    if command_setups.FUNction and value then
        command_setups.FUNction(value);
        return true; -- exit command mode
    else
        command_setups.update_options(value);
    end
end
table.insert(commands, command_setups);

---------------------------------------- Module ----------------------------------------

return commands;

