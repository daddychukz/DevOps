#!/bin/bash

sort log.txt|uniq -c | grep -v 127.0.0.1 | grep closeio | sort
