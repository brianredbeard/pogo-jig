# OpenSCAD Pogo Pin Rendering Tool (PPRT)
#
# Copyright (2019) Brian 'redbeard' Harrington, <redbeard@dead-city.org>
#
# PPRT is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# PPRT is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with PPRT.  If not, see <https://www.gnu.org/licenses/>.

MODEL = pogo_pin_jig

#######
# Begin configurable overrides
#######
ROWS = 5
COLS = 2
PITCH = 2.54
LENGTH = 1
WIDTH = 1
HEIGHT = 5
IS_CENTERED = true
OFFSET_X = 0
OFFSET_Y = 0
PIN_DIAMETER = 1
AUTOSIZE=true
OUTPUT_DIR = output
#######
# End configurable overrides
#######


IMAGES = png 
2D = dxf svg
3D = stl

PHONY: $(IMAGES) $(2D) $(3D) get-vars

OPTIONS = -D ROWS=$(ROWS) -D COLS=$(COLS) -D PITCH=$(PITCH)

#######
# Basic OS detection for displaying the image file
# Note: Windows / MacOS is untested at the moment
#######

ifeq ($(OS),Windows_NT)
    START = start 
else
    UNAME_S := $(shell uname -s)
    ifeq ($(UNAME_S),Linux)
        START=xdg-open
    endif
    ifeq ($(UNAME_S),Darwin)
        START=open
    endif
endif

OUTPUT_DIR:
	mkdir -p $(OUTPUT_DIR)

$(IMAGES): OUTPUT_DIR
	openscad --render --imgsize=1280,800 --autocenter --viewall -o $(OUTPUT_DIR)/$(MODEL)-rows$(ROWS)-cols$(COLS)-pitch$(PITCH)mm.$@ $(OPTIONS) $(MODEL).scad
	$(START) $(OUTPUT_DIR)/$(MODEL)-rows$(ROWS)-cols$(COLS)-pitch$(PITCH)mm.$@

$(2D): OUTPUT_DIR
	openscad -o $(OUTPUT_DIR)/$(MODEL)-rows$(ROWS)-cols$(COLS)-pitch$(PITCH)mm.$@ $(OPTIONS) -D 2D=true $(MODEL).scad


$(3D): OUTPUT_DIR
	openscad -o $(OUTPUT_DIR)/$(MODEL)-rows$(ROWS)-cols$(COLS)-pitch$(PITCH)mm.$@ $(OPTIONS) $(MODEL).scad

model:
	openscad 
	
# This is a "helper" action to grab all relevant variables from the scad source
get-vars:
	@echo  -e "# Outputting variables for definition in Makefile\n"
	@grep -B1 "^[A-Z]" pogo_pin_jig.scad   | sed -e 's|;$$||g' -e 's|^--||g' -e 's|^//|# |g'
	@echo ""
	@echo  -e "# Outputting variables for OPTIONS =\n"
	@awk -F '[[:space:]]*=[[:space:]]*' '/^[A-Z]+/ {split($$2, val, /;/); printf " -D %s=%s", $$1, val[1]} END {print ""}' pogo_pin_jig.scad
clean:
	-rm -rf $(OUTPUT_DIR)
