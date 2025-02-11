#!/bin/bash
args=""
nameFlag=0
name=""
verboseFlag=0
ignore=""
for var in "$@"
do
    if [ $var == "-v" ]; then
        verboseFlag=1
    elif [ $var == "-o" ]; then
        if [ $nameFlag -ne 0 ]; then
            echo "Can't name twice"
            exit 1
        fi
        nameFlag=1
    else
        if [ $nameFlag -eq 1 ]; then
            name="$var"
            if [[ $name =~ .tar$ ]]; then
                nameFlag=2
            else
                echo "Name must be a .tar"
                exit 1
            fi
            
        else
            args="$args $var"
        fi
        
    fi
done
if [[ $nameFlag -eq 0 || $nameFlag -eq 1 ]]; then
    echo "name is required"
    exit 1
fi
if [ $verboseFlag -eq 1 ]; then
    for var in ${args[@]}
    do
        echo "--------Arguement '$var' Includes:-----------"
        ls $var
        echo ""
        ignore="$ignore -I $var"
    done
    echo "-----------The files not being included in the tar are:-------------"
    ls $ignore
    echo "-------------------------------------------------"
fi
tar -cvf $name $args
exit 0