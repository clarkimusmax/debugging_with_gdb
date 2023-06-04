# Debugging W/ GDB
An extremely brief guide to some gdb commands that I find useful.  

## Getting Started
Run `make`  

## Starting GDB
Start program with GDB: `gdb ./hello`  
Start program with arguments with GDB: `gdb --args ./hello 1 2 3`  
Attach to program with GDB: `./hello & gdb -p $!; kill $!`  

## Controlling Execution

### Starting a Program
Start a program: `r` ("run")  
Start a program with a breakpoint at main(): `start`  

### Finish Debugging
End program: `kill`  
Send signal to program: `signal SIGSEGV` (`man 7 signal` for more options)  
Detach from program: `detach`  
Detach from program: `[CTRL]+d`  

### Stopping a Program
Stop program: `[CTRL]+c` (GDB will trap this signal by default)  

### Stepping a Progam
Step one line of code: `s` ("step", will enter functions)  
Step one instruction: `si` ("step instruction", will enter functions)  
Step one line of code: `n` ("next", will not enter functions)  
Step one instruction: `ni` ("next instruction", will not enter functions)  
Step out of function: `finish`  
Continue execution: `c` ("continue")  

### Setting Breakpoints
Break on function: `br main` (or other function name)  
Break at line of file: `br hello.c:2`  
Break at address: `br *0x7ffff7e37e1b`  
View breakpoints: `i br` ("info breakpoints")  
Delete breakpoint: `del 2`  
Delete all breakpoints: `del`  
Set command(s) to run at breakpoint (after `commands` enter commands and end with `end`):
```
br hello.c:2
commands
x/32a $esp
x/10i $eip
end
```

## Gaining Bearing
Show call stack: `bt` ("backtrace")  
Change stack frame perspective: `frame 2` (will allow you to view another stack frame's locals and other info)  
Show threads: `i threads` ("info threads")  
Switch thread: `thread 2` (run `bt` again to get thread's call stack)  

## Viewing Data
View local variables: `i lo` ("info locals")  
View function arguments: `i args`  
Print variable: `print my_var`  
Print structure members: `print my_struct`  
Print registers: `i r` ("info registers")  
Print 10 addresses from the stack pointer: `x/10a $rsp`  
Print 20 instructions from the instruction pointer: `x/20i $rip`  
Print string pointed to by RDI: `x/s $rdi`  
Print assembly for current function: `disassemble`  
Print assembly for a function: `disassemble main`  

## Misc
Display assembly in inferior syntax: `set disassembly-flavor intel`  
Break on write to variable: `watch my_var`  
View loaded shared libraries: `i sharedlibrary` (unfortunately lacks pages & permissions)  
Drop to shell from GDB: `shell`  
	View process' memory maps: `cat /proc/[PID]/maps` (does have pages & permissions)  
Toggle the zero flag: `set $eflags ^= (1 << 6)` (useful for forcing a program to take/not take a branch)  
Print 10 lines of code:	`list`  
LD_PRELOAD a shared object: `set exec-wrapper env 'LD_PRELOAD=/path/to/libc.so.6'`  
Call an arbitrary function: `call (char*) getenv("PATH")`  
When stopped at a return, print disassembly at address on stack: `x/20i *(long*)$esp`   
Enable writing to the debugged program: `gdb --write [program]` or `set write on` within GDB   
Run program with input in GDB with minimal environment (useful for ensuring address consistency):  
```
env -i PWD=$PWD SHELL="/bin/bash" gdb /full/path/to/program`
r < program_input
```
Run program with minimal environment (useful for ensuring address consistency):  
```
cat program_input | env -i PWD=$PWD SHELL="/bin/bash" /full/path/to/program
```
Unset environment variables that GDB sets by default (useful for ensuring address consistency):
```
unset environment LINES
unset environment COLUMNS
```  

## Signal Handling
View signal handling information: `i signal`  
Set catchpoint for signal: `catch signal SIGUSR1`  
Ignore signal (gdb does not stop and signal is not passed to program): `handle SIGALRM nostop ignore`  

## Controlling Time Itself
Set `LD_BIND_NOW=1` to force symbol resolution at load time when running the debugger: `LD_BIND_NOW=1 gdb ./hello` (try the following without this to see why)  
Start your program and tell GDB to start recording execution: `record`  
Step a few times until you're a little ways into you program and then tell gdb to time-travel:  
- `rn` ("reverse-next")  
- `rni` ("revese-next-instruction")  
- `rs` ("reverse-step")  
- `rsi` ("reverse-step-instruction")  
- `reverse-finish`  
- `rc` ("reverse-continue") 
  
(Note: If you see an error like "Target native does not support this command.", you probably forgot to tell gdb to record.)  
  
Try reverse-debugging (also known as "time travel debugging") the "crash" program  
