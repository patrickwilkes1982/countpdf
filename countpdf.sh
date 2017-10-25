#!/bin/bash
 
saveIFS=$IFS
IFS=$(echo -en "\n\b")
 
baseDir=`pwd`
myDirs=($(find . -mindepth 0 -maxdepth 999 -type d))
myDirCount=${#myDirs[*]}
 
grandtotalPages=0
 
i=0
while [ $i -lt $myDirCount ]; do
  cd ${myDirs[$i]}
  
  myFiles=($(find . -maxdepth 1 -name "*.pdf"))
  myFileCount=${#myFiles[*]}
  subtotalPages=0
  
  # We have PDFs in this dir, so loop through and count pages
  if [ $myFileCount -ne 0 ]; then
    j=0
    while [ $j -lt $myFileCount ]; do
      pageCount=$(mdls ${myFiles[j]} | grep kMDItemNumberOfPages | awk -F'= ' '{print $2}')
      size=${#pageCount}
        if [ $size -eq 0 ]
        then
          # This PDF is missing a page count, so we skip it
          # echo ${myFiles[j]} : \*\* Skipped - no page count \*\*
          echo ""
      else
        # Increment a subtotal by directory and a running grand total
          subtotalPages=$(($subtotalPages + $pageCount)) 
          grandtotalPages=$((grandtotalPages + $pageCount))
        fi
        j=$(( $j + 1 ))
      done
 
      # Pad the results for nice alignment of page counts
      digitCount=${#subtotalPages}
    case $digitCount in
        1)
          padding="    ";;
        2)
          padding="   ";;
        3)
          padding="  ";;
        4)
          padding=" ";;
        *) ;;
    esac
      
      echo "$padding$subtotalPages: ${myDirs[i]}"
    fi
    
  i=$(( $i + 1 ))
  cd $baseDir
done
 
    # Pad the results for nice alignment of grand total
      digitCount=${#grandtotalPages}
    case $digitCount in
      1)
        padding="    ";;
      2)
        padding="   ";;
      3)
        padding="  ";;
        4)
          padding=" ";;
        *) ;;
    esac
 
echo "-------------------------------------------------------------------"
echo "$padding$grandtotalPages: Total PDF Pages"
      
IFS=$saveIFS