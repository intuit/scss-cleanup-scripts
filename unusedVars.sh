  #!/bin/bash

  read -p "##### What folder do you want to scan for unused scss variables and mixins? (default: src/sass) " SCSS_FOLDER
  SCSS_FOLDER=${SCSS_FOLDER:-src/sass}

  if [ ! -d "$SCSS_FOLDER" ]; then
    echo "##### The folder $SCSS_FOLDER does not exist."
  else
    touch varList.txt;
    touch mixinList.txt;
    touch includesList.txt;

    echo "##### Indexing SCSS files...";
    SCSS_FILES=$(find "$SCSS_FOLDER" -name "*.scss")


    echo "##### Scanning files for scss variables & mixins... (this may take a while)";
    for FILE in $SCSS_FILES; do
      while read -r oneLine; do
        VAR_NAME=$(echo "$oneLine" | grep -o '\$[_a-zA-Z0-9-]*');
        if [[ ! -z $VAR_NAME ]]; then
          echo -n $VAR_NAME\ | tr " " "\n" >> varList.txt;
        fi

        MIXIN=$(echo "$oneLine" | grep -o '\@mixin [_a-zA-Z0-9-]*');
        if [[ ! -z $MIXIN ]]; then
          echo -e $MIXIN >> mixinList.txt;
        fi
        INCLUDE=$(echo "$oneLine" | grep -o '\@include [_a-zA-Z0-9-]*');
        if [[ ! -z $INCLUDE ]]; then
          INCLUDE=${INCLUDE//\@include /};
          echo -e $INCLUDE >> includesList.txt;
        fi
      done < $FILE;
    done;
    echo "##### Scanning for redundant scss variables & mixins";

    # careful, this will not work with external dependencies
    RESULTS_VARS=$(sort varList.txt | uniq -u);
    if [[ -z $RESULTS_VARS ]]; then
      echo -e "\n##### Everything looks good. No scss variables need to be deleted";
    else
      echo -e "\n##### These scss variables are not used and can be deleted:";
      echo "$RESULTS_VARS";  
    fi

    RESULTS_DUPE_MIXINS=$(sort mixinList.txt | uniq -d);
    if [[ -z $RESULTS_DUPE_MIXINS ]]; then
      echo -e "\n##### No duplicates of mixin declarations. Looking good!";
    else 
      echo -e "\n##### These mixins are declared multiple times. Try to combine them to avoid overwriting of properties:";
      echo "@mixin $RESULTS_DUPE_MIXINS"; 
    fi 

    RESULTS_SINGLE_INCLUDES=$(sort includesList.txt | uniq -u);
    if [[ -z $RESULTS_SINGLE_INCLUDES ]]; then
      echo -e "\n##### No unnecessary mixin declarations. Looking good!"; 
    else
      echo -e "\n##### These mixins are only used once. Consider replacing them with their original value:";
      echo "$RESULTS_SINGLE_INCLUDES"; 
    fi  

    #  lists all mixins that don't have any includes
    sort -u mixinList.txt > sortedMixinList.txt
    COUNTER=0;
    echo -e "\n#### These mixins are not used and can be deleted:";
    while read -r MIXIN; do
      MIXIN_NAME=${MIXIN//\@mixin /};
      MIXIN_EXISTS=$(grep $MIXIN_NAME includesList.txt);
      if [[ -z $MIXIN_EXISTS ]]; then
        COUNTER=$((COUNTER+1));
        echo "@mixin $MIXIN_NAME";
      fi
    done < sortedMixinList.txt;
    if [ "$COUNTER" = "0" ]; then
      echo -e "\n#### None!"
    fi

    rm varList.txt;
    rm mixinList.txt;
    rm includesList.txt;
    rm sortedMixinList.txt;
  fi