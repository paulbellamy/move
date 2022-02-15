#!/bin/bash

move sandbox publish -v && move sandbox run sources/script.move -v -d --signers 0xa
