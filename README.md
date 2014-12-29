ec
==

C code generator to numerically solve ordinary differential equations

Work in progress, but is usable as of 12/29/2014.
To build ec, run make. Requires Bison and Flex.
To generate C code from a source (filename.ec), run
./ec filename.ec > filename.c

Future versions will direct output to a file without needing the redirect
