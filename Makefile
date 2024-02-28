CC=clang++
SAMPLES='../Parallel-Computing/Assignment II/sample'

test: game.cpp
	$(CC) game.cpp -o game
	for t in 1 2 3 4 5 ; do \
		./game < $(SAMPLES)/input$${t}.txt > output$${t}.txt; \
		diff $(SAMPLES)/output$${t}.txt output$${t}.txt > /dev/null || (echo Test $$t failed && exit 1); \
		rm output$${t}.txt; \
    done;
	rm game

