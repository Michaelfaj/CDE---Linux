#!/bin/bash

# Set environment variable for the URL
CSV_URL="https://www.stats.govt.nz/assets/Uploads/Annual-enterprise-survey/Annual-enterprise-survey-2023-financial-year-provisional/Download-data/annual-enterprise-survey-2023-financial-year-provisional.csv"

# Create directories if they do not exist
mkdir -p "./raw"
mkdir -p "./Transformed"
mkdir -p "./Gold"

# Extract: Download the CSV file
echo "Starting the ETL process..."
echo "Extracting data from $CSV_URL..."

# Download the CSV file and save it into the raw folder using curl
curl -o "./raw/annual-enterprise-survey.csv" "$CSV_URL"

# Check if the file was downloaded successfully
if [ -f "./raw/annual-enterprise-survey.csv" ]; then
  echo "File successfully downloaded and saved in the raw folder."
else
  echo "File download failed. Exiting."
  exit 1
fi

# Transform: Process the CSV file
echo "Transforming the data..."

# Rename the column 'Variable_code' to 'variable_code' and select required columns
awk -F, '
  BEGIN {
    OFS = "," 
  }
  NR == 1 {
    # Save the header row
    for (i = 1; i <= NF; i++) {
      if ($i == "Variable_code") {
        var_code_col = i
        $i = "variable_code"
      }
      header[i] = $i
    }
    # Print the new header
    print "year", "Value", "Units", "variable_code"
  }
  NR > 1 {
    # Print only the required columns in the order: year, Value, Units, variable_code
    print $1, $2, $3, $var_code_col
  }
' "./raw/annual-enterprise-survey.csv" > "./Transformed/2023_year_finance.csv"

# Check if the transformation was successful
if [ -f "./Transformed/2023_year_finance.csv" ]; then
  echo "Data transformation completed successfully and saved in the Transformed folder."
else
  echo "Data transformation failed. Exiting."
  exit 1
fi

# Load: Move the transformed file to the Gold directory
echo "Loading the transformed data into the Gold directory..."
cp "./Transformed/2023_year_finance.csv" "./Gold/"

# Check if the file was loaded into the Gold folder
if [ -f "./Gold/2023_year_finance.csv" ]; then
  echo "File successfully loaded into the Gold directory."
else
  echo "File loading failed. Exiting."
  exit 1
fi

echo "ETL process completed successfully."
