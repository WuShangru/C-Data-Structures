#-----------------------------------------------------------------------------
# project name
#
PROJECT     := data-struct

#-----------------------------------------------------------------------------
# compiler and shell cmd
#

CC   := gcc
LINK := gcc

MKDIR := mkdir
RM    := rm


CFLAGS = -Wall -pedantic -std=c99 -DDEBUG -g -O0 -ggdb3 \
	-Wextra -Wno-missing-field-initializers
LINKFLAGS =

#-----------------------------------------------------------------------------
# project directories
#

DIR_OBJS = objs
DIR_EXES = exes
DIR_DEPS = deps
DIRS = $(DIR_OBJS) $(DIR_EXES) $(DIR_DEPS)

EXE = $(PROJECT).run
EXE := $(addprefix $(DIR_EXES)/, $(EXE))

SRCS = $(wildcard *.c)
OBJS = $(SRCS:.c=.o)
OBJS := $(addprefix $(DIR_OBJS)/, $(OBJS))
DEPS = $(SRCS:.c=.d)
DEPS := $(addprefix $(DIR_DEPS)/, $(DEPS))

# create directories if it does not exist
ifeq ("$(wildcard $(DIR_DEPS))", "")
$(shell $(MKDIR) $(DIR_DEPS))
endif
ifeq ("$(wildcard $(DIR_OBJS))", "")
$(shell $(MKDIR) $(DIR_OBJS))
endif
ifeq ("$(wildcard $(DIR_EXES))", "")
$(shell $(MKDIR) $(DIR_EXES))
endif

#-----------------------------------------------------------------------------
# rules
#

all: $(EXE)

$(EXE) : $(OBJS)
	$(LINK) $(LINKFLAGS) -o $@ $^ 

$(DIR_DEPS)/%.d : %.c
	$(CC) -MM -MT $(@:.d=.o) $(CFLAGS) $< > $@

$(DIR_OBJS)/%.o : %.c
	$(CC) $(CFLAGS) -c $< -o $@

# include dependency files only if our goal depends on their existence
ifneq ($(MAKECMDGOALS), clean)
-include $(DEPS)
endif

.PHONY : clean
clean:
	-$(RM) $(DIR_OBJS)/*.o \
	$(DIR_DEPS)/*.d \
	$(DIR_EXES)/*.run
