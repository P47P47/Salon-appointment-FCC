#!/bin/bash
PSQL="psql -X --username=freecodecamp dbname=salon -t -c"

echo -e "\n~~~~~~ SALON HAI ~~~~~~\n"
echo -e "What's up! what do you want my friend?"
SERVICES=$($PSQL "SELECT * FROM services")

DISPLAY_INFO(){
  echo "$SERVICES" | while read SERVICE_ID BAR SERVICE_NAME
  do
    echo "$SERVICE_ID) $SERVICE_NAME"
  done

  MAIN_MENU  
}

MAIN_MENU(){
read SERVICE_ID_SELECTED

if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]]
then
echo -e "\nNah what? Choose the number!\n"
  DISPLAY_INFO
else

SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")



if [[ -z $SERVICE_NAME ]]
  then
  echo -e "\nYou're alrieght? this doesn't existe. choose another one.\n"
  DISPLAY_INFO 
fi
echo -e "\nwhat's your phone number?"
read CUSTOMER_PHONE
CUSTOMER_NAME=$($PSQL"SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
if [[ -z $CUSTOMER_NAME ]]
  then 
   echo -e "\nSHEEE! you're new here! So, what's your name?"
   read CUSTOMER_NAME
   INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
fi
CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE name='$CUSTOMER_NAME'")

echo -e "\nOkay $CUSTOMER_NAME, what time will you come?(in hh:mm format)"
read SERVICE_TIME
CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")

INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments( customer_id, service_id, time) VALUES( $CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
echo -e "\nI have put you down for a $(echo $SERVICE_NAME | sed -r 's/^ *| *$//g') at $(echo $SERVICE_TIME | sed -r 's/^ *| *$//g'), $(echo $CUSTOMER_NAME | sed -r 's/^ *| *$//g').\n"

fi
}

DISPLAY_INFO


