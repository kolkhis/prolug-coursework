#!/bin/rbash

PATH=/bin:/usr/bin

declare INPUT
read -r -n 2 -t 20 -p "Welcome!
Select one of the following:

1. Connect to DestinationHost
2. Exit

> " INPUT
case $INPUT in
  1)
      printf "Going to DestinationHost.\n"
      ssh freeuser@destinationhost
      exit 0
      ;;
  2)
      printf "Leaving now.\n"
      exit 0
      ;;
  *)
      printf "Unknown input. Goodbye.\n"
      exit 0
      ;;
esac
exit 0



