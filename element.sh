#! /bin/bash

PSQL="psql -U freecodecamp -d periodic_table -t -A -c"

if (($# == 0)); then
  echo "Please provide an element as an argument."
else
  if [[ "$1" =~ ^[0-9]+$ ]]; then
    ELEMENT=$($PSQL "select atomic_number, symbol, name from elements where atomic_number='$1'")
  else
    ELEMENT=$($PSQL "select atomic_number, symbol, name from elements where name='$1' or symbol='$1' limit 1")
  fi

  if [ -z "$ELEMENT" ]; then
    echo "I could not find that element in the database."
  else
    IFS="|" read -r ATOMIC_NUMBER SYMBOL NAME <<< "$ELEMENT"
    IFS="|" read -r ATOMIC_MASS TYPE MPC BPC < <($PSQL "select p.atomic_mass, t.type, p.melting_point_celsius, p.boiling_point_celsius from properties as p inner join types as t on p.type_id = t.type_id where p.atomic_number='$ATOMIC_NUMBER'")
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MPC celsius and a boiling point of $BPC celsius."
  fi
fi