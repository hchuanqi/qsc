#!/bin/bash
# randpasswd.sh
# generate random string
# usage: randpasswd.sh <string_length>

# usage()
function usage()
{
    echo 'usage: resetpasswd.sh <string_length>'
}

# output string length
if [[ -n $1 ]]; then
    len=$1
    if (($len <= 0)); then
        usage
        exit
    fi
else
    usage
    exit
fi

# char dictionary
char_list=( a b c d e f g h i j k l m n o p q r s t u v w x y z \
            A B C D E F G H I J K L M N O P Q R S T U V W X Y Z \
            0 1 2 3 4 5 6 7 8 9 \
            '@' '#' '$' '%' '^' '&' '*' '-' '+' '_')
# char dic length
char_n=${#char_list[@]}

# output string
str=''

# generate output
for ((i=0; i<$len; i++)); do
    rand=$(od -An -N4 -D /dev/random)
    j=$(($rand % $char_n))
    str="${str}${char_list[$j]}"
done

# echo
echo "$str"

# end of file
