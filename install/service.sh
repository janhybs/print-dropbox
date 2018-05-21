#!/bin/sh
### BEGIN INIT INFO
# Provides:          print-db
# Required-Start:    $local_fs $network $named $time $syslog
# Required-Stop:     $local_fs $network $named $time $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Description:       Printing over shared dropbox folder
### END INIT INFO

# Change the next 3 lines to suit where you install your script and what you want to call it
DAEMON=/usr/bin/print-db
DAEMON_NAME=print-db

# Add any command line options for your daemon here
DAEMON_OPTS=""

# This next line determines what user the script runs as.
# Root generally not recommended but necessary if you are using the Raspberry Pi GPIO from Python.
DAEMON_USER=root

# The process ID of the script when it runs is stored here:
PIDFILE=/var/run/$DAEMON_NAME.pid

. /lib/lsb/init-functions

do_start () {
    log_daemon_msg "Starting system $DAEMON_NAME daemon"
    start-stop-daemon --start --background --pidfile $PIDFILE --make-pidfile --user $DAEMON_USER --chuid $DAEMON_USER --startas $DAEMON -- $DAEMON_OPTS
    log_end_msg $?
}
do_stop () {
    log_daemon_msg "Stopping system $DAEMON_NAME daemon"
    start-stop-daemon --stop --pidfile $PIDFILE --retry 10
    log_end_msg $?
}

case "$1" in

    start|stop)
        do_${1}
        ;;

    restart|reload|force-reload)
        do_stop
        do_start
        ;;

    status)
        status_of_proc "$DAEMON_NAME" "$DAEMON" && exit 0 || exit $?
        ;;

    *)
        echo "Usage: /etc/init.d/$DAEMON_NAME {start|stop|restart|status}"
        exit 1
        ;;
esac
exit 0

# # Using the lsb functions to perform the operations.
# . /lib/lsb/init-functions
# # Process name ( For display )
# NAME=print-db
# # Daemon name, where is the actual executable
# DAEMON=/usr/bin/print-db
# # pid file for the daemon
# PIDFILE=/var/run/print-db.pid
# 
# # If the daemon is not there, then exit.
# test -x $DAEMON || exit 5
# 
# case $1 in
#  start)
#   # Checked the PID file exists and check the actual status of process
#   if [ -e $PIDFILE ]; then
#    status_of_proc -p $PIDFILE $DAEMON "$NAME process" && status="0" || status="$?"
#    # If the status is SUCCESS then don't need to start again.
#    if [ $status = "0" ]; then
#     exit # Exit
#    fi
#   fi
#   # Start the daemon.
#   log_daemon_msg "Starting the process" "$NAME"
#   # Start the daemon with the help of start-stop-daemon
#   # Log the message appropriately
#   if start-stop-daemon --start --quiet --oknodo --pidfile $PIDFILE --exec $DAEMON ; then
#    log_end_msg 0
#   else
#    log_end_msg 1
#   fi
#   ;;
#  stop)
#   # Stop the daemon.
#   if [ -e $PIDFILE ]; then
#    status_of_proc -p $PIDFILE $DAEMON "Stoppping the $NAME process" && status="0" || status="$?"
#    if [ "$status" = 0 ]; then
#     start-stop-daemon --stop --quiet --oknodo --pidfile $PIDFILE
#     /bin/rm -rf $PIDFILE
#    fi
#   else
#    log_daemon_msg "$NAME process is not running"
#    log_end_msg 0
#   fi
#   ;;
#  restart)
#   # Restart the daemon.
#   $0 stop && sleep 2 && $0 start
#   ;;
#  status)
#   # Check the status of the process.
#   if [ -e $PIDFILE ]; then
#    status_of_proc -p $PIDFILE $DAEMON "$NAME process" && exit 0 || exit $?
#   else
#    log_daemon_msg "$NAME Process is not running"
#    log_end_msg 0
#   fi
#   ;;
#  reload)
#   # Reload the process. Basically sending some signal to a daemon to reload
#   # it configurations.
#   if [ -e $PIDFILE ]; then
#    start-stop-daemon --stop --signal USR1 --quiet --pidfile $PIDFILE --name $NAME
#    log_success_msg "$NAME process reloaded successfully"
#   else
#    log_failure_msg "$PIDFILE does not exists"
#   fi
#   ;;
#  *)
#   # For invalid arguments, print the usage message.
#   echo "Usage: $0 {start|stop|restart|reload|status}"
#   exit 2
#   ;;
# esac

# # Using the lsb functions to perform the operations.
# . /lib/lsb/init-functions
# 
# SCRIPT=/usr/bin/print-db
# RUNAS=jan-hybs
# 
# PIDFILE=/var/run/print-db.pid
# LOGFILE=/var/log/print-db.log
# 
# start() {
#   if [ -f /var/run/$PIDNAME ] && kill -0 $(cat /var/run/$PIDNAME); then
#     echo 'Service already running' >&2
#     return 1
#   fi
#   echo 'Starting service…' >&2
#   local CMD="$SCRIPT &> \"$LOGFILE\" & echo \$!"
#   su -c "$CMD" $RUNAS > "$PIDFILE"
#   echo 'Service started' >&2
# }
# 
# stop() {
#   if [ ! -f "$PIDFILE" ] || ! kill -0 $(cat "$PIDFILE"); then
#     echo 'Service not running' >&2
#     return 1
#   fi
#   echo 'Stopping service…' >&2
#   kill -15 $(cat "$PIDFILE") && rm -f "$PIDFILE"
#   echo 'Service stopped' >&2
# }
# 
# uninstall() {
#   echo -n "Are you really sure you want to uninstall this service? That cannot be undone. [yes|No] "
#   local SURE
#   read SURE
#   if [ "$SURE" = "yes" ]; then
#     stop
#     rm -f "$PIDFILE"
#     echo "Notice: log file is not be removed: '$LOGFILE'" >&2
#     update-rc.d -f print-db remove
#     rm -fv "$0"
#   fi
# }
# 
# case "$1" in
#   start)
#     start
#     ;;
#   stop)
#     stop
#     ;;
#   uninstall)
#     uninstall
#     ;;
#   restart)
#     stop
#     start
#     ;;
#   *)
#     echo "Usage: $0 {start|stop|restart|uninstall}"
# esac
