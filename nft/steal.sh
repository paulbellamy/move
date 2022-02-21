#!/bin/bash

move sandbox publish -v && move sandbox run sources/steal.move -v -d --signers 0xc
