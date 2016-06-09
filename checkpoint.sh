# Ugly but effective defense against code corruption. See sync_lib.sh for usage. 

# Usage
#    checkpoint.sh <label> <code_dir> <checkpoint_directory>
#    checkpoint.sh just_before_sync


label=${1:-manual}
USER=$(whoami)
CODE_DIR=${2:-"/Users/$USER/project/lib"}
CHECKPOINT_DIR=${3:-"/Users/${USER}/project/lib_checkpoints"}         # Modify as you see fit, obviously

echo "Checkpointiong ${CODE_DIR} to ${CHECKPOINT_DIR}/${label}"

for (( v=100; v>=1; v--)); do
   # v is the version number, w is the previous version number
   declare -i w
   declare -i w1
   w=$v-1
   w1=$w-1

   # Is there anything to copy?
   if [[ -e $CHECKPOINT_DIR/${label}/lib_previous-$w ]]; then
       if [ "$(ls -A $CHECKPOINT_DIR/${label}/lib_previous-$w)" ]; then
           # Create a new directory if need be to store increasingly older versions of the code
           if [[ ! -e $CHECKPOINT_DIR/${label}/lib_previous-$v ]]; then
               mkdir $CHECKPOINT_DIR/${label}/lib_previous-$v
               echo "mkdir $CHECKPOINT_DIR/${label}/lib_previous-$v"
               echo "cp -R $CHECKPOINT_DIR/${label}/lib_previous-$w/* $CHECKPOINT_DIR/${label}/lib_previous-$v"
               echo "cp -R $CHECKPOINT_DIR/${label}/lib_previous-$w1/* $CHECKPOINT_DIR/${label}/lib_previous-$w"
               echo " ... and so on until ... "
           else
               rm -rf $CHECKPOINT_DIR/${label}/lib_previous-$v/*
               #echo "rm -rf $CHECKPOINT_DIR/${label}/lib_previous-$v/*"
           fi
           if [ $v -lt 3 ]; then
               echo "cp -R $CHECKPOINT_DIR/${label}/lib_previous-$w/* $CHECKPOINT_DIR/${label}/lib_previous-$v"
           fi
           cp -R $CHECKPOINT_DIR/${label}/lib_previous-$w/* $CHECKPOINT_DIR/${label}/lib_previous-$v
       fi
   fi

done

echo "cp -R /Users/$USER/project/lib/* $CHECKPOINT_DIR/${label}/lib_latest"
cp -R $CHECKPOINT_DIR/${label}/lib_latest/* $CHECKPOINT_DIR/${label}/lib_previous-0
rm -rf $CHECKPOINT_DIR/${label}/lib_latest/*

# Finally ... checkpoint the current verion of code
cp -R /Users/$USER/project/lib/* $CHECKPOINT_DIR/${label}/lib_latest

# And there is no need to keep these ...
if [ -a $CHECKPOINT_DIR/${label}/lib_latest/domino.log ]; then
   rm $CHECKPOINT_DIR/${label}/lib_latest/domino.log
fi
