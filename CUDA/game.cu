#include<stdio.h>
#include<math.h>

#define uchar unsigned char
#define uint unsigned int

__global__ void computeBoardNextState(uchar* board, uchar* temp, uint m, uint n){
    uint idx = (uint)blockDim.x * blockIdx.x + threadIdx.x; 
    if(idx >= (m - 2) * (n - 2)) 
        return;

    uint i = idx / (n - 2), j = idx % (n - 2), k = 0;

    // left - right
    k += board[(i + 1) * n + (j + 1) - 1];
    k += board[(i + 1) * n + (j + 1) + 1];

    k += board[(i + 1 - 1) * n + (j + 1)];
    k += board[(i + 1 - 1) * n + (j + 1) - 1];
    k += board[(i + 1 - 1) * n + (j + 1) + 1];

    k += board[(i + 1 + 1) * n + (j + 1)];
    k += board[(i + 1 + 1) * n + (j + 1) - 1];
    k += board[(i + 1 + 1) * n + (j + 1) + 1];

    if(k == 2)
        temp[(i + 1) * n + (j + 1)] = board[(i + 1) * n + (j + 1)];
    else
        temp[(i + 1) * n + (j + 1)] = (k == 3);
}

__global__ void copyBoard(uchar* board, uchar* temp, uint m, uint n){ // is this the most efficient copy?
    uint idx = (uint)blockDim.x * blockIdx.x + threadIdx.x;
    if(idx >= (m - 2) * (n - 2)) 
        return;

    uint i = idx / (n - 2), j = idx % (n - 2);
    board[(i + 1) * n + (j + 1)] = temp[(i + 1) * n + (j + 1)];
}

inline void readBoard(uchar* h_board, uint m, uint n){
    char t;
    for(int i = 1; i < m - 1; ++i){
        for(int j = 1; j < n - 1; ++j){
            scanf("%c", &t);
            h_board[i * n + j] = (t == '#');
        }
        scanf("%c", &t); // newline
    }
}

inline void printBoard(uchar* h_board, uint m, uint n){
    for(int i = 1; i < m - 1; ++i){
        for(int j = 1; j < n - 1; ++j){
            printf("%c", (h_board[i * n + j] ? '#' : '.'));
        }
        printf("\n");
    }
}

int main(){
    uint m, n, g, boardRows, boardCols;
    uchar *h_board, *d_res_board, *d_temp_board;

    scanf("%u %u %u ", &m, &n, &g);

    // add paddings to remove out-of-borders checks
    boardRows = m + 2;
    boardCols = n + 2;

    h_board = (uchar*)malloc(sizeof(uchar) * boardRows * boardCols);
    memset((void*)h_board, 0, sizeof(uchar) * boardRows * boardCols);
    readBoard(h_board, boardRows, boardCols);

    cudaMalloc((void**)&d_res_board, sizeof(uchar) * boardRows * boardCols);
    cudaMalloc((void**)&d_temp_board, sizeof(uchar) * boardRows * boardCols);

    cudaMemcpy(d_res_board, h_board, sizeof(uchar) * boardRows * boardCols, cudaMemcpyHostToDevice);
    cudaMemset((void*)d_temp_board, 0, sizeof(uchar) * boardRows * boardCols); // allocated memory is not cleared
  
    const uint threadNum = 512;
    const uint blockNum = ceil((double)m * n / threadNum); // set these numbers for now. ideally use dim3

    for(int i = 0; i < g; ++i){
        computeBoardNextState<<<blockNum, threadNum>>>(d_res_board, d_temp_board, boardRows, boardCols); // implicit synchronization before next kernel
        copyBoard<<<blockNum, threadNum>>>(d_res_board, d_temp_board, boardRows, boardCols); // copy from temp board to res board
    }

    cudaMemcpy(h_board, d_res_board, sizeof(uchar) * boardRows * boardCols, cudaMemcpyDeviceToHost);
    printBoard(h_board, boardRows, boardCols);

    cudaFree(d_res_board);
    cudaFree(d_temp_board);
    free(h_board);
}