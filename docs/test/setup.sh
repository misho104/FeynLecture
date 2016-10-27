#!/bin/sh

TESTDIR=`git rev-parse --show-toplevel`/docs/test

cd $TESTDIR
python parse_markdown.py `paste -s md_list`
chmod 755 test.sh
