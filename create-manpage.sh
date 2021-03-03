#!/bin/sh

# Global variables
export MANPAGE_FILENAME=""
export TMP_APPLICATION_NAME=""
export TMP_APPLICATION_DESCRIPTION_SIMPLE=""
export TMP_APPLICATION_DESCRIPTION_LONG=""
export TMP_PRIMARY_AUTHOR=""
export TMP_BUGNOTICE=""
export TMP_COPYRIGHT_NOTICE=""
export TMP_SEEALSO=""

export TMP_SHORT_PARAMETER_LIST=""
export TMP_LONG_PARAMETER_DESCRIPTIONS=""
export TMP_EXAMPLE_TEXT=""

add_return()
{
	echo $1
}

print_in_function()
{
	echo $1 >&2
}

question_yesno()
{
	TMP_LOOP="true"
	while [ "$TMP_LOOP" = "true" ]
	do
		if [ "$2" = "y" ]
		then
			print_in_function "$1 (Y/n): "
		elif [ "$2" = "n" ]
		then
			print_in_function "$1 (y/N): "
		else
			print_in_function "Error! Second parameter of function \"question_yesno()\" must be either \"y\" or \"n\".";
			exit 1;
		fi
		read tmp_answer
		if [ "$tmp_answer" = "" ]
		then
			add_return $2
			return
		elif [ "$tmp_answer" = "y" ] || [ "$tmp_answer" = "yes" ]
		then
			add_return "y"
			return
		elif [ "$tmp_answer" = "n" ] || [ "$tmp_answer" = "no" ]
		then
			add_return "n"
			return
		else
			print_in_function "Error! Invalid input!"
		fi
	done
}

get_general_data()
{
	echo ""
	echo "Name of the application: "
	read TMP_APPLICATION_NAME
	echo ""
	echo "Simple description of the application: "
	read TMP_APPLICATION_DESCRIPTION_SIMPLE
	echo ""
	echo "Longer description of the application: "
	read TMP_APPLICATION_DESCRIPTION_LONG
	echo ""
	echo "Primary author and author email for the application (i.e. \"The Author <the-author@my-example.com>: "
	read TMP_PRIMARY_AUTHOR
	echo ""
	echo "Bug notice (i.e. a simple sentence describing what to do when you encounter bugs): "
	read TMP_BUGNOTICE
	echo ""
	echo "Copyright notice (i.e. a simple mentioning of the name of the applications license): "
	read TMP_COPYRIGHT_NOTICE
	echo ""
	echo "Other manpages to look into (i.e. \"abc(8)\", leave empty for nothing): "
	read TMP_SEEALSO
	echo ""
}

get_parameters()
{
	export TMP_SHORT_PARAMETER_LIST=""
	export TMP_LONG_PARAMETER_DESCRIPTIONS=""
	TMP_LOOP="true"
	while [ "$TMP_LOOP" = "true" ]
	do
		echo "Current parameter (example: \"-v abc\" or just \"-a\"): "
		read TMP_CURRENT_PARAMETER
		echo ""
		echo "Description of current parameter: "
		read TMP_CURRENT_DESCRIPTION
		echo ""
		
		# Add parameter to lists
		export TMP_SHORT_PARAMETER_LIST="${TMP_SHORT_PARAMETER_LIST} [${TMP_CURRENT_PARAMETER}]"
		export TMP_LONG_PARAMETER_DESCRIPTIONS="${TMP_LONG_PARAMETER_DESCRIPTIONS}.IP \"${TMP_CURRENT_PARAMETER}\"\n${TMP_CURRENT_DESCRIPTION}\n"
		
		TMP_RETURN=$(question_yesno "Do you want to add another parameter?" "n")
		#TMP_RETURN=$?
		if [ "$TMP_RETURN" = "n" ]
		then
			return
		else
			echo ""
		fi
	done
}

get_examples()
{
	export TMP_EXAMPLE_TEXT=""
	TMP_LOOP="true"
	while [ "$TMP_LOOP" = "true" ]
	do
		echo "Current example code (example: \"command -v abc\" or \"command -a -b -v\"): "
		read TMP_CURRENT_EXAMPLE
		echo ""
		echo "Description of the current example: "
		read TMP_CURRENT_DESCRIPTION
		echo ""
		
		# Add parameter to lists
		#export TMP_SHORT_PARAMETER_LIST="${TMP_SHORT_PARAMETER_LIST} [${TMP_CURRENT_PARAMETER}]"
		export TMP_EXAMPLE_TEXT="${TMP_EXAMPLE_TEXT}.IP \"${TMP_CURRENT_EXAMPLE}\"\n${TMP_CURRENT_DESCRIPTION}\n"
		
		TMP_RETURN=$(question_yesno "Do you want to add another example?" "n")
		#TMP_RETURN=$?
		if [ "$TMP_RETURN" = "n" ]
		then
			return
		else
			echo ""
		fi
	done
	#TMP_EXAMPLE_TEXT=""
	#echo "Getting examples..."
}

create_manpage_file()
{
	#TMP_APPLICATION_NAME="$1"
	#TMP_APPLICATION_DESCRIPTION_SIMPLE="$2"
	#TMP_APPLICATION_DESCRIPTION_LONG="$3"
	#TMP_PRIMARY_AUTHOR="$4"
	#TMP_BUGNOTICE="$5"
	#TMP_COPYRIGHT_NOTICE="$6"
	#TMP_SEEALSO="$7"
	
	#echo "Creating manpage file..."
	#echo ""
	#echo "===== MANPAGE FILE ====="
	echo ".TH ${TMP_APPLICATION_NAME} 1" > $MANPAGE_FILENAME
	echo ".SH NAME" >> $MANPAGE_FILENAME
	echo "${TMP_APPLICATION_NAME} - ${TMP_APPLICATION_DESCRIPTION_SIMPLE}" >> $MANPAGE_FILENAME
	echo ".SH SYPNOSIS" >> $MANPAGE_FILENAME
	echo ".B ${TMP_APPLICATION_NAME} ${TMP_SHORT_PARAMETER_LIST}" >> $MANPAGE_FILENAME
	echo ".SH DESCRIPTION" >> $MANPAGE_FILENAME
	echo "" >> $MANPAGE_FILENAME
	echo "${TMP_APPLICATION_DESCRIPTION_LONG}" >> $MANPAGE_FILENAME
	echo "" >> $MANPAGE_FILENAME
	echo ".SH OPTIONS" >> $MANPAGE_FILENAME
	echo "${TMP_LONG_PARAMETER_DESCRIPTIONS}" >> $MANPAGE_FILENAME
	echo ".SH \"EXAMPLES\"" >> $MANPAGE_FILENAME
	echo "${TMP_EXAMPLE_TEXT}" >> $MANPAGE_FILENAME
	echo ".SH BUGS" >> $MANPAGE_FILENAME
	echo "${TMP_BUGNOTICE}" >> $MANPAGE_FILENAME
	echo ".SH AUTHOR" >> $MANPAGE_FILENAME
	echo "${TMP_PRIMARY_AUTHOR}" >> $MANPAGE_FILENAME
	echo ".SH COPYRIGHT" >> $MANPAGE_FILENAME
	echo "${TMP_COPYRIGHT_NOTICE}" >> $MANPAGE_FILENAME
	echo ".SH \"SEE ALSO\"" >> $MANPAGE_FILENAME
	echo ".BR ${TMP_SEEALSO}" >> $MANPAGE_FILENAME
	
	echo ""
	echo "Manpage file ${MANPAGE_FILENAME} successfully created."
	echo ""
	
	
	#echo ""
	#echo $TMP_SHORT_PARAMETER_LIST
	#echo ""
	#echo $TMP_LONG_PARAMETER_DESCRIPTIONS
}

create_manpage()
{
	get_general_data
	
	get_parameters
	echo ""
	get_examples
	echo ""
	
	create_manpage_file
} 

# 1. Get manpage filename
echo "Name of manpage to create: "
read MANPAGE_NAME
export MANPAGE_FILENAME="${MANPAGE_NAME}.1"
echo "Filename will be: ${MANPAGE_FILENAME}"
if [ -f "$MANPAGE_FILENAME" ]
then
	TMP_RETURN=$(question_yesno "File ${MANPAGE_FILENAME} already exists. Do you want to override it?" "n")
	#TMP_RETURN=$?
	if [ "$TMP_RETURN" = "y" ]
	then
		create_manpage
	else
		echo "Not overwriting file. Aborting."
		exit 1
	fi
else
	create_manpage
fi
