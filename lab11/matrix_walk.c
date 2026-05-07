// matrix_walk.c — row-major vs column-major обхід матриці
#include <stdio.h>
#include <stdlib.h>

#define N 4096   // 4096 x 4096 матриця = 64 MB

int matrix[N][N];   // глобальна (щоб вмістилась — стеку може не вистачити)

int main(int argc, char *argv[]) {
    if (argc < 2) {
        printf("Usage: %s row|col\n", argv[0]);
        return 1;
    }

    long sum = 0;

    if (argv[1][0] == 'r') {
        // Row-major: matrix[0][0], [0][1], [0][2], ... — послідовно в пам'яті
        for (int i = 0; i < N; i++)
            for (int j = 0; j < N; j++)
                sum += matrix[i][j];
    } else {
        // Column-major: matrix[0][0], [1][0], [2][0], ... — стрибки через N елементів
        for (int j = 0; j < N; j++)
            for (int i = 0; i < N; i++)
                sum += matrix[i][j];
    }

    printf("sum = %ld\n", sum);
    return 0;
}