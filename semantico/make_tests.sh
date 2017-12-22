FILES="aritmeticas1 aritmeticas2 comparaciones error_ej1 error_ej2 error_se1 error_se2 error_se3 error_se4 error_se5 error_se6 error_se7 error_se8  error_se9 error_se10 error_se11 error_se12 error_se13 error_se14 error_se15 funciones1 funciones2 funciones3 funciones4 if1 if2 if3 logicas1 logicas2 vectores1 vectores2 vectores3 vectores4 while"

for file in $FILES
do
echo $file
./alfa tests_gon/$file.alf output/$file.asm
done

for file in $FILES
do
nasm -g -felf32 output/$file.asm
gcc -m32 -o output/ex/$file -g alfalib.o output/$file.o
done
