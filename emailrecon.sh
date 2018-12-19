#!/bin/bash

clear
echo ""
echo ".=========================================================."
echo "|                                                         |"
echo "|                      EMAILRECON                         |"
echo "|                   ________________                      |"
echo "|                  |\              /|                     |"
echo "|             ___  | \            / |                     |"
echo "|          ______  | /\__________/\ |                     |"
echo "|             ___  |/              \|                     |"
echo "|                  |________________|                     |"
echo "|                                                         |"
echo "|  ---------------------------------------------------    |"
echo "|                                                         |"
echo "|                 Version: 0.1 (Alpha)                    |"
echo "|                                                         |"
echo ".=========================================================."
echo ""
echo ""
echo "Usage: [domainName].[domain]"
echo "Example: rapid7.com"

Repeat()
{
	read -p "Do you want to search another domain? (y/n)?" opt
    case "$opt" in
        y|Y ) Find;;
        n|N ) End;;
        * ) echo "Invalid inout, please andswer with "y" or "n"";;
    esac
}
Find(){
echo ""
if [ -z $1 ]
 then
  echo -n "Domain:"
  read DOMAIN
else
  DOMAIN=_
fi
echo ""
echo "Searching for emails at $DOMAIN"
URL="http://www.sky"
URK="mem.info/srch?q"
URT="&ss=srch"
URI="$URL$URK=$DOMAIN$URT"
lynx -dump $URI > new.tmp | sed --silent 's/\[*\]/ /g'
grep -rIhEo "\b[a-zA-Z0-9.-]+@[a-zA-Z0-9.-]+\.[a-zA-Z0-9.-]+\b" new.tmp > emails.txt
rm new.tmp
DOMAIN="\"@$DOMAIN\""
URL="https://duckduckgo.com/html/?q"
URI="$URL=$DOMAIN"
lynx -dump $URI > gone.tmp | sed --silent 's/\[*\]/ /g'
grep -rIhEo "\b[a-zA-Z0-9.-]+@[a-zA-Z0-9.-]+\.[a-zA-Z0-9.-]+\b" gone.tmp >> emails.txt
rm gone.tmp
sort -u emails.txt | uniq -u -i > output.tmp
rm emails.txt
awk '!/skymem/' output.tmp > output2.tmp
awk '!/duckduck/' output2.tmp > email_output.tmp
cat email_output.tmp >> email_output.txt
echo ""
echo "Here are the results of the search"
echo ""
cat email_output.tmp
echo ""
echo "Output is saved at [current folder]/email_output.txt"
echo ""
rm email_output.tmp
rm output.tmp
Repeat 
}
Full() {
if [ -z $1 ]
then
 echo ""
 echo ""
 echo -n "First Name: "
 read FNAME
else
 FNAME=_
fi
if [ -z $1 ]
then
 echo -n "Second Name: "
 read SNAME
else
 SNAME=_
fi
if [ -z $1 ]
 then
  echo -n "Domain:"
  read DOMAIN
else
  DOMAIN=_
fi
URL="http://www.skymem.info/srch?q"
URT="&ss=srch"
URI="$URL=$DOMAIN$URT"
lynx -dump $URI > new.tmp | sed --silent 's/\[*\]/ /g'
grep -rIhEo "\b[a-zA-Z0-9.-]+@[a-zA-Z0-9.-]+\.[a-zA-Z0-9.-]+\b" new.tmp > emails.txt
rm new.tmp
DOMAIN="\"@$DOMAIN\""
echo ""
echo "Searching for $FNAME's email address..."
echo ""
URL="https://duckduckgo.com/html/?q"
URI="$URL=$FNAME+$SNAME+$DOMAIN"
lynx -dump $URI > gone.tmp 
if grep -rIhEo "\b[a-zA-Z0-9.-]+@[a-zA-Z0-9.-]+\.[a-zA-Z0-9.-]+\b" gone.tmp
  then >> emails
  cat emails
  echo ""
  echo "Search complete"
else
  echo "Sorry, nothing was found"
fi
rm gone.tmp
Repeat
}
Person(){
read -p "Do you know the persons's name? (y/n)?" opt
    case "$opt" in
        y|Y ) Full;;
        n|N ) Option;;
        * ) echo "invalid";;
    esac
}
Option(){
read -p "Do you want to search for a specific person? (y/n)?" opt
    case "$opt" in
        y|Y ) Full;;
        n|N ) Find;;
        * ) echo "invalid";;
    esac
}
End(){
exit
}
Option