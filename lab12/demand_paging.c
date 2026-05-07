// demand_paging.c — спостереження за demand paging
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>        // mmap — виділення віртуальної пам'яті
#include <sys/resource.h>    // getrusage — лічильник page faults

#define REGION_SIZE (256 * 1024 * 1024)   // 256 MB
#define PAGE_SIZE   4096

// Ця функція запитує ОС: "скільки minor page faults вже стались у моєму процесі?"
long get_minor_faults() {
    struct rusage r;                      // структура з лічильниками ресурсів
    getrusage(RUSAGE_SELF, &r);           // заповнити структуру поточними даними
    return r.ru_minflt;                   // повернути кількість minor faults
}

void print_rss() {
    FILE *f = fopen("/proc/self/status", "r");
    if (!f) return;
    char line[256];
    while (fgets(line, sizeof(line), f)) {
        if (strncmp(line, "VmRSS:", 6) == 0) {
            printf("  %s", line);
            break;
        }
    }
    fclose(f);
}

void print_vmsize() {
    FILE *f = fopen("/proc/self/status", "r");
    if (!f) return;
    char line[256];
    while (fgets(line, sizeof(line), f)) {
        if (strncmp(line, "VmSize:", 7) == 0) {
            printf("  %s", line);
            break;
        }
    }
    fclose(f);
}

int main() {
    long pages = REGION_SIZE / PAGE_SIZE;

    printf("=== Етап 0: до mmap ===\n");
    printf("  Minor faults: %ld\n", get_minor_faults());
    print_vmsize();
    print_rss();

    // Виділяємо 256 MB віртуальної пам'яті
    // mmap — «дай мені шматок віртуальної пам'яті»
    // MAP_ANONYMOUS = не з файлу, а просто нулі
    // MAP_PRIVATE   = лише для цього процесу
    // Повертає вказівник на початок виділеного регіону (як malloc, але потужніше)
    char *region = mmap(NULL, REGION_SIZE, PROT_READ | PROT_WRITE,
                        MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
    if (region == MAP_FAILED) { perror("mmap"); return 1; }

    printf("\n=== Етап 1: після mmap (256 MB виділено віртуально) ===\n");
    printf("  Minor faults: %ld\n", get_minor_faults());
    print_vmsize();
    print_rss();

    // Торкаємось кожної 4-ї сторінки (щоб було швидше — 1/4 сторінок)
    long touch_pages = pages / 4;
    long faults_before = get_minor_faults();

    for (long i = 0; i < touch_pages; i++)
        region[i * PAGE_SIZE] = 1;

    long faults_after = get_minor_faults();

    printf("\n=== Етап 2: після торкання %ld сторінок (із %ld) ===\n",
           touch_pages, pages);
    printf("  Minor faults від торкання: %ld\n", faults_after - faults_before);
    print_vmsize();
    print_rss();

    // Тепер торкаємось РЕШТИ сторінок
    faults_before = get_minor_faults();

    for (long i = 0; i < pages; i++)
        region[i * PAGE_SIZE] = 2;

    faults_after = get_minor_faults();

    printf("\n=== Етап 3: після торкання ВСІХ %ld сторінок ===\n", pages);
    printf("  Minor faults від торкання: %ld\n", faults_after - faults_before);
    printf("  (менше, ніж %ld — бо 1/4 вже торкнуті!)\n", pages);
    print_vmsize();
    print_rss();

    munmap(region, REGION_SIZE);
    return 0;
}