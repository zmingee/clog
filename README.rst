clog
====

This is not a wooden shoe. It is a C logging library. It's very simple, very
basic. It simply provides a single macro function that lets you spit out a
reasonably formatted log message to ``stdout``.

Here is an example log message:

::

    [2018-01-01T09:00:30EST][INFO    ][src/main.c:test_log:20] This is a log message


Note
----

 I've had this library for at least a couple years now. A large portion (at
 least) is from one place, and then the rest of it is a mashup of other code. I
 do not remember when or where I got the pieces from, and I do not remember
 what licenses they were specifically, but it was all freely available on the
 web. If anyone knows where the original code pieces come from, I will be more
 than happy to accommodate the license to fit and make proper acknowledgements.


Note
----

 With that being said, the project is currently licensed under the MIT
 license.  It may or may not be adjusted in the future if the original
 author(s) are ever discovered.


Building
========

``clog`` does not have any dependencies outside what is available in a POSIX
environment.

::

    make clean
    make


The ``Makefile`` does not currently actually support installing the shared
library. It's a simple tweak, just give me a bit. If you're in a hurry,
just use the .c/.h files directly in your program for now.


Usage
=====

TODO
