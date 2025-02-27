#!/bin/sh
### BEGIN INIT INFO
# Provides:          ipfs
# Required-Start:    $local_fs $remote_fs $network $syslog $named
# Required-Stop:     $local_fs $remote_fs $network $syslog $named
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Should-Start:      ipfs daemon
# Should-Stop:       ipfs daemon
# Short-Description: Starts the ipfs daemon
# Description:       ipfs daemon is managing swarm filesystem
### END INIT INFO

# Author: Dylan Powers <dylan.kyle.powers@gmail.com

PATH=/sbin:/usr/sbin:/bin:/usr/bin:/usr/local/bin
DESC="ipfs daemon"
NAME=ipfs
DAEMON=/usr/local/bin/ipfs
DAEMON_ARGS="daemon --enable-pubsub-experiment --enable-namesys-pubsub --enable-gc"
PIDFILE=/var/run/$NAME.pid
SCRIPTNAME=/etc/init.d/$NAME

IPFS_PATH=/home/xbian/.ipfs
IPFS_USER=xbian
# Exit if the package is not installed
[ -x "$DAEMON" ] || exit 0

# Read configuration variable file if it is present
[ -r /etc/default/$NAME ] && . /etc/default/$NAME

# Load the VERBOSE setting and other rcS variables
. /lib/init/vars.sh

# Define LSB log_* functions.
# Depend on lsb-base (>= 3.2-14) to ensure that this file is present
# and status_of_proc is working.
. /lib/lsb/init-functions

#
# Function that starts the daemon/service
#
do_start() {
    # Return
    #   0 if daemon has been started
    #   1 if daemon was already running
    #   2 if daemon could not be started
    start-stop-daemon --start --quiet --pidfile $PIDFILE --exec $DAEMON --test >/dev/null \
        || return 1
    start-stop-daemon --start --quiet --pidfile $PIDFILE --make-pidfile \
                      --background --chuid $IPFS_USER --no-close \
                      --exec /usr/bin/env IPFS_PATH="$IPFS_PATH" $DAEMON 2>>/var/log/ipfs.log 1>/dev/null \
                      -- $DAEMON_ARGS \
    || return 2
}

#
# Function that stops the daemon/service
#
do_stop() {
    # Return
    #   0 if daemon has been stopped
    #   1 if daemon was already stopped
    #   2 if daemon could not be stopped
    #   other if a failure occurred
    start-stop-daemon --stop --quiet --retry=TERM/30/KILL/5 --pidfile $PIDFILE --name $NAME
    RETVAL="$?"
    [ "$RETVAL" = 2 ] && return 2

    # Delete the pid
    rm -f $PIDFILE
    return "$RETVAL"
}

case "$1" in
  start)
        [ "$VERBOSE" != no ] && log_daemon_msg "Starting $DESC" "$NAME"
        do_start
        case "$?" in
            0|1) [ "$VERBOSE" != no ] && log_end_msg 0 ;;
            2) [ "$VERBOSE" != no ] && log_end_msg 1 ;;
        esac
        ;;
  stop)
        [ "$VERBOSE" != no ] && log_daemon_msg "Stopping $DESC" "$NAME"
        do_stop
        case "$?" in
            0|1) [ "$VERBOSE" != no ] && log_end_msg 0 ;;
            2) [ "$VERBOSE" != no ] && log_end_msg 1 ;;
        esac
        ;;
  status)
        status_of_proc "$DAEMON" "$NAME" && exit 0 || exit $?
        ;;
  restart)
        do_stop
        do_start
        ;;
  *)
    echo "Usage: $SCRIPTNAME {start|stop|status|restart}" >&2
    exit 3
    ;;
esac
