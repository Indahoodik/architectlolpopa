// cache_test.c — послідовний vs випадковий обхід масиву
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define SIZE (4 * 1024 * 1024)   // 4M елементів = 16 MB (більше за L3 cache)
#define ITERS 10                  // повторити для стабільності

int main(int argc, char *argv[]) {
    if (argc < 2) {
        printf("Usage: %s seq|rand\n", argv[0]);
        return 1;
    }

    int *arr = malloc(SIZE * sizeof(int));
    if (!arr) { perror("malloc"); return 1; }

    // Ініціалізація масиву
    for (int i = 0; i < SIZE; i++)
        arr[i] = i;

    long sum = 0;

    if (argv[1][0] == 's') {
        // --- Послідовний доступ (stride-1) ---
        for (int iter = 0; iter < ITERS; iter++)
            for (int i = 0; i < SIZE; i++)
                sum += arr[i];
    } else {
        // --- Доступ із великим кроком (stride-256) ---
        // Стрибаємо через 256 елементів = 1024 байти = 16 cache lines
        for (int iter = 0; iter < ITERS; iter++)
            for (int s = 0; s < 256 && s < SIZE; s++)
                for (int i = s; i < SIZE; i += 256)
                    sum += arr[i];
    }

    printf("sum = %ld\n", sum);
    free(arr);
    return 0;
}