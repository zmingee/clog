TARGET := clog
BUILD_DIR := build
C_SRCS := $(wildcard lib/*.c)
C_OBJS := $(C_SRCS:.c=.o)
C_TESTS := $(wildcard tests/*.c)
INCLUDE_DIRS := /usr/local/include
DIRS := /usr/local/lib

 OPTIMIZATION := -O3
 include config.mk

STD := -std=c99 -pedantic
WARN := -Wall -W -Wextra

CFLAGS += $(foreach includedir,$(INCLUDE_DIRS),-I$(includedir))
CFLAGS += -DVERSION=\"${VERSION}\" -g $(OPTIMIZATION) $(STD) $(WARN)
LDFLAGS += $(foreach libdir,$(DIRS), -L$(libdir))

.PHONY: all check clean distclean $(TARGET)

all: builddir $(TARGET)

$(TARGET): $(C_OBJS)
	$(CC) $(C_OBJS) -o $(BUILD_DIR)/$(TARGET) $(LDFLAGS)

install: all
	@echo installing executable file to $(PREFIX)/bin
	@mkdir -p $(PREFIX)/bin
	@cp -f $(BUILD_DIR)/$(TARGET) $(PREFIX)/bin
	@chmod 755 $(PREFIX)/bin/$(TARGET)
	@mkdir -p $(MANPREFIX)/man1
	@sed "s/VERSION/$(VERSION)/g" < $(TARGET).1 > $(MANPREFIX)/man1/$(TARGET).1
	@chmod 644 $(MANPREFIX)/man1/$(TARGET).1
	@echo installing config file to /etc/$(TARGET)/$(TARGET).conf
	@mkdir -p /etc/$(TARGET)
	@cp -f conf/$(TARGET).conf /etc/$(TARGET)/$(TARGET).conf

uninstall:
	@echo removing executable file from $(PREFIX)/bin
	@- $(RM) -f $(PREFIX)/bin/$(TARGET)
	@echo removing man page from $(MANPREFIX)/man1
	@- $(RM) -f $(MANPREFIX)/man1/$(TARGET).1
	@echo you can manually remove /etc/$(TARGET) if you would like

## C binary section ##

check: $(C_OBJS) $(C_TESTS) | builddir remove_optimization
	$(CC) -g $(C_OBJS) $(C_TESTS) -o $(BUILD_DIR)/test $(LDFLAGS)
	build/test

valgrind: $(C_OBJS) $(C_TESTS) | builddir remove_optimization
	$(CC) -g $(C_OBJS) $(C_TESTS) -o $(BUILD_DIR)/test $(LD_FLAGS)
	valgrind --track-origins=yes --suppresions=.valgrind.sup build/test

cppcheck:
	cppcheck \
	    --inline-suppr \
	    --language=c \
	    --std=c99 \
	    --enable=all \
	    --template=gcc \
	    lib/

## Misc. ##

builddir:
	@mkdir -p $(BUILD_DIR)

remove_optimization:
	$(eval CFLAGS := $(filter-out $(OPTIMIZATION), $(CFLAGS)))


clean:
	@- $(RM) $(C_OBJS)
	@- $(RM) -r build
	@- find . -name "vgcore*" | xargs $(RM) -rf
	@- find . -name "*.sw*" | xargs $(RM) -rf

define OBJECT_DEPENDS_ON_CORRESPONDING_HEADER
	$(1) : $(1:.o=.h)
endef

$(foreach object_file,$(program_OBJS),$(eval $(call OBJECT_DEPENDS_ON_CORRESPONDING_HEADER,$(object_file))))
