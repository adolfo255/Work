#!/bin/bash
while getopts ":s:,:f:,:d:,:p:" opt; do
  case $opt in
    s)
        size="$OPTARG"
      ;;
    f)
        file="$OPTARG"
      ;;
    p)
        prefix="$OPTARG"
      ;;
    d)
        dest="$OPTARG"
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      ;;
  esac
done

if [ ! -d "$dest" ]; then

  # Control will enter here if $DIRECTORY doesn't exist.
  mkdir $dest
fi
split --bytes=$size $file $dest/$prefix --verbose
cd $dest
gzip *
