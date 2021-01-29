  #/bin/bash
  COUNTER=0;

  read -p "##### What folder do you want to scan for images? (default: src/) " IMG_FOLDER
  IMG_FOLDER=${IMG_FOLDER:-src/}

  if [ ! -d "$IMG_FOLDER" ]; then
    echo "##### The folder $IMG_FOLDER does not exist."
  else
    echo "##### Scanning image folder $IMG_FOLDER..."

    #Adjust the filetypes to your need in the next line
    find "$IMG_FOLDER" -type f | grep -iE "\.svg$|\.png$|\.jpg$|\.jpeg$|\.gif$" >> imageList.txt;
    touch unusedImgList.txt

    while read -r IMAGENAME; do
  
      FILENAME=`basename $IMAGENAME`
      NUMFILES=0;
      IS_USED=$(grep -R "$FILENAME" "$IMG_FOLDER");
      if [[ ! -z $IS_USED ]]; then
        NUMFILES=$((NUMFILES+1));
        COUNTER=$((COUNTER+1));
      fi
      
      if [ "$NUMFILES" -eq "0" ]; then
        echo "Unused image, safe to delete: $IMAGENAME";
        FILESINFOLDER=$((FILESINFOLDER+1));
        echo "$IMAGENAME" >> unusedImgList.txt;
      fi

    done < imageList.txt;
        
    if [ "$COUNTER" -eq "0" ]; then
      echo "All images are used, nothing to delete";
      FILESINFOLDER=$((FILESINFOLDER+1));
    fi
  
    read -p "##### do you want to delete the unused files? (y/n) " ANSWER
    if [[ "$ANSWER" = "y" ]] || [[ "$ANSWER" = "Y" ]]; then
      while read -r UNUSED_IMG_NAME; do
        rm $UNUSED_IMG_NAME;
        echo "$UNUSED_IMG_NAME deleted";
      done < unusedImgList.txt;
    fi

    rm imageList.txt;
    rm unusedImgList.txt;
    echo "##### done"
  fi
  fi