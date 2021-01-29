  #/bin/bash
  COUNTER=0

  read -p "##### What folder do you want to scan for unused scss files? (default: src/sass) " SCSS_FOLDER
  SCSS_FOLDER=${SCSS_FOLDER:-src/sass}

  if [ ! -d "$SCSS_FOLDER" ]; then
    echo "##### The folder $SCSS_FOLDER does not exist."
  else
    echo "##### scanning $SCSS_FOLDER for unused scss files...";
    
    # Change scss to css, if you want to target CSS files instead
    find "$SCSS_FOLDER" -type f -exec basename {} \; | grep -iE "\.scss$" >> fileList.txt;

    while read -r FILENAME; do

      FILENAME_NO_EXT=${FILENAME//\.scss/};

      IS_USED=$(grep -R "$FILENAME" "$SCSS_FOLDER");
      [[ $FILENAME_NO_EXT =~ ^_ ]]  && FILENAME_NO_UNDERSCORE="${FILENAME_NO_EXT:1}" || FILENAME_NO_UNDERSCORE="NULL"

      IS_USED_AS_IMPORT=$(grep -R '@import *' $SCSS_FOLDER | grep "$FILENAME_NO_EXT\|$FILENAME_NO_UNDERSCORE");

      if [[ -z $IS_USED ]] && [[ -z $IS_USED_AS_IMPORT ]]; then
        COUNTER=$((COUNTER+1));
        echo -e "$FILENAME not used";
      fi
    done < fileList.txt;

    if [ "$COUNTER" -eq "0" ]; then
      echo -e "##### All files are being used, good job!";
    fi
    rm fileList.txt;
  fi