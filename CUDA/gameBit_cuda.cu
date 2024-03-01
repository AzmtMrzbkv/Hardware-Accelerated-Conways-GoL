#include<stdio.h>
#include<math.h>

#define uchar unsigned char
#define uint unsigned int

__global__ void computeBoardNextState(uchar* board, uchar* temp, uint m, uint n){
    
}

__global__ void copyBoard(uchar* board, uchar* temp, uint m, uint n){ // is this the most efficient copy?
   
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
    
}