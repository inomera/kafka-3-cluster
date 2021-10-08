KAFKA_DIR="/app/kafka3/"

KAFKA_LOG="${KAFKA_DIR}/logs/kafka.out"

PID=$(ps -ef | grep "$KAFKA_DIR/config/server.properties" | grep kafka | grep java | grep -v grep | awk {'print $2'})

if [ -z "$PID" ]
then
     echo "Starting kafka..."
     nohup bash "$KAFKA_DIR/bin/kafka-server-start.sh" "$KAFKA_DIR/config/kraft/server1.properties" >"${KAFKA_LOG}" 2>&1 &
     echo "kafka is started"
else
     echo "kafka is up and run PID : $PID"
fi
