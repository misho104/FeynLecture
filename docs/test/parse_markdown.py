#!env python2
# -*- coding: utf-8 -*-
# Time-Stamp: <2016-10-29 02:45:07>

"""parse_markdown.py: an utility to find codeblocks with code_test option preceding"""

from __future__ import absolute_import
from __future__ import division
from __future__ import print_function
from __future__ import unicode_literals

__version__ = "0.0.1"
__date__    = ""
__author__  = "Sho Iwamoto"
__license__ = "MIT"
__status__  = "Development"

import os
import sys
import shutil
import re
#import time
#import textwrap
#import select
#import tempfile
#import subprocess

CODE_DIR = os.path.join(os.path.abspath(os.path.dirname(__file__)), "codes")
TEST_SH = os.path.abspath(os.path.join(os.path.dirname(__file__), "test.sh"))


# Python 2 <-> 3 #####################################################
try:
    FileNotFoundError
except NameError:
    FileNotFoundError = IOError
if sys.version_info[0] == 3:
    def is_str(obj):
        return isinstance(obj, str)
else:
    def is_str(obj):
        return isinstance(obj, basestring)
######################################################################


class Color:
    r = '\033[91m'
    g = '\033[92m'
    end = '\033[0m'
    @classmethod
    def green(self, str):
        return self.g + str + self.end
    @classmethod
    def red(self, str):
        return self.r + str + self.end


def error(msg):
    print(Color.red(msg))
    sys.exit(1)


def info(msg):
    print(Color.green(msg))


def parse_markdown(source, output_dir):
    TEXT = 1
    DECLARED = 2
    CODE = 3

    re_code_declare = r"!\[:code_test]\(([^\s]+) ([^\s]+)\)"
    re_code_separator = r"^\s*```"

    status = TEXT

    with open(source) as f:
        for line in f:
            code_declare = re.search(re_code_declare, line)

            if code_declare or status != TEXT:
                print(line, end="")

            if code_declare:
                if status != TEXT:
                    print("Parse error: " + line)
                    sys.exit(1)

                status = DECLARED
                interpreter = code_declare.group(1)
                filename = code_declare.group(2)
                code = ""
            elif re.search(re_code_separator, line):
                if status == DECLARED:
                    status = CODE
                elif status == CODE:
                    status = TEXT
                    output_file = os.path.join(output_dir, filename)
                    save_code(code, output_file, interpreter)
                    print(Color.green("Saved as " + output_file + " to run by " + interpreter))
            elif status == CODE:
                code += line


def save_code(code, output_file, interpreter):
    with open(output_file, 'w') as f:
        f.write(code)
    if interpreter == 'python2':
        action = 'if [[ $TRAVIS_PYTHON_VERSION == 2* ]]; then test_python {}; fi'
    elif interpreter == 'python3':
        action = 'if [[ $TRAVIS_PYTHON_VERSION == 3* ]]; then test_python {}; fi'
    with open(TEST_SH, 'a') as f:
        f.write(action.format(output_file) + '\n')


if __name__ == '__main__':
    if len(sys.argv) < 2:
        print("usage: " + sys.argv[0] + " target [...]")
        sys.exit(1)

    if not(os.path.exists(CODE_DIR)):
        os.mkdir(CODE_DIR)
    if not(os.path.isdir(CODE_DIR)):
        error("failed to create output directory " + CODE_DIR)

    with open(TEST_SH, "w") as f:
        f.write("""\
#!/bin/bash

TESTDIR=`git rev-parse --show-toplevel`/docs/test

function test_python(){
  echo "Testing $1"
  python -m py_compile $1
}

cd $TESTDIR
""")

    for source in sys.argv[1:]:
        output_dir = os.path.join(CODE_DIR, os.path.basename(source).replace('.', '_'))
        if not(os.path.exists(source)):
            error("target file {} not found.".format(source))

        if os.path.exists(output_dir):
            shutil.rmtree(output_dir)
        os.mkdir(output_dir)

        parse_markdown(source, output_dir)
