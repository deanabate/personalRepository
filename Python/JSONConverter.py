
# JSON Converter

"""Converts JSON with nested fields into a flattened CSV file.
"""
# Importing libs
import pandas as pd
from datetime import datetime
import glob
import re

# Setting the working directory
import os
path="/Users/deanabate/Documents/Slack Download/mdw_driver_team"
os.chdir(path)
os.getcwd()

# Combining the files
read_files = glob.glob("*.json")
with open("merged_file.json", "w") as outfile:
    outfile.write('{}'.format(
        '[]'.join([open(f, "r").read() for f in read_files])))

# Reading in the json file
df = pd.read_json('MDW_drivers.json')

##### Data Cleaning #####
# Select columns
df = df[["ts", "user", "user_team", "team", "text", "type"]]

# Timestamps
df['ts'] = df['ts'].astype(float)
df.loc[:, 'ts'] = df.ts.map(lambda x: pd.datetime.fromtimestamp(x).strftime('%Y-%m-%d %H:%M:%S'))

# Text Processing
rgx_list = ["<(.*?)>"]
def remove_user(rgx_list, yup):
    new_text = yup
    for rgx_match in rgx_list:
        new_text = re.sub(rgx_match, '', new_text)
    return new_text
df['text'] = df['text'].map(lambda x: remove_user(rgx_list,x)) # Removing Username
df['text'] = df['text'].map(lambda x: x.strip()) # Removing leading/trailing whitespace

# Writing to .csv
df.to_csv("MDW_drivers.csv", index = False)