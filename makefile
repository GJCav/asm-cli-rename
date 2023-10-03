# Author: GJCav (https://github.com/GJCav)
# LICENSE: MIT
# 支持自动检测新增cpp文件，增量编译。
# 注意：如果只更改了.h文件，不会重新编译，这个是由于make增量编译的机制限制的。

#################################### 
#    CHANGE THE VALUE BELLOW       #
####################################

# Compiler. g++ is required to compile both C and CPP
CXX=g++

# Options on compiling individual source file
CFLAGS:=-g -Wall

# Static libraries. Left empty if no static library is used.
STATIC_LIB:=

# Options on linking all objects together.
# Add dynamic libraries here, such as `-L<path/to/lib/folder> -l<libname>`
LDFLAGS:=-lncurses -lpanel -lmenu -lform -lcdk

# project name. it is used at packing the project
PROJECT_NAME=c-cli-rename

# target name is the program name
TARGET=c-cli-rename

####################################
#   detect and compile the files   #
#   do NOT edit them               #
####################################

# if the project is deeply nested, change `3` to a large number. but in 
# such situation, why wouldn't you use a more powerful IDE or cmake ?
DIRS = $(shell find -maxdepth 3 -type d)
SRC_CPP = $(foreach dir, $(DIRS), $(wildcard $(dir)/*.cpp))
SRC_C = $(foreach dir, $(DIRS), $(wildcard $(dir)/*.c))
SRC_ALL = $(SRC_C) $(SRC_CPP)

OUT_DIRS = $(foreach p, $(SRC_ALL), build/$(dir $(p)))
OBJS = $(SRC_CPP:%.cpp=%.o) $(SRC_C:%.c=%.o)
__TMP1 = $(OBJS:%=build/%)
OUT_OBJS = $(sort $(__TMP1))

all: mkd $(TARGET) success

mkd: 
	mkdir -p build
	@for v in $(OUT_DIRS); do mkdir -p $$v; done

build/%.o : %.cpp
	@$(CXX) -c $< -o $@ $(CFLAGS)

build/%.o : %.c
	@$(CXX) -c $< -o $@ $(CFLAGS)

$(TARGET): $(OUT_OBJS)
	@$(CXX) $^ $(STATIC_LIB) -o $(TARGET) $(LDFLAGS)

success:
	@echo "\e[32mBUILD SUCCESS\e[0m"


##################################
#  other commands.               #
#  feel free to edit them        #
##################################

clean:
	rm -rf *.o $(TARGET) ./build

pack: clean all
	rm -rf ./build
	rm -f $(PROJECT_NAME).zip
	zip -r $(PROJECT_NAME).zip ./ -x ".vscode/*"