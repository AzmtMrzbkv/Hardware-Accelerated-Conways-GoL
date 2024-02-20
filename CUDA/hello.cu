#include<stdio.h>

__global__ void myhello(){
    printf("Hello my friend!");
}

int main(){
    myhello<<<1,1>>>();
    cudaDeviceReset(); // destroy CUDA context by resetting device immediately 
    return 0;
}