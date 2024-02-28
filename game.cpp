#include<iostream>

int main(){
    int m, n, g;
    char *grid, t;

    std::cin >> m >> n >> g;
    g = n;
    n = m;

    grid = new char[m * n];

    for(int i = 0; i < m; ++i){
        for(int j = 0; j < n; ++j){
            std::cin >> t;
            grid[i * n + j] = (t == '#');
        }
    }

    for(; g > 0; --g){
        for(int i = 0; i < m; ++i){
            for(int j = 0; j < n; ++j){
                int k = 0;
                // left - right
                if(j > 0 && (grid[i * n + j - 1] & 1))
                    ++k;
                if(j < n - 1 && (grid[i * n + j + 1] & 1))
                    ++k;

                // top
                if(i > 0){
                    if(grid[(i - 1) * n + j] & 1)
                        ++k;
                    if(j > 0 && (grid[(i - 1) * n + j - 1] & 1))
                        ++k;
                    if(j < n - 1 && (grid[(i - 1) * n + j + 1] & 1))
                        ++k;
                }

                // bottom
                if(i < m - 1){
                    if(grid[(i + 1) * n + j] & 1)
                        ++k;
                    if(j > 0 && (grid[(i + 1) * n + j - 1] & 1))
                        ++k;
                    if(j < n - 1 && (grid[(i + 1) * n + j + 1] & 1))
                        ++k;
                }

                // identify new state
                if(k == 2)
                    grid[i * n + j] += grid[i * n + j] << 1;
                if(k == 3)
                    grid[i * n + j] |= 2;
            }
        }
        for(int i = 0; i < m; ++i){
            for(int j = 0; j < n; ++j){
                grid[i * n + j] >>= 1;
            }
        }
    }

    for(int i = 0; i < m; ++i){
        for(int j = 0; j < n; ++j){
            std::cout << (grid[i * n + j] ? '#' : '.');
        }
        std::cout << '\n';
    }

    delete[] grid;
}