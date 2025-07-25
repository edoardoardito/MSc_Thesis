foreach var of varlist _all {
	replace `var' = . if missing(`var')
}


python

import os
from sfi import Data
from sfi import Macro
import pandas as pd
from sklearn.impute import KNNImputer
import matplotlib.pyplot as plt
import numpy as np

# IMPORT DATA

d = Data.getAsDict(missingval=np.nan)
df = pd.DataFrame(d)
print(df.head())

# Make sure there are no string variables in df

for column in df.columns:
    if (df[column].dtype == object):
        print(column)
df = df.drop(columns=[column for column in df.columns if df[column].dtype == object])

print(df.info())

# (1) CORRELATED VARIABLES FOR IMPUTATION

correlations = df.corr()['income']
sorted_correlations = correlations.sort_values(ascending=False)

filtered_columns = [
	column for column in sorted_correlations.keys()
	if df[column].isnull().sum() <= 200
]

correlated_columns = filtered_columns[:15]

df[correlated_columns].isnull().sum()

# Create a new df with only the 15 most correlated variables to perform the imputation 
df_reduced = df[correlated_columns]
df_reduced

# (2) CHOSEN VARIABLES FOR IMPUTATION

# Select the variables
chosen_columns = ['income', 'age', 'region', 'gender', 'area', 'priv_insured', 'education', 'usual_type_own', 'political'] 

# Create a new df with only the chosen variables
df_chosen = df[chosen_columns]
df_chosen

# (3.1) IMPUTE WITH CORRELATED VARIABLES

imputer = KNNImputer(n_neighbors=5)

# Impute the data in a new df
df_knncorr = imputer.fit_transform(df_reduced)
df_knncorr = pd.DataFrame(df_knncorr, columns=df_reduced.columns)

# Round values of the new values 
df_knncorr['income'] = df_knncorr['income'].round()

df_knncorr.info()

# Copying the imputed column to original data frame 
df['impcor_income'] = df_knncorr['income']

# Show the original values and the imputed ones
df[['income', 'impcor_income']]

# (3.2) IMPUTE WITH CHOSEN VARIABLES 

imputer = KNNImputer(n_neighbors=5)

# Impute the data in a new df
df_knnchos = imputer.fit_transform(df_chosen)
df_knnchos = pd.DataFrame(df_knnchos, columns=df_chosen.columns)

# Round values of the new values 
df_knnchos['income'] = df_knnchos['income'].round()

df_knnchos.info()

# Copying the imputed column to original data frame 
df['impcho_income'] = df_knnchos['income']

# Show the original values and the imputed ones
df[['income', 'impcho_income']]

# PLOT THE DATA

real = df['income'].value_counts()
imputed_corr = df['impcor_income'].value_counts()
imputed_chos = df['impcho_income'].value_counts()

plt.figure(figsize=(10, 8))
plt.bar(real.index, real.values, label='Real', color='skyblue', width=0.8, alpha=0.7 )
plt.bar(imputed_corr.index , imputed_corr.values, label='Imputed', color='orange', width=0.5, alpha=0.5)
plt.bar(imputed_chos.index, imputed_chos.values, label='Imputed chosen', color='green', width=0.45, alpha=0.5)

plt.xlabel('Category')
plt.ylabel('Count')
plt.title('Distribution of Categories')
plt.show()

# EXPORT

outdir = Macro.getGlobal("data")

df_to_export = pd.DataFrame({
    'respid': df['respid'], 
    'impcor_income': df['impcor_income'],
    'impchos_income': df['impcho_income']
})

path = os.path.join(outdir, "imputed_income.dta")
df_to_export.to_stata(path, write_index=False)

end
