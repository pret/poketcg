#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include <errno.h>

#define MAX_FILE_SIZE   0x8000

struct Dimensions
{
    unsigned width;
    unsigned height;
};

void usage(const char *programName)
{
    fprintf(stderr, "Usage: %s <source file> <output>\n\n", programName);
    fputs("Interleaves tile and attribute bytes according to map dimensions.\n", stderr);
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

struct Dimensions getDimensions(const char *dimFilename)
{
    struct Dimensions dimensions;
    FILE *fd = fopen(dimFilename, "rb");
    if (fd != NULL)
    {
        dimensions.width = fgetc(fd);
        dimensions.height = fgetc(fd);
        fclose(fd);
    }
    return dimensions;
}

int main(int argc, char *argv[])
{
    const char *programName = argv[0];

    if (argc != 4)
    {
        usage(programName);
        return 1;
    }

    const char *inFilename = argv[1];
    const char *dimFilename = argv[2];
    const char *outFilename = argv[3];

    const struct Dimensions dimensions = getDimensions(dimFilename);

    unsigned fileSize;
    int *fileBuffer = readFileToBuffer(inFilename, &fileSize);
    if (fileBuffer == NULL)
    {
        fprintf(stderr, "Error: %d (%s)\n", errno, strerror(errno));
        return 1;
    }

    if (fileSize != dimensions.width * dimensions.height * 2)
    {
        fprintf(stderr, "Error, dimensions don't match the map data size: dimensions = %dx%d, file size = %d\n", dimensions.width, dimensions.height, fileSize);
        return 1;
    }

    int *outBuffer = (int*) malloc(fileSize * sizeof(int));
    unsigned idx = 0;
    for (unsigned h = 0; h < dimensions.height; h++)
    {
        for (unsigned w = 0; w < dimensions.width; w++)
        {
            outBuffer[dimensions.width * (2 * h + 0) + w] = fileBuffer[idx++];
            outBuffer[dimensions.width * (2 * h + 1) + w] = fileBuffer[idx++];
        }
    }

    FILE *fo = fopen(outFilename, "wb");
    for (unsigned i = 0; i < fileSize; i++)
        fputc(outBuffer[i], fo);

    free(fileBuffer);
    free(outBuffer);

    return 0;
}
