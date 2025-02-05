# ZigDeezNutS - Zig DNS

## run (or build)
to run or build the executable, you have to link c library (if present on system); hence the -lc parameter
```bash
zig run -lc src/main.zig
# or
zig build-exe -lc src/main.zig
````

## verify its working
```bash
echo "should print on std" | nc -u 127.0.0.1 2048
```

