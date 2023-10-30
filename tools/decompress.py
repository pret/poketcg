import os
import argparse

parser = argparse.ArgumentParser(description='Decompresses compressed files.')
parser.add_argument('filenames', metavar='filenames', type=str, nargs='+')

args = parser.parse_args()

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

for filename in args.filenames:
    source = bytearray(open(filename, 'rb').read())
    with open(os.path.splitext(filename)[0], 'wb') as outFile:
        outFile.write(decompressData(source))
