// addr_explorer.c — дослідження адресного простору процесу
#include <stdio.h>       // printf, fopen, fgets, fclose
#include <stdlib.h>      // malloc, free
#include <stdint.h>      // uintptr_t — цілочисельний тип для зберігання адрес
#include <unistd.h>      // getpid
#include <string.h>

int global_init = 42;            // .data — ініціалізована глобальна
int global_uninit;               // .bss  — неініціалізована глобальна (нуль)

// uintptr_t — ціле число, достатньо велике для зберігання адреси (64 біт)
// >> та & — побітові зсув і маска (як SHR і AND в асемблері)
void decode_va(const char *name, uintptr_t va) {
    printf("\n  Декомпозиція %s (0x%lx):\n", name, va);
    printf("    L4 (PML4): %3lu\n", (va >> 39) & 0x1FF);   // біти 47–39
    printf("    L3 (PDPT): %3lu\n", (va >> 30) & 0x1FF);   // біти 38–30
    printf("    L2 (PD):   %3lu\n", (va >> 21) & 0x1FF);   // біти 29–21
    printf("    L1 (PT):   %3lu\n", (va >> 12) & 0x1FF);   // біти 20–12
    printf("    Offset:    %3lu (0x%03lx)\n", va & 0xFFF, va & 0xFFF);
}

int main() {
    int stack_var = 7;                       // локальна змінна → стек
    int *heap_var = malloc(sizeof(int));      // динамічна пам'ять → купа
    *heap_var = 99;

    printf("=== Адреси у процесі PID %d ===\n\n", getpid());
    //  &змінна    — адреса змінної (як OFFSET у TASM)
    //  (void *)   — перетворення для друку адреси через %p
    //  main       — ім'я функції без () дає її адресу
    printf("  %-24s %p\n", "Код (main):",         (void *)main);
    printf("  %-24s %p\n", "Глобальна (init):",   (void *)&global_init);
    printf("  %-24s %p\n", "Глобальна (uninit):", (void *)&global_uninit);
    printf("  %-24s %p\n", "Купа (malloc):",      (void *)heap_var);
    printf("  %-24s %p\n", "Стек (локальна):",    (void *)&stack_var);

    printf("\n=== Декомпозиція віртуальних адрес ===\n");
    // (uintptr_t) — перетворюємо адресу в число, щоб виконати побітові операції
    decode_va("стек", (uintptr_t)&stack_var);
    decode_va("купа", (uintptr_t)heap_var);
    decode_va("код",  (uintptr_t)main);

    // /proc/self/maps — спеціальний файл Linux із картою пам'яті поточного процесу
    printf("\n=== /proc/self/maps ===\n\n");
    FILE *f = fopen("/proc/self/maps", "r");     // відкрити файл для читання
    if (f) {
        char line[512];
        while (fgets(line, sizeof(line), f))      // читати рядок за рядком
            printf("  %s", line);
        fclose(f);
    }

    free(heap_var);      // звільнити динамічну пам'ять
    return 0;
}
