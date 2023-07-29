# sqlite3-exts
Extensions/functions for SQLite3

## Extension: `hash_str`

Provides a simple string hashing function `hash_str( STR )`.

 
### Example Usage:
```shell
sqlite> .load ./libsqlexts.so
sqlite> SELECT hash_str( 'Hello, World!' );
-6390844608310610124
```
 
 
### Building
Change the lib extension from `.so` to `.dylib` on Darwin.
```shell
$ cc -shared -fPIC -O2 -g $( pkg-config --cflags --libs sqlite3; )  \
     -o libsqlexts.so ./hash_str.c;
``` 
