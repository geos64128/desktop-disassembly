64tass ./record1.tas -l ./target/record1.lbl -L ./target/record1.lst -o ./target/record1
64tass ./record2.tas -l ./target/record2.lbl -L ./target/record2.lst -o ./target/record2
64tass ./record3.tas -l ./target/record3.lbl -L ./target/record3.lst -o ./target/record3
64tass ./record4.tas -l ./target/record4.lbl -L ./target/record4.lst -o ./target/record4
64tass ./record5.tas -l ./target/record5.lbl -L ./target/record5.lst -o ./target/record5
64tass ./record6.tas -l ./target/record6.lbl -L ./target/record5.lst -o ./target/record6
gcc createcvt.c -o ./target/createcvt.exe
cd target
createcvt.exe

xc1541 -format "geos desktop,sh" d64 ./target/geos-desktop.d64
xc1541 -attach ./target/64-to-vdc.d64 -write ./target/64-to-vdc 64-to-vdc
