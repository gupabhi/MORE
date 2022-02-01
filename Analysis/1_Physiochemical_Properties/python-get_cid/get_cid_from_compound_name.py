# PubChem to get compound cid
# Documentation link https://pubchemdocs.ncbi.nlm.nih.gov/pug-rest
# https://pubchempy.readthedocs.io/en/latest/guide/properties.html

import pubchempy as pcp
from selenium import webdriver 
import pandas as pd

## Initialize variables
input = "C:/Users/abhis/Documents/Work/Work_1_Olfaction/Project_1_Structured_dataset/paper-work/structured_dataset/1_Physiochemical_Properties/input/"
odors = pd.read_excel(input + '2019_10_28_Structured datasets.xlsx', sheetname='Odors') # read data
output = pd.DataFrame(columns=['odor', 'cid'])   # output dataframe

## Get cid
for i in range(0, len(odors)):  # number of odors

    try:
        odor = odors.Odor[i]
        compound = pcp.get_compounds(odor, 'name')

        output.loc[i, "odor"] = odor
        if len(compound) == 1:
            output.loc[i, "cid"] = compound[0].cid  # get int from cid string
        else:
            output.loc[i, "cid"] = float('NaN')

        output.to_csv(input + 'odor_cid.csv', sep=',', index=False)     # save ouput
        print([odor, i, output.loc[i, "cid"]])
    
    except UnicodeEncodeError:
        pass

