// page_sim.c — симулятор алгоритмів заміщення сторінок
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_REFS   100
#define MAX_FRAMES 10

void print_frames(int *frames, int num_frames) {
    printf("[ ");
    for (int i = 0; i < num_frames; i++) {
        if (frames[i] == -1)
            printf("-  ");
        else
            printf("%d  ", frames[i]);
    }
    printf("]");
}

// ================= FIFO =================
int simulate_fifo(int *refs, int n, int num_frames) {
    int frames[MAX_FRAMES];
    for (int i = 0; i < num_frames; i++) frames[i] = -1;

    int faults = 0;
    int next_victim = 0;

    for (int step = 0; step < n; step++) {
        int page = refs[step];

        // check hit
        int hit = 0;
        for (int i = 0; i < num_frames; i++) {
            if (frames[i] == page) {
                hit = 1;
                break;
            }
        }

        int victim = -1;

        if (!hit) {
            faults++;

            // знайти вільний слот
            int placed = 0;
            for (int i = 0; i < num_frames; i++) {
                if (frames[i] == -1) {
                    frames[i] = page;
                    placed = 1;
                    break;
                }
            }

            // якщо нема вільного — FIFO заміна
            if (!placed) {
                victim = frames[next_victim];
                frames[next_victim] = page;
                next_victim = (next_victim + 1) % num_frames;
            }
        }

        printf("%4d  %4d  ", step + 1, page);
        print_frames(frames, num_frames);

        if (hit)
            printf("    ВЛУЧЕННЯ\n");
        else if (victim == -1)
            printf("    ПРОМАХ\n");
        else
            printf("    ПРОМАХ (витіснено %d)\n", victim);
    }

    return faults;
}

// ================= LRU =================
int simulate_lru(int *refs, int n, int num_frames) {
    int frames[MAX_FRAMES];
    int last_used[MAX_FRAMES];

    for (int i = 0; i < num_frames; i++) {
        frames[i] = -1;
        last_used[i] = -1;
    }

    int faults = 0;

    for (int step = 0; step < n; step++) {
        int page = refs[step];

        int hit_index = -1;

        // check hit
        for (int i = 0; i < num_frames; i++) {
            if (frames[i] == page) {
                hit_index = i;
                break;
            }
        }

        int victim = -1;

        if (hit_index != -1) {
            last_used[hit_index] = step;
        } else {
            faults++;

            // знайти вільний слот
            int placed = 0;
            for (int i = 0; i < num_frames; i++) {
                if (frames[i] == -1) {
                    frames[i] = page;
                    last_used[i] = step;
                    placed = 1;
                    break;
                }
            }

            if (!placed) {
                int lru_index = 0;
                for (int i = 1; i < num_frames; i++) {
                    if (last_used[i] < last_used[lru_index]) {
                        lru_index = i;
                    }
                }

                victim = frames[lru_index];
                frames[lru_index] = page;
                last_used[lru_index] = step;
            }
        }

        printf("%4d  %4d  ", step + 1, page);
        print_frames(frames, num_frames);

        if (hit_index != -1)
            printf("    ВЛУЧЕННЯ\n");
        else if (victim == -1)
            printf("    ПРОМАХ\n");
        else
            printf("    ПРОМАХ (витіснено %d)\n", victim);
    }

    return faults;
}

// ================= MAIN =================
int main(int argc, char *argv[]) {
    if (argc < 4) {
        printf("Usage: %s <frames> fifo|lru ref1 ref2 ...\n", argv[0]);
        return 1;
    }

    int num_frames = atoi(argv[1]);
    char *algo = argv[2];

    int refs[MAX_REFS];
    int n = argc - 3;
    if (n > MAX_REFS) n = MAX_REFS;

    for (int i = 0; i < n; i++)
        refs[i] = atoi(argv[3 + i]);

    printf("Алгоритм: %s, Фреймів: %d, Звернень: %d\n", algo, num_frames, n);
    printf("Крок  Стор  Фрейми         Результат\n");

    int faults;

    if (strcmp(algo, "fifo") == 0)
        faults = simulate_fifo(refs, n, num_frames);
    else if (strcmp(algo, "lru") == 0)
        faults = simulate_lru(refs, n, num_frames);
    else {
        printf("Невідомий алгоритм\n");
        return 1;
    }

    printf("\nЗагалом page faults: %d\n", faults);
    return 0;
}