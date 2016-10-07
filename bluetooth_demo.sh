#!/bin/bash

echo "quit or ^D to exit"
(echo "scan on" ; cat -) | bluetoothctl
