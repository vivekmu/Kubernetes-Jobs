#! /bin/bash
LOOP_COUNT=1
echo "This Job will echo message $LOOP_COUNT times"

for ((i=1;i<=$LOOP_COUNT;i++)); 
do
   echo  "ran for $i time"
