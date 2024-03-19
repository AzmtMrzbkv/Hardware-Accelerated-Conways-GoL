#include <hls/image_processing.hpp>
#include <hls/streaming.hpp>
#include <stdio.h>

void computeNextState(FIFO<unsigned char> &input_fifo, FIFO<unsigned char> &output_fifo){

}

// returns zero if tests pass, returns non-zero otherwise
int main(){
    unsigned int M, N, G;
    scanf("%u %u %u ", &M, &N, &G);

    FIFO<unsigned char> input_fifo(/* depth: */ N * M * 2);
    FIFO<unsigned char> output_fifo(/* depth: */ N * M * 2);

    char t;
    for(int i = 0; i < M; ++i){
        for(int j = 0; j < N; ++j){
            scanf("%c", &t);
            input_fifo.write(t == '#');
        }
        scanf("%c", &t);
    }

    computeNextState(input_fifo, output_fifo);

    return 0;
}