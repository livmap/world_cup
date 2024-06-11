#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

FILE="games.csv"

if [[ ! -f "$FILE" ]]; then
    echo "File not found!"
    exit 1
fi

# Read the CSV file

while IFS=',' read -r YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
    IN_W=$($PSQL "SELECT COUNT(*) FROM teams WHERE name='$WINNER';")
    IN_O=$($PSQL "SELECT COUNT(*) FROM teams WHERE name='$OPPONENT';")

    if [[ $YEAR != "year" ]]
    then 
    if [[ IN_W -eq 0 ]]
    then
    echo $($PSQL "INSERT INTO teams(name) VALUES('$WINNER');")
    fi

    if [[ IN_O -eq 0 ]]
    then
    echo $($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT');")
    fi
    fi


done < "$FILE"

while IFS=',' read -r YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
    W_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER';")
    O_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT';")

    if [[ $YEAR != "year" ]]
    then 
    echo $($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $W_ID, $O_ID, $WINNER_GOALS, $OPPONENT_GOALS);")
    fi


done < "$FILE"

