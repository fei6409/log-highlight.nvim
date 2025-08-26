TEST_DIR := tests
INIT_LUA := $(TEST_DIR)/init.lua

.PHONY: all test

all: test

test:
	@nvim --headless --noplugin -u $(INIT_LUA) -c "PlenaryBustedDirectory $(TEST_DIR) { minimal_init = '$(INIT_LUA)' }"
