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
###### q - Used when the script's arguments have not been determined yet ######
###############################################################################
import argparse

def decodeLine(scriptList, game_data, loc, ignore_broken, branchList):
	currLine = scriptList[game_data[loc]]
	ret = "\trun_script " + currLine[0] + "\n"
	loc+=1
	quit = currLine[2]
	for c in currLine[1]:
		if c == "b":
			ret += "\tdb $" + format(game_data[loc],"02x") + "\n"
			loc += 1
		elif c == "w":
			ret += "\tdw $" + format((game_data[loc] + (game_data[loc+1]<<8)),"04x") + "\n"
			loc += 2
		elif c == "j":
			wordLoc = (game_data[loc] + (game_data[loc+1]<<8))
			if wordLoc == 0000:
				ret += "\tdw NO_JUMP\n"
			else:
				ret += "\tdw .ows_" + format(wordLoc+0x8000,"04x") + "\n"
				branchList.append(wordLoc)
			loc += 2
		elif c == "t":
			ret += "\ttx Text" + format((game_data[loc] + (game_data[loc+1]<<8)),"04x") + "\n"
			loc += 2
		elif c == "q":
			print("haven't updated data for this yet")
			if not ignore_broken:
				quit = True
		else:
			print("UNACCEPTED CHARACTER: " + c)
	return (loc, ret, quit)

def main():
	scriptList = createList()
	branchList = []

	parser = argparse.ArgumentParser(description='Pokemon TCG Script Extractor')
	parser.add_argument('--noauto', action='store_true', help='turns off automatic script parsing')
	parser.add_argument('--error', action='store_true', help='stops execution if an error occurs')
	parser.add_argument('location', help='location to extract from. May be local to bank or global.')
	args = parser.parse_args()
	loc = int(args.location,0)
	if loc > 0x7fff:
		# Must be a global location
		loc -= 0x8000
	branchList.append(loc)

	with open("tcg.gbc", "rb") as file:
	    game_data = file.read()
	auto = True
	end = False
	ignore_broken = True
	while (len(branchList) > 0):
		loc = branchList.pop(0) + 0x8000
		printScript(game_data, loc, auto, end, ignore_broken, scriptList, branchList)

def printScript(game_data, loc, auto, end, ignore_broken, scriptList, branchList):
	script = ""
	if game_data[loc] != 0xe7:
		#print("Error: first byte was not start_script")
		print(".ows_" + format(loc,"04x"))
	else:
 		
		# TODO this is hacky please don't do this 
		ls = format(loc,"04x")
		lsa = format(loc-0x8000,"04x")
		print("OWSequence_" + ls + ": ; " + ls + " (3:" + lsa + ")" )
		loc += 1
		print("\tstart_script")
	while not end:
		loc, outstr, end = decodeLine(scriptList,game_data,loc,ignore_broken,branchList)
		outstr = outstr[:-1] # [:-1] strips the newline at the end
		if auto:
			print(outstr)
		else:
			input(outstr)
	print("; " + hex(loc))
		

def createList(): # this is a func just so all this can go at the bottom
	# name, arg list, is an ender
	return [
	("OWScript_EndScriptLoop1", "", True),
	("OWScript_CloseAdvancedTextBox", "", False),
	("OWScript_PrintTextString", "t", False),
	("Func_ccdc", "bb", False),
	("OWScript_AskQuestionJump", "tj", False), # more complex behavior too (jumping)
	("OWScript_StartBattle", "bbb", False),
	("OWScript_PrintVariableText", "tt", False),
	("Func_cda8", "bbbb", False),
	("OWScript_PrintTextCloseBox", "t", True),
	("Func_cdcb", "", False),
	("Func_ce26", "bb", False),
	("OWScript_CloseTextBox", "", False),
	("OWScript_GiveBoosterPacks", "bbb", False),
	("Func_cf0c", "bbb", False), # more complex behavior too (jumping)
	("Func_cf12", "bbb", False),
	("OWScript_GiveCard", "b", False),
	("OWScript_TakeCard", "b", False),
	("Func_cf53", "w", False), # more complex behavior too (jumping)
	("Func_cf7b", "", False),
	("Func_cf2d", "bbbb", False), # more complex behavior too (jumping + ??)
	("Func_cf96", "w", False), # only jumps? still needs args to do that though
	("Func_cfc6", "b", False),
	("Func_cfd4", "", False),
	("Func_d00b", "", False), # includes something with random and extra data
	("Func_d025", "w", False), # possibly only jumps, still needs args
	("Func_d032", "w", False), # see above
	("Func_d03f", "", False),
	("OWScript_Jump", "j", True), # jumps to d
	("Func_d04f", "", False),
	("Func_d055", "b", False),
	("OWScript_MovePlayer", "bb", False),
	("Func_cee2", "b", False),
	("OWScript_SetDialogName", "b", False),
	("Func_d088", "bw", False),
	("Func_d095", "bbb", False),
	("Func_d0be", "bb", False),
	("OWScript_DoFrames", "b", False),
	("Func_d0d9", "bbw", False), # jumps but still needs args
	("Func_d0f2", "bbw", False), # jumps but still needs args
	("Func_ce4a", "bb", False),
	("Func_ceba", "q", False),
	("Func_d103", "q", False),
	("Func_d125", "b", False),
	("Func_d135", "b", False),
	("Func_d16b", "q", False),
	("Func_cd4f", "q", False),
	("Func_cd94", "q", False),
	("Func_ce52", "q", False),
	("Func_cdd8", "q", False),
	("Func_cdf5", "q", False),
	("Func_d195", "q", False),
	("Func_d1ad", "", False),
	("Func_d1b3", "q", False),
	("OWScript_EndScriptCloseText", "", True), # it calls inc twice but it ends anyway?
	("Func_d244", "q", False),
	("Func_d24c", "q", False),
	("OWScript_OpenDeckMachine", "q", False),
	("Func_d271", "q", False),
	("Func_d36d", "bbbbb", False),
	("Func_ce6f", "bbb", False),
	("Func_d209", "q", False),
	("Func_d38f", "q", False),
	("Func_d396", "q", False),
	("Func_cd76", "q", False),
	("Func_d39d", "q", False),
	("Func_d3b9", "q", False),
	("OWScript_GivePCPack", "b", False),
	("Func_d3d1", "q", False),
	("Func_d3d4", "q", False),
	("Func_d3e0", "", False),
	("Func_d3fe", "q", False),
	("Func_d408", "q", False),
	("Func_d40f", "q", False),
	("Func_d416", "q", False),
	("Func_d423", "q", False),
	("Func_d429", "q", False),
	("Func_d41d", "", False),
	("Func_d42f", "q", False),
	("Func_d435", "b", False),
	("Func_cce4", "tj", False),
	("Func_d2f6", "q", False),
	("Func_d317", "q", False),
	("Func_d43d", "q", False),
	("OWScript_EndScriptLoop2", "q", True),
	("OWScript_EndScriptLoop3", "q", True),
	("OWScript_EndScriptLoop4", "q", True),
	("OWScript_EndScriptLoop5", "q", True),
	("OWScript_EndScriptLoop6", "q", True),
	("OWScript_SetFlagValue", "bb", False),
	("OWScript_JumpIfFlagZero1", "q", False),
	("OWScript_JumpIfFlagNonzero1", "q", False),
	("OWScript_JumpIfFlagEqual", "bbj", False), # also capable of jumping
	("OWScript_JumpIfFlagNotEqual", "bbj", False), # jumps
	("OWScript_JumpIfFlagNotLessThan", "bbj", False),
	("OWScript_JumpIfFlagLessThan", "bbj", False),
	("OWScript_MaxOutFlagValue", "b", False),
	("OWScript_ZeroOutFlagValue", "q", False),
	("OWScript_JumpIfFlagNonzero2", "bj", False),
	("OWScript_JumpIfFlagZero2", "bj", False),
	("OWScript_IncrementFlagValue", "b", False),
	("OWScript_EndScriptLoop7", "q", True),
	("OWScript_EndScriptLoop8", "q", True),
	("OWScript_EndScriptLoop9", "q", True),
	("OWScript_EndScriptLoop10", "q", True)
	]

main()
