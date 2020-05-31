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

APP_VERSION = "1.0"

APP_EXECUTABLE_NAME = {
    "//conditions:default": "BazelSamples-Beta",
    "//examples/ios/App/Configuration:Debug": "BazelSamples-Beta",
    "//examples/ios/App/Configuration:Release": "BazelSamples",
}

APP_IDENTIFIER = {
    "//conditions:default": "com.linecorp.BazelSamples.beta",
    "//examples/ios/App/Configuration:Debug": "com.linecorp.BazelSamples.beta",
    "//examples/ios/App/Configuration:Release": "com.linecorp.BazelSamples",
}

DEFAULT_MINIMUM_OS_VERSION = "11.0"

DEFAULT_MINIMUM_WATCHOS_VERSION = "6.0"

INFO_PLIST_DICT = {
    "APP_IDENTIFIER": APP_IDENTIFIER,
    "PRODUCT_BUNDLE_PACKAGE_TYPE": "AAPL",
}
