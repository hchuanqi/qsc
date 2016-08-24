#!/bin/bash
# resetpw.sh
# reset password of a user
# usage: resetpw.sh <user>

# usage()
function usage()
{
    echo 'usage: resetpw.sh <user>'
}


if [[ -z $1 ]]; then
    usage
    exit 1
fi


# get confirmed
echo -n "Confirmed to reset the password of *$1* [yes|no] :"
read ANS
case $ANS in
    yes|YES)
        echo "Confirmed"
    ;;
    *)
        echo "Not Confirmed, exit ..."
        exit 1
    ;;
esac

# pw length
len=10
# char dictionary
char_list=( a b c d e f g h i j k l m n o p q r s t u v w x y z \
            A B C D E F G H I J K L M N O P Q R S T U V W X Y Z \
            0 1 2 3 4 5 6 7 8 9 \
            '@' '#' '$' '%' '^' '&' '*' '-' '+' '_')
# char dic length
char_n=${#char_list[@]}

# pw string
str=''

# generate output
for ((i=0; i<$len; i++)); do
    rand=$(od -An -N4 -D /dev/random)
    j=$(($rand % $char_n))
    str="${str}${char_list[$j]}"
done

echo "password of user $1 will be reset to:"
echo "$str"

if (echo "$str" | passwd --stdin $1); then
    echo "Reset successfully."
else
    echo "Reset failed."
    exit 1
fi

# done
# end of file
