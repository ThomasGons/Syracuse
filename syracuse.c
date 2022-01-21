#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define SYRACUSE(ui) (ui) % 2 ? (ui) * 3 + 1: (ui) / 2
#define MAX(a, b) (a) > (b) ? (a): (b)

unsigned charToUnsigned(char* p);
void syracuse(char **argv);

int main(int argc, char **argv){
    if (argc != 3){
        fprintf(stderr, "Bad usage: ./exe Uo filename.\n");
        exit(1);
    }
    if (!charToUnsigned(argv[1])){
        fprintf(stderr, "Please enter a strictly positive integer.");
        exit(EXIT_FAILURE);
    }
    syracuse(argv);
    exit(EXIT_SUCCESS);
}

unsigned charToUnsigned(char* p){
    unsigned n = 0;
    for (unsigned char i = 0; i < strlen(p); i++){
        if (p[i] >= 48 && p[i] <= 57)
            n = n * 10 + (p[i] % 48);
        else {
            fprintf(stderr, "%s is not a number or a positive integer.\n", p);
            exit(2);
        }
    }
    return n;
}

void syracuse(char **argv){
    FILE* f = fopen(argv[2], "w");
    if (!f){
        fprintf(stderr, "File <%s> cannot be opened.\n", argv[2]);
        exit(3);
    }
    unsigned short i = 0, altDur = 0, inAlt = 1;
    unsigned uo = charToUnsigned(argv[1]), ui = uo, altMax = uo;
    fprintf(f, "n, Un\n%hhu %u\n", i, ui);
    do{
        ui = SYRACUSE(ui);
        if (ui > uo){
            altMax = MAX(altMax, ui);
            if (inAlt)
                altDur++;
        }
        if (ui < uo)
            inAlt = 0;
        i++;
        fprintf(f, "%hhu %u\n", i, ui);
    } while(ui != 1);
    fprintf(f, "AltitudeMax: %u\nFlightDuration: %hhu\nAltitudeDuration: %hhu\n", altMax, i, altDur);
    fclose(f);
}
