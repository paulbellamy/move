#!/bin/bash

move sandbox publish -v && move sandbox run sources/debug_script.move -v -d --signers 0xa --args "$@"
