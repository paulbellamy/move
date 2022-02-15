#!/bin/bash -e

move sandbox publish -v
move sandbox run sources/post.move -v -d --signers 0xb

