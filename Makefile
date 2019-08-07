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
ROWS = 5
COLS = 2

output = output

IMAGES = png 
2D = dxf svg
3D = stl

PHONY: $(IMAGES) $(2D) $(3D)

OPTIONS = -D ROWS=$(ROWS) -D COLS=$(COLS)

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

output:
	mkdir -p output

$(IMAGES): output
	openscad --render --imgsize=1280,800 --autocenter --viewall -o $(output)/$(MODEL)-row$(ROWS)-col$(COLS).$@ $(OPTIONS) $(MODEL).scad
	$(START) $(output)/$(MODEL)-row$(ROWS)-col$(COLS).$@

$(2D): output
	openscad -o $(output)/$(MODEL)-row$(ROWS)-col$(COLS).$@ $(OPTIONS) -D 2D=true $(MODEL).scad


$(3D): output
	openscad -o $(output)/$(MODEL)-row$(ROWS)-col$(COLS).$@ $(OPTIONS) $(MODEL).scad

model:
	openscad 

clean:
	-rm -rf $(output)
