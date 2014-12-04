#!/bin/sh

# Copyright (C) 2014 The OmniROM Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# This works, but there has to be a better way of reliably getting the root build directory...
    TOP=$1
    DEVICE=falcon


TARGET_DIR=/home/klozz/android/XPerience-AOSP-Lollipop/out/target/product/falcon/
PREBUILT_DIR=$TOP/prebuilts/chromium/$DEVICE

if [ -d $PREBUILT_DIR ]; then
    rm -rf $PREBUILT_DIR
fi

mkdir -p $PREBUILT_DIR
mkdir -p $PREBUILT_DIR/app/webview
mkdir -p $PREBUILT_DIR/app/webview/lib/arm

if [ -d $TARGET_DIR ]; then
    echo "Copying files..."
    cp -r $TARGET_DIR/system/app/webview $PREBUILT_DIR/app/webview
    cp $TARGET_DIR/system/lib/libwebviewchromium.so $PREBUILT_DIR/lib/libwebviewchromium.so
    ls $TARGET_DIR/system/lib/libwebviewchromium.so $PREBUILT_DIR/app/webview/lib/arm/libwebviewchromium.so
#    cp $TARGET_DIR/../../common/obj/JAVA_LIBRARIES/android_webview_java_intermediates/javalib.jar $PREBUILT_DIR/android_webview_java.jar
else
    echo "Please ensure that you have ran a full build prior to running this script!"
    return 1;
fi

echo "Generating Makefiles..."

HASH=$(git --git-dir=$TOP/external/chromium/.git --work-tree=$TOP/external/chromium rev-parse --verify HEAD)
echo $HASH > $PREBUILT_DIR/hash.txt

(cat << EOF) | sed s/__DEVICE__/$DEVICE/g > $PREBUILT_DIR/chromium_prebuilt.mk
# Copyright (C) 2014 The XPerience Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

LOCAL_PATH := prebuilts/chromium/__DEVICE__/

PRODUCT_COPY_FILES += \\
    \$(LOCAL_PATH)/app/webview/webview.apk:system/app/webview/webview.apk \\
    \$(LOCAL_PATH)/app/webview/lib/arm/libwebviewchromium.so:system/app/webview/lib/arm/libwebviewchromium.so \\
    \$(LOCAL_PATH)/lib/libwebviewchromium.so:system/lib/libwebviewchromium.so

EOF

echo "Done!"
