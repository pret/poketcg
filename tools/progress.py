#!/usr/bin/env python3#
import subprocess
import math

# TODO - 
# -- reportINCROMs --
	# create switch
	# create optional grep location
	# add in percentage
# -- reportUnnamedSymbols --
	# create switch
	# take sym file as an argument

# this is not the best way to do it, by any means
def reportINCROMs():
	grepProc = subprocess.Popen(['grep', '-r', 'INCROM', '..'], stdout=subprocess.PIPE)
	targetLines = grepProc.communicate()[0].decode().split('\n')
	banks = 0x40
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
def reportUnnamedSymbols():
	with open("../tcg.sym") as symfile:
		data = symfile.read().split("\n")

	# format [ [ "type" : number ], ... ]
	typeCounts = []

	# to cut back on for loops I'll manually list the super common ones, such as Func
	funcCount = 0
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
	print("Func count:   " + str(funcCount))
	print("wram count:   " + str(wramCount))
	print("sram count:   " + str(sramCount))
	print("hram count:   " + str(hramCount))
	print()
	print("Additional types:")

	for tc in typeCounts:
		spaces = " " * (30 - len(tc[0]))
		print(tc[0] + spaces + "x" + format(tc[1],"02"))

reportINCROMs()
print()
print()
reportUnnamedSymbols()
