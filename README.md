# 3d printer pogo jig

![image](https://user-images.githubusercontent.com/57542/227043011-9fce1461-f078-42fc-b86f-475b71b8e7ef.png)

## about

This provides the initial proof of concept (POC) for a tool to generate
pogo pin jigs programatically using [OpenSCAD][openscad].

There are two ways of using this project:
- Through the use of a Makefile and command line arguments to `make`
- Directly editing the file `pogo_pin_jig.scad` in OpenSCAD

When using the Makefile parameters can be added directly to the command
line, e.g.:

```
$ make dxf ROWS=2 COLS=10
```

At the present time there is basic support for rendering the following
types:

- STL
- DXF
- SVG
- PNG (for visualization)

The intention is for users to be able to use a generated STL to 3D print
a jig or the DXF/SVG to generate a laser cuttable object for building a
stacking plate.

This project was originally generated while preparing for the DEF CON 27
badge ["da bomb"][badge] from [Team Ides][ides] and talking to [Fabienne
Serriére][fbz]

[badge]: https://github.com/netik/dc27_badge
[ides]: https://ides.team
[fbz]: https://twitter.com/fbz
[openscad]: http://www.openscad.org/
