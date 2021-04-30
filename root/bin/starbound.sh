#!/usr/bin/env bash

# Define the exit handler
exit_handler()
{
	printf "\nWaiting for server to shutdown..\n"
	kill -SIGINT "$child"
	sleep 1

	printf "\nTerminating..\n"
	exit
}


# Trap specific signals and forward to the exit handler
trap "exit_handler" SIGHUP SIGINT SIGQUIT SIGTERM

# Set the working directory
cd "$STARBOUND_PATH/linux" || exit

./starbound_server 2>&1 &
child=$!
wait "$child"
