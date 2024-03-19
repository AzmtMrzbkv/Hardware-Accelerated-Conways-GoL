CC=clang++
TESTS='data'
ARM='ARM Neon SIMD'
CUDA='CUDA'

arm: 
	$(CC) $(ARM)/game.cpp -o game

pure:
	$(CC) game.cpp -o game

cuda:
	nvcc $(CUDA)/game.cu -o game

test: 
	for t in 1 2 3 4 5 ; do \
		./game < $(TESTS)/input$${t}.txt > output$${t}.txt; \
		diff $(TESTS)/output$${t}.txt output$${t}.txt > /dev/null || (echo Test $$t failed && exit 1); \
		rm output$${t}.txt; \
    done;

clean:
	rm game
