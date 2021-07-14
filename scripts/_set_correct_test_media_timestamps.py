import json
import os
import pathlib
import sys

media_folder = pathlib.Path(sys.argv[1])
with open(media_folder / 'index.json', 'r') as f:
    index = json.load(f)

for path_id in index['paths'].keys():
    path_map = index['paths'][path_id]
    newest = 0
    for asset_id in path_map['assets'].keys():
        asset_map = path_map['assets'][asset_id]
        m = asset_map['lastModified']
        if m > newest:
            newest = m
        os.utime(media_folder / path_map['path'] / asset_map['filename'], (m, m))
    os.utime(media_folder / path_map['path'], (newest, newest))
