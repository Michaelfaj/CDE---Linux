#!/bin/bash

# Configuration
DATABASE="posey"
USER="root"
PASSWORD="College419**"
HOST="127.0.0.1"
CSV_FOLDER="C:/Users/User/Desktop/CDE/git_linux_ass/Scripts/Bash_scripts/parch_and_possay"

# MySQL command
MYSQL_CMD="mysql -u $USER -p$PASSWORD -h $HOST $DATABASE"

# Iterate over each CSV file in the folder
for CSV_FILE in "$CSV_FOLDER"/*.csv; do
    # Extract the filename without path and extension
    TABLE_NAME=$(basename "$CSV_FILE" .csv)
    
    echo "Processing $CSV_FILE..."
    
    # Create table with a basic structure
    echo "CREATE TABLE IF NOT EXISTS $TABLE_NAME (id INT AUTO_INCREMENT PRIMARY KEY, data TEXT);" | $MYSQL_CMD || { echo "Failed to create table $TABLE_NAME"; exit 1; }

    # Load CSV into the table
    echo "LOAD DATA LOCAL INFILE '$CSV_FILE' INTO TABLE $TABLE_NAME
    FIELDS TERMINATED BY ',' 
    OPTIONALLY ENCLOSED BY '\"' 
    LINES TERMINATED BY '\n' 
    IGNORE 1 LINES;" | $MYSQL_CMD || { echo "Failed to load data from $CSV_FILE"; exit 1; }

    echo "$CSV_FILE imported into table $TABLE_NAME"
done

echo "All CSV files have been processed."
