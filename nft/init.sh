#!/bin/bash

move sandbox publish -v && move sandbox run sources/init.move -v -d --signers 0xa
