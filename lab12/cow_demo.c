// cow_demo.c — Copy-on-Write Detective
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <sys/resource.h>
#include <sys/wait.h>
#include <unistd.h>

#define REGION_SIZE (64 * 1024 * 1024)   // 64 MB = 16384 сторінок
#define PAGE_SIZE   4096

long get_minor_faults() {
    struct rusage r;
    getrusage(RUSAGE_SELF, &r);
    return r.ru_minflt;
}

int main() {
    long pages = REGION_SIZE / PAGE_SIZE;

    // Крок 1: Виділити пам'ять і торкнути кожну сторінку
    char *region = mmap(NULL, REGION_SIZE, PROT_READ | PROT_WRITE,
                        MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
    if (region == MAP_FAILED) { perror("mmap"); return 1; }

    // TODO 1: Заповніть кожну сторінку, щоб усі були у фізичній пам'яті.
    //         Цикл по i від 0 до pages, запис region[i * PAGE_SIZE] = будь-що.
    //         (Аналогічно до demand_paging.c з пари)


    printf("Батько (PID %d): виділено %ld сторінок, усі торкнуті\n\n",
           getpid(), pages);

    fflush(stdout);   // очистити буфер перед fork — інакше текст дублюється!

    long parent_before = get_minor_faults();
    pid_t pid = fork();

    if (pid == 0) {
        // ===== Дочірній процес =====
        // Після fork() лічильник faults дитини починається з ~0

        // --- Фаза читання: прочитати кожну сторінку ---
        long before_read = get_minor_faults();

        // TODO 2: Прочитайте кожну сторінку (ЛИШЕ читання, без запису!).
        //         Цикл по i від 0 до pages:
        //           volatile char c = region[i * PAGE_SIZE];
        //         (volatile — щоб компілятор не викинув "непотрібне" читання)


        long read_faults = get_minor_faults() - before_read;
        printf("Дитина (PID %d):\n", getpid());
        printf("  Фаза читання: minor faults = %ld\n", read_faults);

        // --- Фаза запису: записати в кожну сторінку (COW!) ---
        long before_write = get_minor_faults();

        // TODO 3: Запишіть у кожну сторінку (як у TODO 1).
        //         Цикл по i від 0 до pages:
        //           region[i * PAGE_SIZE] = 42;


        long write_faults = get_minor_faults() - before_write;
        printf("  Фаза запису:  minor faults = %ld\n", write_faults);

        fflush(stdout);
        _exit(0);   // завершити дочірній процес
    }

    // ===== Батьківський процес =====
    waitpid(pid, NULL, 0);   // чекаємо, поки дитина завершиться
    long parent_after = get_minor_faults();
    printf("\nБатько: мої minor faults після fork = %ld\n",
           parent_after - parent_before);

    munmap(region, REGION_SIZE);
    return 0;
}