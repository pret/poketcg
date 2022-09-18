import argparse
import mmap
from math import floor as floor

parser = argparse.ArgumentParser(description='Extracts compressed data.')
parser.add_argument('offsets', metavar='offsets', type=str, nargs='+',
                    help='start offset(s) of the compressed data')
parser.add_argument('-s', metavar='suffix', dest='suffix', type=str, nargs=1, default=[],
                    help='suffix for output file names')
parser.add_argument('-d', dest='decompress', action='store_true',
                    help='whether the output file should be decompressed')

args = parser.parse_args()

def getByteString(offset, len):
    with open('baserom.gbc') as rom:
        romMap = mmap.mmap(rom.fileno(), 0, access=mmap.ACCESS_READ)
        return romMap[offset : offset + len]

def getByte(offset):
    return getByteString(offset, 1)[0]

def getFormattedOffset(offset):
    return '{:0x}'.format(offset)

def convertWordToInt(byteArr):
    assert(len(byteArr) == 2)
    return byteArr[1] * 0x100 + byteArr[0]

def getCompressedData(offset):
    data = []
    pos = offset # init current position
    repeatToggle = False
    lenByte = 0x00

    size = convertWordToInt(getByteString(pos, 2))
    #data.extend(getByteString(pos, 2)) don't append size bytes to output
    pos += 2

    while (size > 0):
        cmdByte = getByte(pos)
        pos += 1
        data.append(cmdByte)
        print('{:0x}'.format(cmdByte))

        for bit in range(8):
            if (cmdByte & (1 << (7 - bit)) != 0):
                # copy one byte literally
                data.append(getByte(pos))
                pos += 1
                size -= 1
            else:
                # copy previous sequence
                data.append(getByte(pos))
                pos += 1

                repeatToggle = not repeatToggle
                if (repeatToggle):
                    # sequence length
                    lenByte = getByte(pos)
                    data.append(lenByte)
                    pos += 1
                    size -= (lenByte >> 4) + 2
                else:
                    # no sequence length byte if toggle is off
                    size -= (lenByte & 0x0f) + 2

            assert(size >= 0)

            # the decompression might finish while still
            # reading command bits, so break early when this happens
            if (size == 0):
                if not repeatToggle:
                    # extra bytes to match source
                    data.append(getByte(pos))
                    data.append(getByte(pos + 1))

                break

    return bytes(data)

def decompressData(source):
    buffer = [0x00 for i in range(0x100)]
    sourcePos = 0
    bufferPos = 0xef
    lenByte = 0x00
    repeatToggle = False

    decompData = [] # final decompressed data that will be output

    while True:
        if sourcePos >= len(source):
            # got to the end of the data
            break

        cmdByte = source[sourcePos]
        sourcePos += 1

        for cmdBit in range(8):
            if sourcePos >= len(source):
                # got to the end of the data
                break

            if (cmdByte & (1 << (7 - cmdBit)) != 0):
                # copy one byte literally
                byteToCopy = source[sourcePos]

                decompData.append(byteToCopy)
                buffer[bufferPos] = byteToCopy
                sourcePos += 1
                bufferPos = (bufferPos + 1) % 0x100
            else:
                # copy previous sequence
                repeatToggle = not repeatToggle

                if (repeatToggle):
                    # sequence length
                    offsetToCopy = source[sourcePos]
                    lenByte = source[sourcePos + 1]
                    bytesToCopy = []

                    curLen = (lenByte >> 4) + 2
                    for i in range(curLen):
                        buffer[bufferPos] = buffer[offsetToCopy]
                        bytesToCopy.append(buffer[offsetToCopy])
                        offsetToCopy = (offsetToCopy + 1) % 0x100
                        bufferPos = (bufferPos + 1) % 0x100

                    decompData.extend(bytesToCopy)
                    sourcePos += 2
                else:
                    # no sequence length byte if toggle is off
                    offsetToCopy = source[sourcePos]
                    bytesToCopy = []

                    curLen = (lenByte & 0x0f) + 2
                    for i in range(curLen):
                        buffer[bufferPos] = buffer[offsetToCopy]
                        bytesToCopy.append(buffer[offsetToCopy])
                        offsetToCopy = (offsetToCopy + 1) % 0x100
                        bufferPos = (bufferPos + 1) % 0x100

                    decompData.extend(bytesToCopy)
                    sourcePos += 1

    return bytes(decompData)

def outputData(offset, filename, decompress):
    comprData = getCompressedData(offset)
    data = []
    if decompress:
        data = decompressData(comprData)
    else:
        data = comprData

    with open(filename + '.bin', 'wb') as outFile:
        outFile.write(data)

n = 1
for offsetStr in args.offsets:
    offset = int(offsetStr, 16)
    filename = 'compressed_data_' + getFormattedOffset(offset)
    if (args.suffix):
        filename = args.suffix[0]
        if (len(args.offsets) > 1):
            filename = filename + str(n)
    outputData(offset, filename, args.decompress)
    n += 1
