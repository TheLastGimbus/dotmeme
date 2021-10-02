#!/bin/bash

set -e

cd "$(dirname "$0")"
cd ..
mkdir -p assets/tessdata/
cd assets/tessdata/

curl -L https://github.com/tesseract-ocr/tessdata_fast/raw/main/eng.traineddata > eng.traineddata
# For unit tests
sudo apt install tesseract-ocr
