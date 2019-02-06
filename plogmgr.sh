#!/bin/bash

cd /home/shareindia/Algowire/Tachyon/Live
day=$(date | cut -d ' ' -f1)
cat puttyday.log > putty_$day.log
cat putty.log >> putty_$day.log

