# NOTE: This Makefile is a temporary solution and will be replaced by a CMake-based build system.

.PHONY: build run clean

BUILD_DIR = build
TARGET = $(BUILD_DIR)/GameEngine2D

build:
	mkdir -p $(BUILD_DIR)
	g++ -Wall -std=c++17 src/*.cpp -lSDL2 -o $(TARGET)

run:
	./$(TARGET)

clean:
	rm -rf $(BUILD_DIR)
