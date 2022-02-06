#include <stdio.h>
#include <stdlib.h>

int main(int argc, char **argv){
    FILE* f = fopen(argv[2], "w");
    if (!f){
        fprintf(stderr, "File <%s> cannot be opened.\n", argv[2]);
        exit(3);
    }
    unsigned short i = 0, altDur = 0, inAlt = 1;
    unsigned uo = strtol(argv[1], NULL, 0), ui = uo, altMax = uo;
    fprintf(f, "n, Un\n%hhu %u\n", i, ui);
    do{
        ui = ui % 2 ? ui * 3 + 1: ui / 2;
        if (ui > uo){
            altMax = alMax > ui ? altMax: ui;
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
    exit(EXIT_SUCCESS);
}
