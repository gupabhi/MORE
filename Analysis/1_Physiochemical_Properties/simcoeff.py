import xlrd
import pandas as pd
from rdkit import Chem,DataStructs
from rdkit.Chem import rdMolDescriptors, AllChem
from PySpectrophore.spectrophore import spectrophoreCalculator

# from xlutils.copy import copy
# import numpy as np 
# import scipy.io

# get coefficient values between a target and reference molecule
def get_coefficients(smile_list):
    target_molecule_smile = smile_list[0]
    ref_molecule_smile = smile_list[1]
    columns = ['tanimoto', 'dice']
 
    molecule_1 = Chem.MolFromSmiles(ref_molecule_smile)
    molecule_2 = Chem.MolFromSmiles(target_molecule_smile)    
    
    # the default fingerprint is path-based:
    fp1 = Chem.RDKFingerprint(molecule_1)
    fp2 = Chem.RDKFingerprint(molecule_2)

    # the Morgan fingerprint (similar to ECFP) is also useful:
    mfp1 = rdMolDescriptors.GetMorganFingerprint(molecule_1,2)
    mfp2 = rdMolDescriptors.GetMorganFingerprint(molecule_2,2)

    tanimoto = DataStructs.TanimotoSimilarity(fp1,fp2)
    dice = DataStructs.DiceSimilarity(mfp1,mfp2)

    return [tanimoto, dice]

def spectrophore_cal(smile):

	mol = Chem.MolFromSmiles(smile)
	AllChem.EmbedMolecule(mol) 

	calculator = spectrophoreCalculator()
	spectrophore = calculator.calculate(mol)
	print(calculator.calculate(mol))

	# spect = np.column_stack((spect, spectrophore))

