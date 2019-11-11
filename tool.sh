#Παναγιώτης Γαρδίκης ΑΜ:6013

#!bin/bash


function printFile {
        grep -v "^#" $1
}

function printFirstNames {
        grep -v "^#" $1 | awk -F "|" '{ print $3 }' | sort -u
}

function printLastNames {
        grep -v "^#" $1 | awk -F "|" '{ print $2 }' | sort -u
}

function printBrowsers {
        grep -v "^#" $1 | awk -F "|" '{ print $8 }' | sort | uniq -c  | awk '{ print $2,$3,$1 }' | sed -e 's/  */ /g'
}

function printID {
        grep "^$2|" $1 | awk -F "|" '{ print $3, $2, $5 }'
}

function printDateBetween {
	if [ -z ${2} ]; then
		echo "Since date not provided"
		exit 1
	fi
	if [ -z ${3} ]; then
		echo "Until date not provided"
		exit 1
	fi
	grep -v "^#" $1 | awk -F "|" -v STD="$2" -v ED="$3" '{ if ($5 >= STD && $5 <= ED) print }'
}

function printDateSince {
	if [ -z ${2} ]; then
		echo "Since date not provided"
		exit 1
	fi
	grep -v "^#" $1 | awk -F "|" -v STD="$2" '{ if ($5 >= STD) print }'
}

function printDateUntil {
	if [ -z ${2} ]; then
		echo "Until date not provided"
		exit 1
	fi
	grep -v "^#" $1 | awk -F "|" -v ED="$2" '{ if ($5 <= ED) print }'
}

  
if [ $# == 0 ]
then echo 6013
exit 0
fi

while [ $# -gt 0 ]
do
key=${1}

case ${key} in
    -f)
    	FILENAME="$2"
    	shift # proceed to next argument
    	;;
    -id)
    	PRINT_ID=1
	ID="$2"
    	shift # proceed to next argument
    	;;
    --firstnames)
	FIRSTNAMES=1
	;;
    --lastnames)
	LASTNAMES=1
	;;
    --browsers)
	BROWSERS=1
	;;
     --born-since)
	BORN_SINCE=1
	BORN_SINCE_DATE="$2"
    	shift # proceed to next argument
	;;
     --born-until)
	BORN_UNTIL=1
	BORN_UNTIL_DATE="$2"
    	shift # proceed to next argument
	;;
    *)
	echo "Uknown option '$key'"
	exit 1
    	;;
esac
shift # past argument or value
done

if [ ! -z ${FIRSTNAMES} ]; then
       if [ ! -z ${PRINT_ID} ] || [ ! -z ${LASTNAMES} ]  || [ ! -z ${BROWSERS} ] || [ ! -z ${BORN_SINCE} ] || [ ! -z ${BORN_UNTIL} ]; then
		echo "Only one of -id --firstnames --lastnames --browsers --born-since and --born-until can be specified"
		exit 1
       fi
       printFirstNames ${FILENAME}
       exit 0
fi

if [ ! -z ${LASTNAMES} ]; then
       if [ ! -z ${PRINT_ID} ] || [ ! -z ${FIRSTNAMES} ]  || [ ! -z ${BROWSERS} ] || [ ! -z ${BORN_SINCE} ] || [ ! -z ${BORN_UNTIL} ]; then
		echo "Only one of -id --firstnames --lastnames --browsers --born-since and --born-until can be specified"
		exit 1
       fi
       printLastNames ${FILENAME}
       exit 0
fi

if [ ! -z ${BROWSERS} ]; then
       if [ ! -z ${PRINT_ID} ] || [ ! -z ${LASTNAMES} ]  || [ ! -z ${FIRSTNAMES} ] || [ ! -z ${BORN_SINCE} ] || [ ! -z ${BORN_UNTIL} ]; then
		echo "Only one of -id --firstnames --lastnames --browsers --born-since and --born-until can be specified"
		exit 1
       fi
       printBrowsers ${FILENAME}
       exit 0
fi

if [ ! -z ${PRINT_ID} ]; then
       if [ ! -z ${FIRSTNAMES} ] || [ ! -z ${LASTNAMES} ]  || [ ! -z ${BROWSERS} ] || [ ! -z ${BORN_SINCE} ] || [ ! -z ${BORN_UNTIL} ]; then
		echo "Only one of -id --firstnames --lastnames --browsers --born-since and --born-until can be specified"
		exit 1
       fi
       printID ${FILENAME} ${ID}
       exit 0
fi

if [ ! -z ${BORN_SINCE} ] || [ ! -z ${BORN_UNTIL} ]; then 
	if [ ! -z ${BROWSERS} ] || [ ! -z ${FIRSTNAMES} ]  || [ ! -z ${LASTNAMES} ] || [ ! -z ${PRINT_ID} ]; then
		echo "Only one of -id --firstnames --lastnames --browsers --born-since and --born-until can be specified"
		exit 1
	fi
	if [ ! -z ${BORN_SINCE} ] && [ ! -z ${BORN_UNTIL} ]; then
		printDateBetween ${FILENAME} ${BORN_SINCE_DATE} ${BORN_UNTIL_DATE}
	elif [ ! -z ${BORN_SINCE} ]; then
		printDateSince ${FILENAME} ${BORN_SINCE_DATE}
	else
		printDateUntil ${FILENAME} ${BORN_UNTIL_DATE}
	fi
	exit 0
fi

# Print the file without comments
printFile ${FILENAME}
