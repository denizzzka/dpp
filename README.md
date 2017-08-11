include
========

include is an executable that has as input a D file with C `#include` preprocessor directives and outputs
a valid D file that can be compiled. The original can't be compiled since D has no integrated preprocessor.

The only supported preprocessor directive is `#include`.

The input file may also use C preprocessor macros defined in the file(s) it ``#include`s, just as a C/C++
program would. It may not, however, define macros of its own.

include goes through the input file line-by-line, and upon encountering an `#include` directive, parses
the file to be included with libclang, loops over the definitions of data structures and functions
therein and expands in-place the relevant D translations. e.g. if a header contains:

uint16_t foo(uin32_t a);

The output file will contain:

ushort foo(ushort a);

include will also enclose each one of these original `#include` directives with either
extern(C) {} or extern(C++) {} depending on the header file name and/or command-line options.

As part of expanding the `#include`, and as well as translating declarations, include will also
insert text to define macros originally defined in the `#include`d translation unit so that these
macros can be used by the D program. The reason for this is that nearly every non-trivial
C API requires the preprocessor to use properly. It is possible to mimic this usage in D
with enums and CTFE, but the result is not guaranteed to be the same. The only way to use a
C or C++ API as it was intended is by leveraging the preprocessor.

As a final pass before writing the output file, include will run the C preprocessor on the
intermediary result of expanding all the `#include` directives so that any used macros are
expanded, and the result is a D file that can "natively" call into a C/C++ API by
`#include`ing the appropriate header(s).

Example
-------

This should work:

foo.h:

```c
// foo.h
#ifndef FOO_H
#define FOO_H

#define FOO_ID(x) (x*3)

int twice(int i);

#endif
```

foo.d.tmp:

```d
// foo.d.tmp
#include "foo.h"
void main() {
    import std.stdio;
    writeln(twice(FOO_ID(5)));
}
```

At the shell:

```
$ ./include foo.d.tmp foo.d
$ dmd foo.d
$ ./foo
$ 30
```
