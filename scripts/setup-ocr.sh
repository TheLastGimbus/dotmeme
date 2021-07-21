#!/bin/bash

set -e

cd "$(dirname "$0")"
cd ..
mkdir -p assets/tessdata/
cd assets/tessdata/

curl https://github.com/tesseract-ocr/tessdata_fast/raw/master/eng.traineddata --output eng.traineddata
# For unit tests
sudo apt install tesseract-ocr
