/*
 * OpenSCAD Pogo Pin Rendering Tool (PPRT)
 *
 * Copyright (2019) Brian 'redbeard' Harrington, <redbeard@dead-city.org>
 *
 * PPRT is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * PPRT is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with PPRT.  If not, see <https://www.gnu.org/licenses/>.
 */

// These options can be overridden when calling "make", e.g.:
// make svg 

// Pin definitions
// Number of rows to be placed in the jig (along X axis)
ROWS = 2;
// Number of columns to be placed in the jig (along Y axis)
COLS = 5;
PITCH = 1.27;
PIN_DIAMETER = 1;


// Block size (if using, set AUTOSIZE=false)
LENGTH = 1;
WIDTH = 1;
HEIGHT = 5;
AUTOSIZE = true;

IS_CENTERED = true;
OFFSET_X = 0;
OFFSET_Y = 0;

// Global configurations, these shouldn't need to be changed
2D = false;
debug = true;

assert (PIN_DIAMETER < PITCH, 
  "Your PIN_DIAMETER is larger than your pin PITCH.");

// helpers
pin_block_length = PITCH * COLS;
pin_block_width = PITCH * ROWS;


render_length = (AUTOSIZE && (LENGTH < pin_block_length)) ? pin_block_length + 1 : LENGTH;
render_width = (AUTOSIZE && (WIDTH < pin_block_width)) ? pin_block_width + 1 : WIDTH;
render_height = HEIGHT;

// check if pin block should be "centered"
vx = (IS_CENTERED) ? (render_length - pin_block_length) / 2 : 0;
vy = (IS_CENTERED) ? (render_width - pin_block_width) / 2 : 0;


// print calculations to the console if needed
if (debug) {
  echo("pin_block_length: ", pin_block_length);
  echo("pin_block_width: ", pin_block_width);
  echo("Pinblock start X: ", vx);
  echo("Pinblock start Y: ", vy);
  echo("render_length: ", render_length);
  echo("render_width: ", render_width);
  echo("render_height: ", render_height);
}

module gen_pinblock(rows=ROWS, cols=COLS) {
  assert(rows > 0, "ROWS must be greater than 0"); 
  assert(cols > 0, "COLS must be greater than 0"); 
  for (row = [1:rows]) {
    for (col = [1:cols]) {  
          translate ([(col* PITCH) - PITCH/2, (row* PITCH) - PITCH/2, 0])
          cylinder(h=HEIGHT, d=PIN_DIAMETER, $fn=30);
    };
  }
}

/*
 create the rectangle as frame, then execute a loop to generate the
 pin structure and remove the pin material

 note, the cut=2D specifies if this should be a two dimensional slice versus
 a three dimensional render.
*/
if (2D) {
  projection(cut=true)
  difference(){
    cube([render_length,render_width,render_height]);
    translate ([vx + OFFSET_X,vy + OFFSET_Y,0])
    gen_pinblock();
  }
} else {
  difference(){
    cube([render_length,render_width,render_height]);
    translate ([vx + OFFSET_X,vy + OFFSET_Y,0])
    gen_pinblock();
  }
}

// vim: ts=2 sw=2 et tw=80
