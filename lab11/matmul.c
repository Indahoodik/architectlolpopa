
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define N 1024      
#define BLOCK 64  

int A[N][N], B[N][N], C[N][N];

void init_matrices() {
    for (int i = 0; i < N; i++)
        for (int j = 0; j < N; j++) {
            A[i][j] = i + j;
            B[i][j] = i - j;
            C[i][j] = 0;
        }
}

void matmul_naive() {
    for (int i = 0; i < N; i++)
        for (int j = 0; j < N; j++)
            for (int k = 0; k < N; k++)
                C[i][j] += A[i][k] * B[k][j];
}


void matmul_opt1() {
    for (int i = 0; i < N; i++)
        for (int k = 0; k < N; k++)
            for (int j = 0; j < N; j++)
                C[i][j] += A[i][k] * B[k][j];
}


void matmul_opt2() {
    for (int ii = 0; ii < N; ii += BLOCK)
        for (int jj = 0; jj < N; jj += BLOCK)
            for (int kk = 0; kk < N; kk += BLOCK)
                for (int i = ii; i < ii + BLOCK && i < N; i++)
                    for (int j = jj; j < jj + BLOCK && j < N; j++)
                        for (int k = kk; k < kk + BLOCK && k < N; k++)
                            C[i][j] += A[i][k] * B[k][j];
}


long checksum() {
    return (long)C[0][0] + C[N/2][N/2] + C[N-1][N-1];
}

int main(int argc, char *argv[]) {
    if (argc < 2) {
        printf("Usage: %s naive|opt1|opt2\n", argv[0]);
        return 1;
    }

    init_matrices();

    clock_t start = clock();

    if (argv[1][0] == 'n') {
        matmul_naive();
    } else if (argv[1][0] == 'o' && argv[1][3] == '1') {
        matmul_opt1();
    } else if (argv[1][0] == 'o' && argv[1][3] == '2') {
        matmul_opt2();
    } else {
        printf("Unknown option: %s\n", argv[1]);
        return 1;
    }

    clock_t end = clock();
    double seconds = (double)(end - start) / CLOCKS_PER_SEC;

    printf("Time: %.3f s\n", seconds);
    printf("Checksum: %ld\n", checksum());

    return 0;
}