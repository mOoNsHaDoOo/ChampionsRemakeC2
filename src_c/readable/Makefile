# Champions of Krynn - asm -> C port, host build.
#
#   make          builds build/cok (requires SDL2: libsdl2-dev, brew sdl2, ...)
#   make status   updates PORT_STATUS.md
#   make clean    removes build/
#   make AUDIO=1  also builds the audio (COK_AUDIO, H043/H094; silent on the host),
#                 in build-audio/

CC        ?= cc
CFLAGS    ?= -std=c99 -O2 -Wall -Wextra -pedantic
SDL_CFLAGS := $(shell pkg-config --cflags sdl2 2>/dev/null || sdl2-config --cflags)
SDL_LIBS   := $(shell pkg-config --libs sdl2 2>/dev/null || sdl2-config --libs)
ifeq ($(AUDIO),1)
CFLAGS    += -DCOK_AUDIO
BUILD_DIR ?= build-audio
else
BUILD_DIR ?= build
endif
TARGET    := $(BUILD_DIR)/cok

SRCS := $(wildcard *.c) $(wildcard host/*.c)
OBJS := $(SRCS:%.c=$(BUILD_DIR)/%.o)

.PHONY: all status clean

all: $(TARGET)

$(TARGET): $(OBJS)
	$(CC) $(OBJS) $(SDL_LIBS) -o $@

$(BUILD_DIR)/%.o: %.c $(wildcard *.h) $(wildcard host/*.h) | $(BUILD_DIR)/host
	$(CC) $(CFLAGS) $(SDL_CFLAGS) -c $< -o $@

$(BUILD_DIR)/host:
	mkdir -p $@

status:
	python3 ../../scripts/port_status.py --check

clean:
	rm -rf $(BUILD_DIR)
