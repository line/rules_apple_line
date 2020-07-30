// Copyright 2020 LINE Corporation
//
// LINE Corporation licenses this file to you under the Apache License,
// version 2.0 (the "License"); you may not use this file except in compliance
// with the License. You may obtain a copy of the License at:
//
//    https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
// WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
// License for the specific language governing permissions and limitations
// under the License.

#import "MXDObjcGreeter.h"
#import <MixedWithPrivateSubmodule/MixedWithPrivateSubmodule-Swift.h>

@implementation MXDObjcGreeter

+ (void)sayHi:(NSString *)name {
    printf("Hi %s from ObjC\n", [name UTF8String]);
}

+ (void)callSwift:(NSString *)name {
    [SwiftGreeter sayHiWithName:name];
}

@end
