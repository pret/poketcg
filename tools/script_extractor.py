#!/usr/bin/env python3
###############################################################################
###### Use: python3 tools/script_extractor --noauto --error location     ######
###### --noauto  turns off automatic script parsing (enter to continue)  ######
###### --error   stops execution if an error occurs                      ######
###### location can be local to bank or global. This program assumes     ######
###### every script is in bank 3, which seems to be the case.            ######
######                                                                   ######
###### Script list is a work in progress. The following arguments are    ######
###### accepted and accounted for.                                       ######
###### b - byte    w - word    j - jump (within script)    t - text (tx) ######
###### f - flag    d - direction    i - decimal byte    m - npc move ptr ######
###### q - Used when the script's arguments have not been determined yet ######
###############################################################################
import argparse

# Quit Types
DO_NOT_QUIT = 0
QUIT_CONTINUE_CODE = 1
QUIT_JUMP = 2
QUIT_SPECIAL = 3
QUIT_DEBUG = -1

dir_list = ["NORTH","EAST","SOUTH","WEST"]

def printHeader(loc, prefix):
		ls = format(loc,"04x")
		lsa = format(loc-0x8000,"04x")
		print(prefix + ls + ": ; " + ls + " (3:" + lsa + ")" )

def extractMovement(game_data, loc, errQuit):
	printHeader(loc, "NPCMovement_")
	loc -= 1 # so we can continue without breaking things
	while game_data[loc+1] != 0xff:
		loc += 1
		dirLow = game_data[loc] & 0x0f
		if dirLow > 3:
			print("ERROR: [" + format(loc,"04x") + "] was not a valid direction. Got: " +  format(game_data[loc],"02x"))
			if errQuit:
				return QUIT_DEBUG
			continue
		lineStr = "\tdb " + dir_list[dirLow]
		dirHigh = game_data[loc] & 0xf0
		if dirHigh == 0x80:
			lineStr += " | NO_MOVE"
		elif dirHigh != 0x00:
			print("ERROR: [" + format(loc,"04x") + "] was not a valid direction. Got: " +  format(game_data[loc],"02x"))
			if errQuit:
				return QUIT_DEBUG
			continue
		print(lineStr)
	print("\tdb $ff")
	print("; " + format(loc+2,"04x"))
	return DO_NOT_QUIT

def decodeLine(scriptList, game_data, loc, ignore_broken, locList):
	currLine = scriptList[game_data[loc]]
	macroMode = False
	if currLine[3] != "": # this seems like a bad way to handle macros, but the least bad I wanna do rn
		macroMode = True
		ret = "\t" + currLine[3] + " "
	else:
		ret = "\trun_command " + currLine[0] + "\n"
	loc+=1
	quit = currLine[2]
	for c in currLine[1]:
		if c == "b":
			if macroMode:
				ret += "$" + format(game_data[loc],"02x") + ", "
			else:
				ret += "\tdb $" + format(game_data[loc],"02x") + "\n"
			loc += 1
		elif c == "i":
			if macroMode:
				ret += str(game_data[loc]) + ", "
			else:
				ret += "\tdb " + str(game_data[loc]) + "\n"
			loc += 1
		elif c == "w":
			if macroMode:
				ret += "$" + format((game_data[loc] + (game_data[loc+1]<<8)),"04x") + ", "
			else:
				ret += "\tdw $" + format((game_data[loc] + (game_data[loc+1]<<8)),"04x") + "\n"
			loc += 2
		elif c == "j":
			wordLoc = (game_data[loc] + (game_data[loc+1]<<8))
			if wordLoc == 0000:
				if macroMode:
					ret += "NO_JUMP, "
				else:
					ret += "\tdw NO_JUMP\n"
			else:
				if macroMode:
					ret += ".ows_" + format(wordLoc+0x8000,"04x") + ", "
				else:
					ret += "\tdw .ows_" + format(wordLoc+0x8000,"04x") + "\n"
				locList.append(wordLoc)
			loc += 2
		elif c == "t":
			addr = (game_data[loc] + (game_data[loc+1]<<8))
			if addr == 0:
				if macroMode:
					ret += "$0000, "
				else:
					ret += "\tdw $0000\n"
			else:
				if macroMode:
					ret += "Text" + format(addr,"04x") + ", "
				else:
					ret += "\ttx Text" + format(addr,"04x") + "\n"
			loc += 2
		elif c == "f":
			if macroMode:
				ret += "EVENT_FLAG_" + format(game_data[loc],"02X") + ", "
			else:
				ret += "\tdb EVENT_FLAG_" + format(game_data[loc],"02X") + "\n"
			loc += 1
		elif c == "d":
			if macroMode:
				ret += dir_list[game_data[loc]] + ", "
			else:
				ret += "\tdb " + dir_list[game_data[loc]] + "\n"
			loc += 1
		elif c == "m":
			wordLoc = (game_data[loc] + (game_data[loc+1]<<8))
			if macroMode:
				ret += "NPCMovement_" + format(wordLoc + 0x8000, "04x") + ", "
			else:
				ret += "\tdw NPCMovement_" + format(wordLoc + 0x8000, "04x") + "\n"
			loc += 2
		elif c == "q":
			print("haven't updated data for this yet")
			if not ignore_broken:
				quit = QUIT_DEBUG
		else:
			print("UNACCEPTED CHARACTER: " + c)
	# if in macro mode, remove the extra `, ` from the end
	if ret[-2:] == ", ":
	    ret = ret[:-1]
	return (loc, ret, quit)

def main():
	scriptList = createList()
	locList = []

	parser = argparse.ArgumentParser(description='Pokemon TCG Script Extractor')
	parser.add_argument('--noauto', action='store_true', help='turns off automatic script parsing')
	parser.add_argument('--error', action='store_true', help='stops execution if an error occurs')
	parser.add_argument('-m', '--movement', action='store_true', help='interprets bytes as a movement sequence rather than a Script')
	parser.add_argument('-r', '--rom', default="baserom.gbc", help='rom file to extract script from')
	parser.add_argument('locations', nargs="+", help='locations to extract from. May be local to bank or global.')
	args = parser.parse_args()
	for locStr in args.locations:
		loc = int(locStr,0)
		if loc > 0x7fff:
			# Must be a global location
			loc -= 0x8000
		locList.append(loc)

	# this is a list of every start location we've read to avoid infinite loops
	exploredList = []

	with open(args.rom, "rb") as file:
	    game_data = file.read()

	auto = not args.noauto
	end = DO_NOT_QUIT
	ignore_broken = not args.error
	while (len(locList) > 0 and end != QUIT_DEBUG):
		locList.sort() # export parts in order somewhat
		loc = locList.pop(0) + 0x8000
		if args.movement:
			end = extractMovement(game_data,loc, args.error)
		else:
			end = printScript(game_data, loc, auto, ignore_broken, scriptList,\
			locList, exploredList)

def printScript(game_data, loc, auto, ignore_broken, scriptList, \
				locList, exploredList):
	if loc in exploredList:
		return
	exploredList.append(loc)
	script = ""
	end = DO_NOT_QUIT
	if game_data[loc] != 0xe7:
		#print("Error: first byte was not start_script")
		print(".ows_" + format(loc,"04x"))
	else:
		
		# TODO this is hacky please don't do this 
		printHeader(loc, "Script_")
		loc += 1
		print("\tstart_script")
	while end == DO_NOT_QUIT:
		loc, outstr, end = decodeLine(scriptList,game_data,loc,ignore_broken,locList)
		outstr = outstr[:-1] # [:-1] strips the newline at the end
		if auto:
			print(outstr)
		else:
			input(outstr)
	warning = ""
	if end == QUIT_CONTINUE_CODE:
		warning = " WARNING: There is probably regular assembly here"

	print("; " + hex(loc) + warning)

	# if the next byte is a ret, print it for the continue_code case
	if game_data[loc] == 0xc9:
		print("\tret")

	return end

def createList(): # this is a func just so all this can go at the bottom
	# name, arg list, is an ender
	return [
	("ScriptCommand_EndScriptLoop1", "", QUIT_CONTINUE_CODE,"end_script_loop"),
	("ScriptCommand_CloseAdvancedTextBox", "", DO_NOT_QUIT,"close_advanced_text_box"),
	("ScriptCommand_PrintTextString", "t", DO_NOT_QUIT,"print_text_string"),
	("Func_ccdc", "t", DO_NOT_QUIT,""),
	("ScriptCommand_AskQuestionJump", "tj", DO_NOT_QUIT,"ask_question_jump"), # more complex behavior too (jumping)
	("ScriptCommand_StartBattle", "bbb", DO_NOT_QUIT,"start_battle"),
	("ScriptCommand_PrintVariableText", "tt", DO_NOT_QUIT,"print_variable_text"),
	("Func_cda8", "bbbb", DO_NOT_QUIT,""),
	("ScriptCommand_PrintTextQuitFully", "t", QUIT_SPECIAL,"print_text_quit_fully"),
	("Func_cdcb", "", DO_NOT_QUIT,""),
	("ScriptCommand_MoveActiveNPCByDirection", "w", DO_NOT_QUIT,"move_active_npc_by_direction"),
	("ScriptCommand_CloseTextBox", "", DO_NOT_QUIT,"close_text_box"),
	("ScriptCommand_GiveBoosterPacks", "bbb", DO_NOT_QUIT,"give_booster_packs"),
	("ScriptCommand_JumpIfCardOwned", "bj", DO_NOT_QUIT,"jump_if_card_owned"),
	("ScriptCommand_JumpIfCardInCollection", "bj", DO_NOT_QUIT,"jump_if_card_in_collection"),
	("ScriptCommand_GiveCard", "b", DO_NOT_QUIT,"give_card"),
	("ScriptCommand_TakeCard", "b", DO_NOT_QUIT,"take_card"),
	("Func_cf53", "w", DO_NOT_QUIT,""), # more complex behavior too (jumping)
	("Func_cf7b", "", DO_NOT_QUIT,""),
	("ScriptCommand_JumpIfEnoughCardsOwned", "wj", DO_NOT_QUIT,"jump_if_enough_cards_owned"), 
	("ScriptCommand_JumpBasedOnFightingClubPupilStatus", "jjjjj", DO_NOT_QUIT,"fight_club_pupil_jump"),
	("Func_cfc6", "b", DO_NOT_QUIT,""),
	("Func_cfd4", "", DO_NOT_QUIT,""),
	("Func_d00b", "", DO_NOT_QUIT,""), # includes something with random and extra data
	("Func_d025", "w", DO_NOT_QUIT,""), # possibly only jumps, still needs args
	("Func_d032", "w", DO_NOT_QUIT,""), # see above
	("Func_d03f", "", DO_NOT_QUIT,""),
	("ScriptCommand_Jump", "j", QUIT_JUMP,"script_jump"),
	("ScriptCommand_TryGiveMedalPCPacks", "", DO_NOT_QUIT,"try_give_medal_pc_packs"),
	("ScriptCommand_SetPlayerDirection", "d", DO_NOT_QUIT,"set_player_direction"),
	("ScriptCommand_MovePlayer", "di", DO_NOT_QUIT,"move_player"),
	("ScriptCommand_ShowCardReceivedScreen", "b", DO_NOT_QUIT,"show_card_received_screen"),
	("ScriptCommand_SetDialogNPC", "b", DO_NOT_QUIT,"set_dialog_npc"),
	("ScriptCommand_SetNextNPCAndScript", "bj", DO_NOT_QUIT,"set_next_npc_and_script"),
	("Func_d095", "bbb", DO_NOT_QUIT,""),
	("Func_d0be", "bb", DO_NOT_QUIT,""),
	("ScriptCommand_DoFrames", "i", DO_NOT_QUIT,"do_frames"),
	("Func_d0d9", "bbw", DO_NOT_QUIT,""), # jumps but still needs args
	("ScriptCommand_JumpIfPlayerCoordsMatch", "iij", DO_NOT_QUIT,"jump_if_player_coords_match"), # jumps but still needs args
	("ScriptCommand_MoveActiveNPC", "m", DO_NOT_QUIT,"move_active_npc"),
	("ScriptCommand_GiveOneOfEachTrainerBooster", "", DO_NOT_QUIT,"give_one_of_each_trainer_booster"),
	("Func_d103", "q", DO_NOT_QUIT,""),
	("Func_d125", "b", DO_NOT_QUIT,""),
	("Func_d135", "b", DO_NOT_QUIT,""),
	("Func_d16b", "b", DO_NOT_QUIT,""),
	("Func_cd4f", "bbb", DO_NOT_QUIT,""),
	("Func_cd94", "q", DO_NOT_QUIT,""),
	("ScriptCommand_MoveWramNPC", "m", DO_NOT_QUIT,"move_wram_npc"),
	("Func_cdd8", "", DO_NOT_QUIT,""),
	("Func_cdf5", "bb", DO_NOT_QUIT,""),
	("Func_d195", "", DO_NOT_QUIT,""),
	("Func_d1ad", "", DO_NOT_QUIT,""),
	("Func_d1b3", "", DO_NOT_QUIT,""),
	("ScriptCommand_QuitScriptFully", "", QUIT_SPECIAL,"quit_script_fully"),
	("Func_d244", "q", DO_NOT_QUIT,""),
	("ScriptCommand_ChooseDeckToDuelAgainstMultichoice", "", DO_NOT_QUIT,"choose_deck_to_duel_against_multichoice"),
	("ScriptCommand_OpenDeckMachine", "b", DO_NOT_QUIT,"open_deck_machine"),
	("ScriptCommand_ChooseStarterDeckMultichoice", "", DO_NOT_QUIT,""),
	("ScriptCommand_EnterMap", "bbood", DO_NOT_QUIT,"enter_map"),
	("ScriptCommand_MoveArbitraryNPC", "bm", DO_NOT_QUIT,"move_arbitrary_npc"),
	("Func_d209", "", DO_NOT_QUIT,""),
	("Func_d38f", "b", DO_NOT_QUIT,""),
	("Func_d396", "b", DO_NOT_QUIT,""),
	("Func_cd76", "", DO_NOT_QUIT,""),
	("Func_d39d", "b", DO_NOT_QUIT,""),
	("Func_d3b9", "", DO_NOT_QUIT,""),
	("ScriptCommand_TryGivePCPack", "b", DO_NOT_QUIT,"try_give_pc_pack"),
	("ScriptCommand_nop", "", DO_NOT_QUIT,"script_nop"),
	("Func_d3d4", "q", DO_NOT_QUIT,""),
	("Func_d3e0", "", DO_NOT_QUIT,""),
	("Func_d3fe", "q", DO_NOT_QUIT,""),
	("Func_d408", "b", DO_NOT_QUIT,""),
	("Func_d40f", "q", DO_NOT_QUIT,""),
	("ScriptCommand_PlaySFX", "b", DO_NOT_QUIT,"play_sfx"),
	("ScriptCommand_PauseSong", "", DO_NOT_QUIT,"pause_song"),
	("ScriptCommand_ResumeSong", "", DO_NOT_QUIT,"resume_song"),
	("Func_d41d", "", DO_NOT_QUIT,""),
	("ScriptCommand_WaitForSongToFinish", "", DO_NOT_QUIT,"wait_for_song_to_finish"),
	("Func_d435", "b", DO_NOT_QUIT,""),
	("ScriptCommand_AskQuestionJumpDefaultYes", "tj", DO_NOT_QUIT,"ask_question_jump_default_yes"),
	("ScriptCommand_ShowSamNormalMultichoice", "", DO_NOT_QUIT,"show_sam_normal_multichoice"),
	("ScriptCommand_ShowSamTutorialMultichoice", "", DO_NOT_QUIT,"show_sam_tutorial_multichoice"),
	("Func_d43d", "", DO_NOT_QUIT,""),
	("ScriptCommand_EndScriptLoop2", "", QUIT_CONTINUE_CODE,"end_script_loop_2"),
	("ScriptCommand_EndScriptLoop3", "", QUIT_CONTINUE_CODE,"end_script_loop_3"),
	("ScriptCommand_EndScriptLoop4", "", QUIT_CONTINUE_CODE,"end_script_loop_4"),
	("ScriptCommand_EndScriptLoop5", "", QUIT_CONTINUE_CODE,"end_script_loop_5"),
	("ScriptCommand_EndScriptLoop6", "", QUIT_CONTINUE_CODE,"end_script_loop_6"),
	("ScriptCommand_SetFlagValue", "fb", DO_NOT_QUIT,"script_set_flag_value"),
	("ScriptCommand_JumpIfFlagZero1", "fj", DO_NOT_QUIT,"jump_if_flag_zero_1"),
	("ScriptCommand_JumpIfFlagNonzero1", "fj", DO_NOT_QUIT,"jump_if_flag_nonzero_1"),
	("ScriptCommand_JumpIfFlagEqual", "fbj", DO_NOT_QUIT,"jump_if_flag_equal"),
	("ScriptCommand_JumpIfFlagNotEqual", "fbj", DO_NOT_QUIT,"jump_if_flag_not_equal"),
	("ScriptCommand_JumpIfFlagNotLessThan", "fbj", DO_NOT_QUIT,"jump_if_flag_not_less_than"),
	("ScriptCommand_JumpIfFlagLessThan", "fbj", DO_NOT_QUIT,"jump_if_flag_less_than"),
	("ScriptCommand_MaxOutFlagValue", "f", DO_NOT_QUIT,"max_out_flag_value"),
	("ScriptCommand_ZeroOutFlagValue", "f", DO_NOT_QUIT,"zero_out_flag_value"),
	("ScriptCommand_JumpIfFlagNonzero2", "fj", DO_NOT_QUIT,"jump_if_flag_nonzero_2"),
	("ScriptCommand_JumpIfFlagZero2", "fj", DO_NOT_QUIT,"jump_if_flag_zero_2"),
	("ScriptCommand_IncrementFlagValue", "f", DO_NOT_QUIT,"increment_flag_value"),
	("ScriptCommand_EndScriptLoop7", "q", QUIT_CONTINUE_CODE,"end_script_loop_7"),
	("ScriptCommand_EndScriptLoop8", "q", QUIT_CONTINUE_CODE,"end_script_loop_8"),
	("ScriptCommand_EndScriptLoop9", "q", QUIT_CONTINUE_CODE,"end_script_loop_9"),
	("ScriptCommand_EndScriptLoop10", "q", QUIT_CONTINUE_CODE,"end_script_loop_10")
	]

main()
