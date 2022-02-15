#!/bin/bash -e

move sandbox publish -v
move sandbox run sources/setup.move -v -d --signers 0xa
