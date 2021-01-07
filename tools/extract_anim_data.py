import mmap
import math

def convertOffset(lo, hi, bank):
    return lo + ((hi << 8) - 0x4000) + (bank * 0x4000 + 0x20 * 0x4000)

def signedByteToInt(uByte):
    return (uByte, uByte - 0x100)[uByte >= 0x80]

def getOAMFlagStr(flags):
    strings = []
    if (flags == 0):
        strings.append('$0')
    if (flags & 0b111 != 0):
        strings.append('%{:03b}'.format(flags & 0b111))
    if (flags & (1 << 3) != 0):
        strings.append('(1 << OAM_TILE_BANK)')
    if (flags & (1 << 4) != 0):
        strings.append('(1 << OAM_OBP_NUM)')
    if (flags & (1 << 5) != 0):
        strings.append('(1 << OAM_X_FLIP)')
    if (flags & (1 << 6) != 0):
        strings.append('(1 << OAM_Y_FLIP)')
    if (flags & (1 << 7) != 0):
        strings.append('(1 << OAM_PRIORITY)')

    return ' | '.join(s for s in strings)

def getAnimData():
    with open('baserom.gbc') as rom:
        romMap = mmap.mmap(rom.fileno(), 0, access=mmap.ACCESS_READ)
        offsets = []

        for i in range(0xd9):
            lineOffset = 0x81333 + 4*i
            lo = romMap[lineOffset]
            hi = romMap[lineOffset + 1]
            bank = romMap[lineOffset + 2]
            offsets.append([convertOffset(lo, hi, bank), i])

        animData = {}
        animFrameTables = {}
        frameData = {}

        for offset in offsets:
            header = romMap[offset[0] : offset[0] + 3]

            pos = offset[0] + 3
            data = []
            data.append(romMap[pos : pos + 4])
            pos += 4
            while (data[-1][0] != 0x00 or data[-1][1] != 0x00):
                data.append(romMap[pos : pos + 4])
                pos += 4

            maxFrame = 0
            for curFrameData in data:
                if (curFrameData[0] != 0xff):
                    maxFrame = max(curFrameData[0], maxFrame)

            frameOffset = convertOffset(header[1], header[2], header[0])
            pointers = []
            tableAlreadyExists = frameOffset in animFrameTables

            for i in range(maxFrame + 1):
                pointers.append(romMap[frameOffset + 2*i : frameOffset + 2*i + 2])

            if tableAlreadyExists:
                if len(pointers) > len(animFrameTables[frameOffset]):
                    if (frameOffset != 0xab066): # special case, seems this is wrong
                        animFrameTables[frameOffset] = pointers
            else:
                animFrameTables[frameOffset] = pointers
            
            animData[offset[0]] = [header, data, offset[1]]

        for offset in animFrameTables:
            curFrameData = []
            for ptr in animFrameTables[offset]:
                curOffset = convertOffset(ptr[0], ptr[1], math.floor(offset / 0x4000 - 0x20))
                numTiles = romMap[curOffset]
                curFrameData.append([curOffset, romMap[curOffset : curOffset + numTiles*4 + 1]])
            frameData[offset] = curFrameData

        return animData, animFrameTables, frameData


animData, animFrameTables, frameData = getAnimData()

pointerIndices = {}
counter = 0
for offset in animFrameTables:
    pointerIndices[offset] = counter
    counter += 1

allOffsets = []

for offset in animData:
    allOffsets.append(offset)
for offset in animFrameTables:
    allOffsets.append(offset)

allOffsets = sorted(allOffsets)

for offset in allOffsets:
    size = 0
    if offset in animData:
        header = animData[offset][0]
        data = animData[offset][1]
        print('AnimData' + str(animData[offset][2]) + ':: ; ' + "{:0x}".format(offset) + ' (' + "{:0x}".format((math.floor(offset / 0x4000))) + ':' + "{:04x}".format(offset % 0x4000 + 0x4000) + ')') 
        print('\tframe_table ' + 'AnimFrameTable' + str(pointerIndices[convertOffset(header[1], header[2], header[0])]))
        for curData in data:
            print('\tframe_data ' + ', '.join(str(signedByteToInt(x)) for x in curData))
        size = len(header) + len(data) * 4

    if offset in animFrameTables:
        print('AnimFrameTable' + str(pointerIndices[offset]) + ':: ; ' + "{:0x}".format(offset) + ' (' + "{:0x}".format((math.floor(offset / 0x4000))) + ':' + "{:04x}".format(offset % 0x4000 + 0x4000) + ')') 
        for curFrameData in frameData[offset]:
            print('\tdw .data_' + "{:0x}".format(curFrameData[0]))
            size += 2
        for curFrameData in frameData[offset]:
            numTiles = curFrameData[1][0]
            print()
            print('.data_' + "{:0x}".format(curFrameData[0]))
            print('\tdb ' + str(numTiles) + ' ; size')
            size += 1
            for i in range(numTiles):
                print('\tdb ' + str(signedByteToInt(curFrameData[1][4*i + 1])) + ', ' + str(signedByteToInt(curFrameData[1][4*i + 2])) + ', ' + str(curFrameData[1][4*i + 3]) + ', ' + getOAMFlagStr(curFrameData[1][4*i + 4]))
                size += 4

    print('; ' + "0x{:0x}".format(offset + size))
    print()

    if (offset + size) not in allOffsets:
        print('\tINCROM ' + "${:0x}".format(offset + size) + ', ')
        print()