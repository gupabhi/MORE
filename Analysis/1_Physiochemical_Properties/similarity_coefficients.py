import xlrd
import pandas as pd
from rdkit import Chem,DataStructs
from rdkit.Chem import rdMolDescriptors

def get_coefficients(data, ref_molecule_smile):
    columns = ['tanimoto', 'dice']
    df_simcoeff = pd.DataFrame(index=data.Odor, columns=columns)

    for i in range(0, data.shape[0]):
        odor = data.Odor[i]
        smile = data.Smile[i]
        molecule_1 = Chem.MolFromSmiles(ref_molecule_smile)
        molecule_2 = Chem.MolFromSmiles(smile)    
        
        # the default fingerprint is path-based:
        fp1 = Chem.RDKFingerprint(molecule_1)
        fp2 = Chem.RDKFingerprint(molecule_2)
        # the Morgan fingerprint (similar to ECFP) is also useful:
        mfp1 = rdMolDescriptors.GetMorganFingerprint(molecule_1,2)
        mfp2 = rdMolDescriptors.GetMorganFingerprint(molecule_2,2)

        tanimoto = DataStructs.TanimotoSimilarity(fp1,fp2)
        dice = DataStructs.DiceSimilarity(mfp1,mfp2)

        df_simcoeff.tanimoto[i] = tanimoto
        df_simcoeff.dice[i] = dice

    return df_simcoeff.tanimoto, df_simcoeff.dice

# Intialize variables
excel_file = "./input_data/data.xlsx"
data_hallem = pd.read_excel(excel_file, sheet_name='Hallem2006')
data_carey = pd.read_excel(excel_file, sheet_name='Carey2010')
columns = ['tanimoto', 'dice']
ref_molecule_smile = "CCN(CC)C(=O)C1=CC(=CC=C1)C" # DEET
output_file = "./output/similarity_coefficients.xlsx"
writer = pd.ExcelWriter(output_file)

# Carey2010
df_simcoeff_carey = pd.DataFrame(index=data_carey.Odor, columns=columns)
df_simcoeff_carey.tanimoto, df_simcoeff_carey.dice = get_coefficients(data_carey, ref_molecule_smile)
df_simcoeff_carey.to_excel(writer,'Carey2010',index=False)
writer.save()

# Hallem2006
df_simcoeff_hallem = pd.DataFrame(index=data_hallem.Odor, columns=columns)
df_simcoeff_hallem.tanimoto, df_simcoeff_hallem.dice = get_coefficients(data_hallem, ref_molecule_smile)
df_simcoeff_hallem.to_excel(writer,'Hallem2006',index=False)
writer.save()