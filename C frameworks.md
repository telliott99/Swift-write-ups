## Frameworks and Libraries

This is an attempt to organize what I know about using Frameworks and Libraries for macOS, all in one place.

In this first part, we look at classic C libraries.  After that, we'll implement libraries that are called from Objective-C code, and in the last section we'll look into calling them from Swift code as well as writing Swift frameworks.

One thing I've noticed in doing such tests is that one can easily be confused into thinking something you tried works, but it turns out to be using files left over from a previous attempt.  Therefore the first thing we'll do is  to make two directories on the Desktop:

```bash
> cd Desktop
> mkdir build
> mkdir src
```

We will copy into ``src`` the code files we'll be using 

```bash
> pwd
/Users/telliott_admin/Desktop
> ls src
add.h		add2.c		useadd.c
add1.c		test.c
```

To perform any of the steps ahead we will work in the ``build`` directory, and erase the whole thing before we start, then copy in the files from ``src``

```bash
> cd build
> rm -r * && cp ../src/* . && ls
add.h		add2.c		useadd.c
add1.c		test.c
>
```

### Classic C

#### Method 1:  Single file

**test.c**

```c
#include <stdio.h>

int f1(int);

int f1(int x){
    printf( "f1: %d;", x );
    return x+1;
}

int main(int argc, char** argv){
    printf("test:\n");
    printf("  main %d\n", f1(1));
    return 0;
}
```

```css
> clang -g -Wall test.c -o prog && ./prog
test:
f1: 1;  main 2
>
```

<hr>

#### Method 2:  Separate source .c files

**add.h**

```c
int f1(int);
int f2(int);
```

**add1.c**

```c
#import <stdio.h>

int f1(int x) {
    printf( "f1: %d; ", x );
    return x+1;
}
```

**add2.c**

```c
#import <stdio.h>

int f1(int x) {
    printf( "f2: %d; ", x );
    return x+2;
}
```

**useadd.c**

```c
#import <stdio.h>
#import "add.h"

int main(int argc, char** argv){
    printf("  main %d\n", f1(1));
    printf("  main %d\n", f2(10));
    return 0;
}
```
Build them

```bash
> clang -g -Wall -c add*.c
> clang -g -Wall useadd.c add1.o add2.o -o useadd
> 
```

to generate **add1.o** and **add2.o**.  Then

```bash
> ./useadd
useadd
f1: 1;  main 2
f2: 10;  main 12
>
```

<hr>

#### Method 3:  static C library

Remember to delete **useadd** and restore ``build``

```bash
> rm -r * && cp ../src/* . && ls
add.h		add2.c		useadd.c
add1.c		test.c
> 
```

We make these functions into an old-fashioned C library:

```bash
> clang -g -Wall -c add*.c
> libtool -static add*.o -o libadd.a
>
```

And use it like this:

```bash
> clang -g -Wall -o useadd useadd.c -L. -ladd
> ./useadd
useadd
f1: 1;  main 2
f2: 10;  main 12
>
```

Here we have explicitly directed ``clang`` with ``-L.`` to look within the build directory (i.e. ``.``) for ``-ladd``, which is short for ``libadd``.

Before you erase everything in ``build``, first copy ``libadd.a`` into ``~/Library/Frameworks``.

```bash

```

<hr>

#### Method 4:  static library from ~/Library/Frameworks

The goal is to make a Cocoa app that uses ``f1`` and ``f2`` ... whether written in Objective C or in Swift.  I thought at first we would need a framework, but we don't. Follow these four steps.

* First, copy ``libadd.a`` into ``~/Library/Frameworks``:

```bash
> cp libadd.a ~/Library/Frameworks
> ls ~/Library/Frameworks/l*
/Users/telliott_admin/Library/Frameworks/libadd.a
>
```

* Now, make a new Xcode project Myapp on the Desktop, a Cocoa app in **Objective C**. Add the library to the project by clicking + on Linked Frameworks and Libraries, with the project selected in the project navigator.  Navigate to ```~/Library/Frameworks/libadd.a``` and select it.

* Add the header file ``add.h`` to the new Cocoa project.  A good way to do this is to first copy the file into the project directory that contains source files, and then add it by using AddFiles.  

* In the AppDelegate (either ``AppDelegate.h`` or ``AppDelegate.m``) do 

```c
#include "add.h"
```

In **applicationDidFinishLaunching** call the functions, e.g. here ``f1``

```c
int x = f1(1);
printf("AD: %d;", x);
```

The debug panel will log

```bash
f1: 1; AD: 2;
```

It works!

In the previous version I also showed how to build and use a dynamic library.  That all still works.

<hr>

#### Method 5:  dynamic library from ~/Library/Frameworks

```bash
> rm -r * && cp ../src/* . && ls
> clang -g -Wall -c add*.c
> clang -dynamiclib -current_version 1.0  add*.o  -o libadd.dylib
> clang useadd.c ./libadd.dylib -o useadd
> ./useadd
useadd
f1: 1;  main 2
f2: 10;  main 20
>
```

```bash
> otool -L libadd.a
Archive : libadd.a
libadd.a(add1.o):
libadd.a(add2.o):
> otool -L libadd.dylib
libadd.dylib:
	libadd.dylib (compatibility version 0.0.0, current version 1.0.0)
	/usr/lib/libSystem.B.dylib (compatibility version 1.0.0, current version 1226.10.1)
>
```

To use it we *may* also compile `useadd.c` to an object .o file.

```bash
> clang -c useadd.c
> clang useadd.o ./libadd.dylib -o useadd
> ./useadd
useadd
f1: 1;  main 2
f2: 10;  main 20
>
```
