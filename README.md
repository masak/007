# 007

A small language. A test bed for macro ideas.

## TODO

* `typeof()`
* EXPR parser
* subroutines for ops
* [man or boy](https://en.wikipedia.org/wiki/Man_or_boy_test)
* BEGIN blocks
* constants
* making Q:: types first-class values
* macros
* quasi blocks
* unquotes

Dependency graph for some important todo items:

                    EXPR parser     BEGIN blocks
                      /                 |
        subroutines for ops         constants           first-class Q::
                        \               |                /    |
                         \----------macros--------------/   quasi
                                         \                    |
                                          \-----------------unquotes
