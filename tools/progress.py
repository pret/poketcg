#!/usr/bin/env python3#
import subprocess
import math
import argparse

# TODO - 
# -- reportINCROMs --
	# add in percentage
# -- reportUnnamedSymbols --

# global vals
banks = 0x40

def main():
	parser = argparse.ArgumentParser(description='Progress checker for poketcg')
	parser.add_argument('-i', '--incrom', action='store_true', help="Turns on incrom report")
	parser.add_argument('-d', '--directory', default=".", help="Override incrom search directory. Ignores if incrom report is off")
	parser.add_argument('-s', '--symfile', default=None, type=argparse.FileType('r'), help="Turns on Unnamed Symbol report using given sym file")
	parser.add_argument('-f', '--function_source', action='store_true', help='Shows a breakdown of what bank each unnamed function comes from. Ignores if symfile report is off')
	parser.add_argument('-o', '--other_unnamed', action='store_true', help='Shows all other unnamed symbols and a count of how many there are. Ignores if symfile report is off')
	parser.add_argument('--list_funcs', nargs="+", default=None, help="Lists every unnamed function in the given banks. WILL BE LONG. ignores if symfile report is off")

	args = parser.parse_args()

	if args.incrom:
		reportINCROMs(args.directory)
		print("\n")

	if args.symfile != None:
		# parse the list command
		listBankSet = set([])
		if args.list_funcs != None:
			listBankSet = parseBankList(args.list_funcs)
		reportUnnamedSymbols(args.symfile,listBankSet, args.function_source, args.other_unnamed)

def reportINCROMs(incromDir):
	grepProc = subprocess.Popen(['grep', '-r', 'INCROM', incromDir], stdout=subprocess.PIPE)
	targetLines = grepProc.communicate()[0].decode().split('\n')
	incromBytes = [0]*banks
	incromByteTotal = 0
	for line in targetLines:
		line = line.lower() # ignore case

		# ignore the actual definition of the macro
		if 'macro' in line:
			continue

		# ignore anything in tools
		if '/tools/' in line:
			continue

		# ignore binary files in case swp's exist
		if 'binary file' in line:
			continue

		# find the last two hex location values
		splitLine = line.split("$")

		# not sure what the line is, but it's not working so skip
		if len(splitLine) < 3:
			continue

		incEnd = int(splitLine[-1],16)
		incStart = int(splitLine[-2].split(",",1)[0],16)
		incBank = math.floor(incStart / 0x4000)
		diff = incEnd - incStart
		incromBytes[incBank] += diff
		incromByteTotal += diff
	print("Total: " + str(incromByteTotal) + " bytes")
	print("Made up of the following: ")
	for i in range(0,banks):
		if incromBytes[i] == 0:
			continue

		bankName= "bank" + format(i,"02x") + ": "
		if i == 0:
			bankName = "home:   "
		bytesString = str(incromBytes[i])
		formattingStrings = " "*(8-len(bytesString)) 
		print(bankName + bytesString + formattingStrings + "bytes")


# reads sym files and looks for instances of tcgdisasm's automatic symbols
def reportUnnamedSymbols(symfile, listBankSet, showFunctionBanks, showOtherUnnamed):
	data = symfile.read().split("\n")

	# format [ [ "type" : number ], ... ]
	typeCounts = []

	# to cut back on for loops I'll manually list the super common ones, such as Func
	funcCounts = [0]*banks
	funcCount = 1
	branchCount = 0
	wramCount = 0
	sramCount = 0
	hramCount = 0

	labelTotal = 0
	localLabelTotal = 0
	unnamedLocalLabelTotal = 0
	unnamedLabelTotal = 0

	# expecting all lines to be formated as `bank:addr name`
	for line in data:

		splitline = line.split(":")

		# line not formatted as expected
		if len(splitline) < 2:
			continue

		# at this point it's probably some form of label
		if "." in line:
			localLabelTotal += 1
		else:
			labelTotal += 1

		bank = int(splitline[0], 16)
		splitline = splitline[1].split(" ")

		# line not formatted as expected
		if len(splitline) < 2:
			continue

		localAddr = int(splitline[0], 16)
		name = splitline[1]

		globalAddr = bank*0x4000 + localAddr
		if bank > 0:
			globalAddr -= 0x4000
		
		globalAddrString = format(globalAddr,"04x")
		if name.endswith(globalAddrString):

			# don't pay as much attention to local labels
			if "." in line:
				unnamedLocalLabelTotal += 1
				continue
			else:
				unnamedLabelTotal += 1

			labelType = name[0:len(globalAddrString)*-1]

			# take care of the common ones before looping
			if labelType == "Func_":
				if bank in listBankSet:
					print("bank " + format(bank,'02x') + ":" + name)
				funcCounts[bank] += 1
				funcCount += 1
				continue
			elif labelType == "Branch_":
				branchCount += 1
				continue
			elif labelType == "w":
				wramCount += 1
				continue
			elif labelType in ["s0","s1","s2","s3"]: # all that are listed in sram.asm
				sramCount += 1
				continue
			elif labelType == "h":
				hramCount += 1
				continue

			foundType = False
			for tc in typeCounts:
				if tc[0] == labelType:
					tc[1] += 1
					foundType = True

			if not foundType:
				typeCounts.append([labelType,1])
					

	# there are so many that I did them manually, but they're a misc type
	typeCounts.append(["Branch_", branchCount])

	# do some sorting.
	typeCounts = sorted(typeCounts, key = lambda x: x[1], reverse = True) 

	namedLabelTotal = labelTotal - unnamedLabelTotal
	namedLabelPercent = round((namedLabelTotal / labelTotal)*100, 3)
	namedLocalLabelTotal = localLabelTotal - unnamedLocalLabelTotal
	namedLocalLabelPercent = round((namedLocalLabelTotal / localLabelTotal)*100, 3)

	print("Named Labels: " + str(namedLabelTotal) + "/" + str(labelTotal) + " (" + str(namedLabelPercent) + "%)")
	print("Named Local Labels: " + str(namedLocalLabelTotal) + "/" + str(localLabelTotal) + " (" + str(namedLocalLabelPercent) + "%)")
	print()
	print("func count:   " + str(funcCount))
	if showFunctionBanks:
		for i in range(0,banks):
			if funcCounts[i] == 0:
				continue
			bank = "bank" + format(i,"02x") + ":"
			if i == 0:
				bank = "home:  "
			print("\t" + bank + " " + str(funcCounts[i]))

	print("wram count:   " + str(wramCount))
	print("sram count:   " + str(sramCount))
	print("hram count:   " + str(hramCount))
	if showOtherUnnamed:
		print()
		print("Additional types:")

		for tc in typeCounts:
			spaces = " " * (30 - len(tc[0]))
			if tc[1] == 1:
				print(tc[0])
				continue
			print(tc[0] + spaces + "x" + format(tc[1],"02"))

def parseBankList(strList):
	retSet = set([])
	for bankName in strList:
		if bankName == "home":
			retSet.add(0)
		elif bankName.startswith("bank"):
			retSet.add(int(bankName[4:],16))
		else:
			retSet.add(int(bankName,0))
	return retSet


if __name__ == '__main__':
	main()
