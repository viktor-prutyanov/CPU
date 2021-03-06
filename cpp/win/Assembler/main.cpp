#include <stdio.h>
#include <stdlib.h>
#include <io.h>

#include "TokenArray.h"

#define FLASH_SIZE 256

int main(int argc, char *argv[]) 
{
    if (argc != 4)
    {
        printf("Usage:\n\tAssembler <input file> <output bin file> <output hex file>\n");
#ifdef _DEBUG
            system("pause");
#endif
        return EXIT_FAILURE;
    }

    FILE *asmFile = fopen(argv[1], "rb");
    if (asmFile == nullptr)
    {
        printf("Invalid input file (%s).\n", argv[1]);
#ifdef _DEBUG
            system("pause");
#endif
        return EXIT_FAILURE;
    }
    printf("Length of %s is %lu bytes.\n", argv[1], _filelength(_fileno(asmFile)));
    TokenArray tokenList(asmFile, _filelength(_fileno(asmFile)));
    fclose(asmFile);
    tokenList.ResolveLabels();
    tokenList.Dump();

	FILE *binFile = fopen(argv[2], "wb");
	if (binFile == nullptr)
	{
		printf("Can't open output file %s.\n", argv[2]);
#ifdef _DEBUG
			system("pause");
#endif
		return EXIT_FAILURE;
	}

    FILE *hexFile = fopen(argv[3], "wb");
    if (hexFile == nullptr)
    {
        printf("Can't open output file %s.\n", argv[3]);
#ifdef _DEBUG
        system("pause");
#endif
        return EXIT_FAILURE;
    }

    tokenList.Make() ? printf("Assemblied successfully.\n") : printf("Assembly failed.\n");
    printf("Size of Intel hex file is %lu bytes.\n", tokenList.MakeHex(hexFile));
    size_t binFileSize = tokenList.MakeBin(binFile);
    float percentFilled = binFileSize * 100.0 / FLASH_SIZE;
    printf("Size of binary image is %lu bytes / %lu bytes (%4.2f%%).\n", binFileSize, FLASH_SIZE, percentFilled);

	fclose(binFile);
    fclose(hexFile);

#ifdef _DEBUG
        system("pause");
#endif
    return EXIT_SUCCESS;
}