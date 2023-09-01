#!/bin/bash
ps -eo pid,user,ppid,cmd,%mem,%cpu --sort=-%cpu | head -n 15