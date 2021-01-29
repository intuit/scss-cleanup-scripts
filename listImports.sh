  #!/bin/bash

  read -p "##### What folder do you want to scan for CSS dependencies? (default: src/sass) " SCSS_FOLDER
  SCSS_FOLDER=${SCSS_FOLDER:-src/sass}

  if [ ! -d "$SCSS_FOLDER" ]; then
    echo "##### The folder $SCSS_FOLDER does not exist."
  else
    echo "##### Scanning  folder $SCSS_FOLDER..."

    SCSS_FILES=$(find "$SCSS_FOLDER" -name "*.scss")

    echo "##### Scanning files for imports...";
    for FILE in $SCSS_FILES; do
      echo -e "\nin $FILE";
      COUNTIMPORTS=0;

      while read -r oneLine; do
        IMPORTS=$(echo "$oneLine" | grep '\@import *');
        if [[ ! -z $IMPORTS ]]; then
          echo $IMPORTS;
          COUNTIMPORTS=$((COUNTIMPORTS+1));
        fi
      done < $FILE;

      if [[ $COUNTIMPORTS -eq "0" ]]; then
        echo "--- no imports";
      fi
    done;
  fi