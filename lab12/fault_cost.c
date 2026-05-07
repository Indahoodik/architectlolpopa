// fault_cost.c — вимірювання вартості minor page fault
#define _POSIX_C_SOURCE 199309L
#include <stdio.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <sys/resource.h>
#include <time.h>

#define REGION_SIZE (128 * 1024 * 1024)   // 128 MB
#define PAGE_SIZE   4096

long get_minor_faults() {
    struct rusage r;
    getrusage(RUSAGE_SELF, &r);
    return r.ru_minflt;
}

int main() {
    long pages = REGION_SIZE / PAGE_SIZE;

    char *region = mmap(NULL, REGION_SIZE, PROT_READ | PROT_WRITE,
                        MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
    if (region == MAP_FAILED) { perror("mmap"); return 1; }

    // --- Прохід 1: перше торкання (кожна сторінка → minor fault) ---
    long faults_before = get_minor_faults();
    struct timespec t1, t2;
    clock_gettime(CLOCK_MONOTONIC, &t1);

    for (long i = 0; i < pages; i++)
        region[i * PAGE_SIZE] = 1;

    clock_gettime(CLOCK_MONOTONIC, &t2);
    long faults_pass1 = get_minor_faults() - faults_before;
    double time_pass1 = (t2.tv_sec - t1.tv_sec)
                      + (t2.tv_nsec - t1.tv_nsec) / 1e9;

    // --- Прохід 2: повторне торкання (сторінки вже в RAM → 0 faults) ---
    faults_before = get_minor_faults();
    clock_gettime(CLOCK_MONOTONIC, &t1);

    for (long i = 0; i < pages; i++)
        region[i * PAGE_SIZE] = 2;

    clock_gettime(CLOCK_MONOTONIC, &t2);
    long faults_pass2 = get_minor_faults() - faults_before;
    double time_pass2 = (t2.tv_sec - t1.tv_sec)
                      + (t2.tv_nsec - t1.tv_nsec) / 1e9;

    printf("=== Вимірювання вартості minor page fault ===\n\n");
    printf("Сторінок: %ld (= %d MB / %d)\n\n", pages,
           REGION_SIZE / (1024*1024), PAGE_SIZE);

    printf("Прохід 1 (перше торкання — з page faults):\n");
    printf("  Minor faults: %ld\n", faults_pass1);
    printf("  Час:          %.4f с\n", time_pass1);
    if (faults_pass1 > 0)
        printf("  Вартість 1 fault: ~%.0f нс\n",
               (time_pass1 / faults_pass1) * 1e9);

    printf("\nПрохід 2 (повторне торкання — без faults):\n");
    printf("  Minor faults: %ld\n", faults_pass2);
    printf("  Час:          %.4f с\n", time_pass2);

    if (time_pass2 > 0)
        printf("\nРізниця: %.1fx повільніше з faults\n",
               time_pass1 / time_pass2);

    munmap(region, REGION_SIZE);
    return 0;
}