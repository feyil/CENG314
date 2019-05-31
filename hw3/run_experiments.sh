#!/bin/bash

runner() {
    RESULT_FILE="results.txt"

    for i in $@
        do
            echo "$i optimized version running"
            echo "$i optimized version runned" >> $RESULT_FILE
            AVERAGE=0
            for j in {1..10}
                do
                    RESULT=$(./$i)
                    A=$(cut -d' ' -f6 <<< $RESULT)
                    echo "  $j. Execution Result: $A sn" >> $RESULT_FILE
                    echo " $j.run executed in $A sn"  
                
                    #summation stuff
                    AVERAGE=$(bc <<< "scale=5; ($A + $AVERAGE)")
                done
            AVERAGE=$(bc <<< "scale=5; ($AVERAGE / 10)")
            echo "$i average result calculated: $AVERAGE sn" >> $RESULT_FILE
            echo "$i average: $AVERAGE sn"
        done
}

create_base() {
    if [ -d $1 ]; then
        rm -rf $1
        mkdir $1
    else
        mkdir $1
    fi
}


# - - - - - - - - - - - Start of first part - - - - - - - - - - - -
echo "FIRST PART STARTED"

# Create base for first part
create_base "first_part"

cd first_part

# First part compile each optimization level with gcc compiler
gcc -O0 ../mul.c -o mul_O0
gcc -O1 ../mul.c -o mul_O1
gcc -O2 ../mul.c -o mul_O2
gcc -O3 ../mul.c -o mul_O3
gcc -Ofast ../mul.c -o mul_Ofast

# Execute each version 10 times
runner mul_O0 mul_O1 mul_O2 mul_O3 mul_Ofast

cd ..
echo "FIRST PART FINISHED"
# End of first part



# - - - - - - - - - - - Start of second part - - - - - - - - - - - -
echo "SECOND PART STARTED"

# Create base for second part
create_base "second_part"

cd second_part

# Second part compile necessary C files
# Default optimization -O0
gcc ../mul.c -o mul
gcc -O3 ../mul.c -o mul_O3

gcc ../mul_no_fc.c -o mul_no_fc
gcc -O3 ../mul_no_fc.c -o mul_no_fc_O3

gcc ../mul_no_fc_temp.c -o mul_no_fc_temp
gcc -O3 ../mul_no_fc_temp.c -o mul_no_fc_temp_O3

gcc ../mul_no_fc_temp_unrolled.c -o mul_no_fc_temp_unrolled
gcc -O3 ../mul_no_fc_temp_unrolled.c -o mul_no_fc_temp_unrolled_O3

# Execute each version 10 times
runner mul mul_O3 mul_no_fc mul_no_fc_O3 mul_no_fc_temp mul_no_fc_temp_O3 mul_no_fc_temp_unrolled mul_no_fc_temp_unrolled_O3

cd ..
echo "SECOND PART FINISHED"
# End of second part


echo "ALL EXPERIMENTS DONE"
echo "CHECK YOUR DIRECTORY FOR THE OUTPUTTED RESULTS"