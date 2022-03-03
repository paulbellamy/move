#!/bin/bash -e

move sandbox publish -v
move sandbox run sources/mint.move -v -d --signers 0xb
