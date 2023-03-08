PREFIX=%miki
SUFFIX=miki%

echo sed -i '' "s/$/$SUFFIX/"
if  [ "$(uname)" = "Darwin" ]
then
  LC_CTYPE='C' sed -i '' "s/^/$PREFIX/" $1
  LC_CTYPE='C' sed -i '' "s/$/$SUFFIX/" $1
else
  sed -i "s/^/$PREFIX/" $1
  sed -i "s/$/$SUFFIX/" $1
fi
