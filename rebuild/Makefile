VASM ?= vasmm68k_mot
PYTHON ?= python3

.PHONY: all api check-api
all: api
	$(PYTHON) tools/build.py --vasm "$(VASM)"

# Regenerate the symbolic API constants from the bundled NDK 3.2 subset
# and verify the call-site LVOs against the NDK 3.2 FD files.
api:
	$(PYTHON) tools/gen_api_const.py
	$(PYTHON) tools/check_api_lvo.py
	$(PYTHON) tools/check_api_ndk13.py
	$(PYTHON) tools/check_api_const.py

check-api: api
