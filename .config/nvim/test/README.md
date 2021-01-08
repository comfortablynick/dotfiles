# Neovim Tests

## How to run a test

(Taken from https://github.com/KillTheMule/KillTheMule.github.io/blob/master/test_plugins_from_neovim.md)

Once you've created a test file, say `myplug_spec.lua`, you can simply run
`TEST_FILE=/path/to/myplug_spec.lua make functionaltest` in the `neovim` directory. It will compile
neovim and all dependencies if necessary, and then run the test. If successful, the output will
look like

```txt
[----------] Global test environment setup.
[----------] Running tests from tmp_spec.lua
[ RUN      ] myplug basically works: 379.14 ms OK
[----------] 1 test from tmp_spec.lua (387.03 ms total)
[----------] Global test environment teardown.
[==========] 1 test from 1 test file ran. (387.13 ms total)
[  PASSED  ] 1 test.
```

If a test fails, the output might look like this

```txt
[----------] Global test environment setup.
[----------] Running tests from tmp_spec.lua
[ RUN      ] myplug basically works: ERR
./test/functional/ui/screen.lua:306: Row 1 did not match.
Expected:
  |*Ths is a {1:lin^e}                          |
  |{2:~                                       }|
  |{2:~                                       }|
  |{2:~                                       }|
  |                                        |
Actual:
  |*This is a {1:lin^e}                          |
  |{2:~                                       }|
  |{2:~                                       }|
  |{2:~                                       }|
  |                                        |

To print the expect() call that would assert the current screen state, use
screen:snapshot_util(). In case of non-deterministic failures, use
screen:redraw_debug() to show all intermediate screen states.

stack traceback:
        ./test/functional/ui/screen.lua:306: in function 'wait'
        ./test/functional/ui/screen.lua:220: in function 'expect'
        tmp_spec.lua:27: in function <tmp_spec.lua:23>
```
