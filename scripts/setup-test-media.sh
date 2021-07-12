#!/bin/bash

set -e

cd "$(dirname "$0")"
cd ..

git clone --depth 1 --branch v0.0.1 https://github.com/TheLastGimbus/__takeout_helper_test_data__.git test/_test_media
python3 scripts/_set_correct_test_media_timestamps.py test/_test_media

echo "Done! You should now be able to run 'flutter test' without a problem ;)"
