#!/bin/bash -e

move sandbox publish -v
move sandbox run sources/init.move -v -d --signers 0x1
