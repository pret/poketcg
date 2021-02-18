import argparse
import mmap
from math import floor as floor

parser = argparse.ArgumentParser(description='Extracts compressed data.')
parser.add_argument('offsets', metavar='offsets', type=str, nargs='+',
                    help='start offset(s) of the compressed data')
parser.add_argument('-s', metavar='suffix', dest='suffix', type=str, nargs=1, default=[],
                    help='suffix for output file names')

args = parser.parse_args()

def getByteString(offset, len):
    with open('baserom.gbc') as rom:
        romMap = mmap.mmap(rom.fileno(), 0, access=mmap.ACCESS_READ)
        return romMap[offset : offset + len]

def getByte(offset):
    return getByteString(offset, 1)[0]

def convertOffset(ptrBytes, offset):
    bank = floor(offset / 0x4000)
    return (ptrBytes[0] + (ptrBytes[1] << 8)) + bank * 0x4000 - 0x4000

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

        for b in range(8):
            if (cmdByte & (1 << (7 - b)) != 0):
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
                break

    return bytes(data)

def outputData(offset, filename):
    with open(filename + '.bin', 'wb') as outFile:
        outFile.write(getCompressedData(offset))

n = 1
for offsetStr in args.offsets:
    offset = int(offsetStr, 16)
    filename = 'compressed_data_' + getFormattedOffset(offset)
    if (args.suffix):
        filename = args.suffix[0]
        if (len(args.offsets) > 1):
            filename = filename + str(n)
    outputData(offset, filename)
    n += 1
