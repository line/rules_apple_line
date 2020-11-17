# Lint as: python3
# Copyright 2020 LINE Corporation
#
# LINE Corporation licenses this file to you under the Apache License,
# version 2.0 (the "License"); you may not use this file except in compliance
# with the License. You may obtain a copy of the License at:
#
#    https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.

"""Merges multiple plist files into a single one"""

import argparse
import sys
from build_bazel_rules_apple.tools.wrapper_common import execute


def main():
    parser = argparse.ArgumentParser(
        prog="Merges multiple plist files into a single one",
        description="""This script takes multiple `--input` arguments that
                       point to each input plist file. When key duplication
                       occurs, the value from the first input file wins.""")
    parser.add_argument(
        "--input",
        required=True,
        action="append",
        help="Path to an input plist, may be used multiple times."
    )
    parser.add_argument(
        "--output",
        required=True,
        help="Path to the output plist."
    )
    parser.add_argument(
        "--output_format",
        required=False,
        default="xml1",
        help="The output plist format, can be one of 'xml1', 'binary1', "
        "'json', 'swift', and 'objc'."
    )

    args = parser.parse_args()

    # Merge each plist to the output file
    for input in args.input:
        cmd = [
            "/usr/libexec/PlistBuddy",
            "-c",
            "Merge {}".format(input),
            args.output]

        _, _, stderr = execute.execute_and_filter_output(
            cmd, raise_on_failure=True)

        if stderr:
            print(stderr)

    # Convert to a non-XML format if requested
    if args.output_format != "xml1":
        cmd = [
            "/usr/bin/plutil",
            "-convert",
            args.output_format,
            args.output]

        _, stdout, stderr = execute.execute_and_filter_output(
            cmd, raise_on_failure=True)

        if stdout:
            print(stdout)
        if stderr:
            print(stderr)


if __name__ == "__main__":
    sys.exit(main())
