#!/bin/bash


show_line_numbers=false
invert_match=false


while getopts "nv" opt; do
  case "$opt" in
    n)
      show_line_numbers=true
      ;;
    v)
      invert_match=true
      ;;
    \?)
      echo "Usage: ./mygrep.sh [-n] [-v] search_string filename"
      exit 1
      ;;
  esac
done


shift $((OPTIND-1))


search_string="$1"
filename="$2"

if [[ -z "$search_string" || -z "$filename" ]]; then
  echo "Error: Missing search string or filename."
  echo "Usage: ./mygrep.sh [-n] [-v] search_string filename"
  exit 1
fi


if [[ ! -f "$filename" ]]; then
  echo "Error: File '$filename' not found."
  exit 1
fi

line_number=1  


if [[ $show_line_numbers == true && $invert_match == true ]]; then
   while IFS= read -r line; do
    flag=true
    for word in $line; do
      if [[ "$word" == "$search_string" ]]; then
        flag=false
        break
      fi
    done
    if [[ $flag == true ]]; then
       echo "Line $line_number: $line"
    fi
    ((line_number++))
  done < "$filename"


elif [[ $invert_match == true ]]; then
  while IFS= read -r line; do
    flag=true
    for word in $line; do
      if [[ "$word" == "$search_string" ]]; then
        flag=false
        break
      fi
    done
    if [[ $flag == true ]]; then
      echo "$line"
    fi
    ((line_number++))
  done < "$filename"

elif [[ $show_line_numbers == true ]]; then
    while IFS= read -r line; do
    for word in $line; do
      if [[ "$word" == "$search_string" ]]; then
        echo "Line $line_number: $line"
        break
      fi
    done
    ((line_number++))
  done < "$filename"

 
else
  while IFS= read -r line; do
    for word in $line; do
      if [[ "$word" == "$search_string" ]]; then
        echo "$line"
        break
      fi
    done
  done < "$filename"
fi
