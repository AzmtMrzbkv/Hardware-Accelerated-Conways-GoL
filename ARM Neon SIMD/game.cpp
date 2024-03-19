#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <math.h>
#include <arm_neon.h>

#include <string.h>

void clearSides(int8_t* board, unsigned int M, unsigned int N){
    for(int i = 0; i < N + 2; ++i){
        board[0 * N + i] = 0;
        board[(M + 1) * N + i] = 0;
    }
    for(int i = 0; i < M + 2; ++i){
        board[i * N + 0] = 0;
        board[i * N + (N + 1)] = 0;
    }
}

void countNeighbors(int8_t* t_board, int8_t* board, unsigned int M, unsigned int N){
    for(int i = 0; i < M; ++i){
        for(int j = 0; j < N; j += 8){
            int8x8_t v, t_v;
            t_v = vcreate_s8(0x00000000);

            // L, R
            v = vld1_s8(board + (i + 1)*(N + 2) + (j + 1) - 1); 
            t_v = vadd_s8(t_v, v);
            v = vld1_s8(board + (i + 1)*(N + 2) + (j + 1) + 1); 
            t_v = vadd_s8(t_v, v);
            
            // U, D
            v = vld1_s8(board + (i + 1 - 1)*(N + 2) + (j + 1)); 
            t_v = vadd_s8(t_v, v);
            v = vld1_s8(board + (i + 1 + 1)*(N + 2) + (j + 1)); 
            t_v = vadd_s8(t_v, v);

            // // UR, UL
            v = vld1_s8(board + (i + 1 - 1)*(N + 2) + (j + 1) - 1); 
            t_v = vadd_s8(t_v, v);
            v = vld1_s8(board + (i + 1 - 1)*(N + 2) + (j + 1) + 1); 
            t_v = vadd_s8(t_v, v);

            // // DR, DL
            v = vld1_s8(board + (i + 1 + 1)*(N + 2) + (j + 1) - 1); 
            t_v = vadd_s8(t_v, v);
            v = vld1_s8(board + (i + 1 + 1)*(N + 2) + (j + 1) + 1); 
            t_v = vadd_s8(t_v, v);

            // store the vector back to memory
            vst1_s8(t_board + (i + 1)*(N + 2) + (j + 1), t_v);
        }
    }
}

void computeNextState(int8_t* board, int8_t* t_board, unsigned int M, unsigned int N){
    for(int i = 0; i < M; ++i){
        for(int j = 0; j < N; ++j){
            if(t_board[(i + 1)*(N + 2) + (j + 1)] != 2)
                board[(i + 1)*(N + 2) + (j + 1)] = (t_board[(i + 1)*(N + 2) + (j + 1)] == 3);
        }
    }
}

int main(){
    unsigned int M, N, G;
    scanf("%u %u %u ", &M, &N, &G);

    // Make N a multiple of 8 to ease use of Neon intrinsics
    // Assume for now that (N mod 8 = 0)

    int8_t *board, *t_board;
    board = (int8_t*) malloc(sizeof(int8_t) * (M + 2) * (N + 2)); // extra padding for easier counting 
    t_board = (int8_t*) malloc(sizeof(int8_t) * (M + 2) * (N + 2));
    memset((void *)board, 0, sizeof(int8_t) * (M + 2) * (N + 2));
    memset((void *)t_board, 0, sizeof(int8_t) * (M + 2) * (N + 2));

    char t;
    for(int i = 0; i < M; ++i){
        for(int j = 0; j < N; ++j){
            scanf("%c", &t);
            board[(i + 1) * (N + 2) + (j + 1)] = (t == '#');
        }
        scanf("%c", &t);
    }

    for(int i = 0; i < G; ++i){
        clearSides(t_board, M, N);
        countNeighbors(t_board, board, M, N);
        computeNextState(board, t_board, M, N);
    }

    int8_t A[] = {1};
    int8x8_t v = vld1_s8(A); 
    v = vadd_s8(v, v);
    vst1_s8(A, v);

    for(int i = 0; i < M; ++i){
        for(int j = 0; j < N; ++j){
            printf("%c", (board[(i + 1) * (N + 2) + (j + 1)] ? '#' : '.'));
        }
        printf("\n");
    }

    free(t_board);
    free(board);
}