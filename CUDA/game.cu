#include<stdio.h>

__global__ void computeNextState(char* grid, int m, int n){
    int i = blockIdx.x, j = threadIdx.x, k = 0;

    // left - right
    if(j > 0 && grid[i * n + j - 1])
        ++k;
    if(j < n - 1 && grid[i * n + j + 1])
        ++k;

    // top
    if(i > 0){
        if(grid[(i - 1) * n + j])
            ++k;
        if(j > 0 && grid[(i - 1) * n + j - 1])
            ++k;
        if(j < n - 1 && grid[(i - 1) * n + j + 1])
            ++k;
    }

    // bottom
    if(i < m - 1){
        if(grid[(i + 1) * n + j])
            ++k;
        if(j > 0 && grid[(i + 1) * n + j - 1])
            ++k;
        if(j < n - 1 && grid[(i + 1) * n + j + 1])
            ++k;
    }

    __syncthreads();

    // define new state
    if(k == 2)
        grid[i * n + j] = grid[i * n + j];
    else if(k == 3)
        grid[i * n + j] = 1;
    else
        grid[i * n + j] = 0;

    __syncthreads();
}

int main(){
    int m, n, g;
    char *h_grid, *d_grid, t;

    scanf("%d %d %d ", &m, &n, &g);
    g = n;
    n = m;
    h_grid = (char*)malloc(sizeof(char) * m * n);

    for(int i = 0; i < m; ++i){
        for(int j = 0; j < n; ++j){
            scanf("%c", &t);
            h_grid[i * n + j] = (t == '#');
        }
        scanf("%c", &t); // newline
    }

    cudaMalloc((void**)&d_grid, sizeof(char) * m * n);
    cudaMemcpy(d_grid, h_grid, sizeof(char) * m * n, cudaMemcpyHostToDevice);
  
    for(; g > 0; --g)
        computeNextState<<<m, n>>>(d_grid, m, n); // implicit synchronization 

    cudaMemcpy(h_grid, d_grid, sizeof(char) * m * n, cudaMemcpyDeviceToHost);

    for(int i = 0; i < m; ++i){
        for(int j = 0; j < n; ++j){
            printf("%c", (h_grid[i * n + j] ? '#' : '.'));
        }
        printf("\n");
    }

    cudaFree(d_grid);
    free(h_grid);
}