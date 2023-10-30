#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include <errno.h>

#define MAX_FILE_SIZE   0x8000
#define BUFFER_SIZE     0x100
#define INITIAL_POS     0xef
#define MAX_RUN_LENGTH  (0xf + 2)

enum Mode
{
    LOOK_BACK,
    LITERAL_COPY
};

struct Command
{
    enum Mode mode;
    unsigned length;
    int data; // either the offset or the byte to copy
};

void usage(const char *programName)
{
    fprintf(stderr, "Usage: %s [<options>] <source file> <output>\n\n", programName);
    fputs("Compression options:\n", stderr);
    fputs("    -m, --matching   Uses matching compressed data instead of\n", stderr);
    fputs("                     generating it. This will detect a corresponding\n", stderr);
    fputs("                     \"*.match\" file in the same directory for matching.\n", stderr);
}

void fileCopy(FILE *f1, FILE *f2)
{
    while (true)
    {
        int c = fgetc(f1);
        if (feof(f1))
            break;
        fputc(c, f2);
    }
}

int *readFileToBuffer(const char *inFilename, unsigned *fileSize)
{
    FILE *fi = fopen(inFilename, "rb");
    if (fi == NULL)
        return NULL;

    int *fileBuffer = (int*) malloc(MAX_FILE_SIZE * sizeof(int));
    for (unsigned i = 0; i < MAX_FILE_SIZE; i++)
    {
        int c = fgetc(fi);
        if (feof(fi))
        {
            *fileSize = i;
            break;
        }
        fileBuffer[i] = c;
    }

    fclose(fi);
    return fileBuffer;
}

struct Command* generateCommands(int *fileBuffer, unsigned fileSize, unsigned *numCmds)
{
    struct Command *cmds = (struct Command*) malloc(0x10 * BUFFER_SIZE * sizeof(struct Command));
    *numCmds = 0;

    int *uncompressedBuffer = (int*) calloc(BUFFER_SIZE, sizeof(int));
    int *tempUncompressedBuffer = (int*) malloc(BUFFER_SIZE * sizeof(int));
    unsigned pos = 0;

    while (true)
    {
        if (pos == fileSize)
            break;

        unsigned maxRunLen = 0;
        unsigned maximalOffset = 0;

        for (unsigned i = 1; i < BUFFER_SIZE; i++)
        {
            unsigned curRunLen = 0;
            memcpy(tempUncompressedBuffer, uncompressedBuffer, BUFFER_SIZE * sizeof(int));

            for (unsigned j = 0; j < MAX_RUN_LENGTH; j++)
            {
                if (pos + j == fileSize)
                    break;

                if (fileBuffer[pos + j] != tempUncompressedBuffer[(pos + INITIAL_POS - i + j) % BUFFER_SIZE])
                    break;

                tempUncompressedBuffer[(pos + INITIAL_POS + j) % BUFFER_SIZE] = fileBuffer[pos + j];
                curRunLen++;
            }

            if (curRunLen > maxRunLen)
            {
                maxRunLen = curRunLen;
                maximalOffset = (pos + INITIAL_POS - i) % BUFFER_SIZE;
            }
        }

        // store this new command
        struct Command cmd;
        if (maxRunLen >= 2)
        {
            cmd.mode = LOOK_BACK;
            cmd.length = maxRunLen;
            cmd.data = maximalOffset;
        }
        else
        {
            cmd.mode = LITERAL_COPY;
            cmd.data = fileBuffer[pos];
        }

        cmds[(*numCmds)++] = cmd;

        // update uncompressed buffer
        if (maxRunLen >= 2)
        {
            for (unsigned i = 0; i < maxRunLen; i++)
            {
                uncompressedBuffer[(pos + INITIAL_POS + i) % BUFFER_SIZE] = fileBuffer[pos + i];
            }
            pos += maxRunLen;
        }
        else
        {
            uncompressedBuffer[(pos + INITIAL_POS) % BUFFER_SIZE] = fileBuffer[pos];
            pos++;
        }
    }

    free(uncompressedBuffer);
    free(tempUncompressedBuffer);
    return cmds;
}

void outputCompressedData(int *fileBuffer, unsigned fileSize, const char *outFilename)
{
    unsigned numCmds;
    struct Command *cmds = generateCommands(fileBuffer, fileSize, &numCmds);

    // store command bytes
    const unsigned numCmdBytes = ((numCmds % 8) == 0)
                            ? numCmds / 8
                            : (numCmds / 8) + 1;
    int *cmdBytes = (int*) malloc(numCmdBytes * sizeof(int));
    int *lookBackLengths = (int*) malloc(numCmds * sizeof(int));
    unsigned numLookBacks = 0;

    for (unsigned i = 0; i < numCmdBytes; i++)
    {
        int cmdByte = 0x00;
        for (unsigned j = 0; j < 8; j++)
        {
            const unsigned index = 8*i + j;
            if (index >= numCmds)
                break;

            switch (cmds[index].mode)
            {
                case LITERAL_COPY:
                    cmdByte |= (1 << (7 - j));
                break;
                case LOOK_BACK:
                    lookBackLengths[numLookBacks++] = cmds[index].length;
                break;
            }
        }

        cmdBytes[i] = cmdByte;
    }

    FILE *fo = fopen(outFilename, "wb");

    unsigned curLookBack = 0;

    for (unsigned i = 0; i < numCmds; i++)
    {
        if (i % 8 == 0)
            fputc(cmdBytes[i / 8], fo);

        switch (cmds[i].mode)
        {
            case LITERAL_COPY:
            {
                fputc(cmds[i].data, fo);
            }
            break;
            case LOOK_BACK:
            {
                fputc(cmds[i].data, fo);

                if (curLookBack % 2 == 0)
                {
                    int lengthByte = (lookBackLengths[curLookBack] - 2) << 4;
                    if (curLookBack + 1 < numLookBacks)
                        lengthByte |= lookBackLengths[curLookBack + 1] - 2;
                    fputc(lengthByte, fo);
                }

                curLookBack++;
            }
            break;
        }
    }

    fclose(fo);

    free(cmds);
    free(cmdBytes);
    free(lookBackLengths);
}

int main(int argc, char *argv[])
{
    const char *programName = argv[0];

    if (argc < 3 || argc > 4)
    {
        usage(programName);
        return 1;
    }

    const bool matching = (strcmp(argv[1], "-m") == 0) || (strcmp(argv[1], "--matching") == 0);
    const char *inFilename = argv[argc - 2];
    const char *outFilename = argv[argc - 1];

    if (matching)
    {
        char *matchFilename = (char*) malloc((strlen(outFilename) + strlen(".match") + 1) * sizeof(char));
        strcpy(matchFilename, outFilename);
        strcat(matchFilename, ".match");

        FILE *fm = fopen(matchFilename, "rb");
        if (fm != NULL)
        {
            FILE *fo = fopen(outFilename, "wb");
            fileCopy(fm, fo);
            fclose(fm);
            fclose(fo);
            return 0;
        }

        free(matchFilename);
    }

    unsigned fileSize;
    int *fileBuffer = readFileToBuffer(inFilename, &fileSize);
    if (fileBuffer == NULL)
    {
        printf("Error: %d (%s)\n", errno, strerror(errno));
        return 1;
    }

    outputCompressedData(fileBuffer, fileSize, outFilename);

    free(fileBuffer);

    return 0;
}
