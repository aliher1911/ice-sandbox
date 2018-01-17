# Experiments with ice40 using yosys flow

## To make firmware

make

## To run testbenches

make test

## To load firmware onto ice stick

make prog

On mac os you need to unload apple serial kext beforehand and then load it back to launch minicom to talk to stick

## Additional configuration

If html view generator is not in path, it can be added as variable to optional config.mk file

## Notes

tests only generate vsd files for viewing, not making any asserts
