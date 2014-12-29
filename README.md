ec
==

C code generator to numerically solve ordinary differential equations

To build ec, run make. Requires Bison and Flex.
To generate C code from a source (repository includes spring.ec as an example), run
./ec spring.ec > spring.c

Future versions will direct output to a file without needing the redirect
