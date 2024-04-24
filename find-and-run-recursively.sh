echo "***************************************"
echo "find \$FOLDER -mindepth \$MINDEPTH -maxdepth \$MAXDEPTH -type d_f_l -name \"\$PATTERN\" | while read item; do echo \"\$item\"; done"
echo "***************************************"

echo "To find in which path? Enter [root path] or [leave blank] for the current path [[`pwd`]]:"
read -p ">>> " FIND_FOLDER
if [ ! "$FIND_FOLDER" ]
then
  FIND_FOLDER=`pwd`
fi

read -p "mindepth >>> " MINDEPTH
if [ "$MINDEPTH" ]
then
  MINDEPTH_CLAUSE="-mindepth $MINDEPTH"
fi
read -p "maxdepth >>> " MAXDEPTH
if [ "$MAXDEPTH" ]
then
  MAXDEPTH_CLAUSE="-maxdepth $MAXDEPTH"
fi

echo "To find file or directory? [f] for file, [d] for directory, [l] for link, [anything else] for all:"
read -p ">>> " FIND_TYPE
if [ "$FIND_TYPE" = 'f' ] || [ "$FIND_TYPE" = 'd' ] || [ "$FIND_TYPE" = 'l' ]
then
  FIND_TYPE_CLAUSE="-type $FIND_TYPE"
fi

echo "To match pattern: [regex pattern] (e.g. '._*', '.*.js') or or [leave blank] for all:"
read -p ">>> " FIND_PATTERN
if [ ! "$FIND_PATTERN" ]
then
  FIND_PATTERN="*"
fi

echo "To do something on each: [command line] or [leave blank] for 'echo':"
read -p ">>> " FIND_ACTION
if [ ! "$FIND_ACTION" ]
then
  FIND_ACTION='echo'
fi

echo "***************************************"
echo "find $FIND_FOLDER $MINDEPTH_CLAUSE $MAXDEPTH_CLAUSE $FIND_TYPE_CLAUSE -name \"$FIND_PATTERN\" | while read item; do $FIND_ACTION \"\$item\"; done"
echo "***************************************"

find $FIND_FOLDER $MINDEPTH_CLAUSE $MAXDEPTH_CLAUSE $FIND_TYPE_CLAUSE -name "$FIND_PATTERN" | while read item; do $FIND_ACTION "$item"; done