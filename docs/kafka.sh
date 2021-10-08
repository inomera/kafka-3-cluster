#sh_aliases and add following 2 lines:
#
# alias kafka="$KAFKA_SCRIPTS/kafka.sh kafka"
#
# Then use with the following commands:
#
# kafka start|stop|log

KAFKA_DIR="/app/kafka3"
LOG_DIR="${KAFKA_DIR}/logs"

KAFKA_LOG="${LOG_DIR}/kafka.out"

PROGRAM="$1"
COMMAND="$2"

kafkaStart() {
    echo "Starting kafka..."
    rm "${KAFKA_LOG}"
    nohup bash "$KAFKA_DIR/bin/kafka-server-start.sh" "$KAFKA_DIR/config/kraft/server1.properties" >"${KAFKA_LOG}" 2>&1 &
    sleep 2
    echo "Probably it is started..."
        kafkaLog
}

kafkaLog() {
        less +F "${KAFKA_LOG}"
}

kafkaStop() {
        echo "Stopping kafka..."
        PIDS=$(ps -ef | grep "$KAFKA_DIR/config/kraft/server1.properties" | grep kafka | grep java | grep -v grep | awk {'print $2'})
        echo "Kill kafka with process id ${PIDS}"
        kill -s TERM ${PIDS}
}

kafkaPid() {
        PIDS=$(ps -ef | grep "$KAFKA_DIR/config/kraft/server1.properties" | grep kafka | grep java | grep -v grep | awk {'print $2'})
        echo "Kafka PID = ${PIDS}"
}

kafkaKill() {
        echo "Killing kafka..."
        PIDS=$(ps -ef | grep "$KAFKA_DIR/config/kraft/server1.properties" | grep kafka | grep java | grep -v grep | awk {'print $2'})
        echo "Kill kafka with process id ${PIDS}"
        kill -9 ${PIDS}
}

if [ -z "$PROGRAM" ] || [ -z "$COMMAND" ] ; then
        echo "Usage kafka start|stop|log|pid|kill"
        exit 1
elif [ "$PROGRAM" != "kafka" ] ; then
        echo "Invalid program argument: ${PROGRAM}"
        exit 1
elif [ "$COMMAND" != "start" ] && [ "$COMMAND" != "log" ] && [ "$COMMAND" != "stop" ] && [ "$COMMAND" != "pid" ] && [ "$COMMAND" != "kill" ]; then
        echo "Invalid command: ${COMMAND}"
        echo "Available commands: start, log, stop, pid, kill"
        exit 1
else
        echo "Running command ${COMMAND} on program ${PROGRAM}"
fi

if [ "$PROGRAM" = "kafka" ]; then
        if [ "$COMMAND" = "start" ]; then
                kafkaStart
        elif [ "$COMMAND" = "stop" ]; then
                kafkaStop
        elif [ "$COMMAND" = "log" ]; then
                kafkaLog
        elif [ "$COMMAND" = "pid" ]; then
                kafkaPid
        elif [ "$COMMAND" = "kill" ]; then
                kafkaKill
        fi
fi
