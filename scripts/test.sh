name ()
{
    input_string=$1
    second_string=$2
    notify-send "Input string: $input_string" "$second_string"
}

name "test 1" "test 2"
