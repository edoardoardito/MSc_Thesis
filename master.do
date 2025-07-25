
*******************************
*** Install necessary packages
*******************************

// ssc install estout
// ssc install pca
// ssc install mca
// ssc install st0318
// ssc install missings
// ssc install heatplot
// ssc install palettes
// ssc install colrspace
// ssc install tabout
// net install sgmediation2, from("https://tdmize.github.io/data/sgmediation2") replace

*******************************
*** Set working directories
*******************************

*cd ".../Thesis Codes" //Replace cd as the folder in which this dofile is saved
cd "/Users/edoardoardito/Desktop/for github"

	* Define global macros
	
	global root "`c(pwd)'"
	global data "$root/data"
	global codes "$root/codes"
	global outputs "$root/outputs"
		global figures "$outputs/figures"
		global tables "$outputs/tables"

*******************************
*** Prepare data
*******************************

use "$data/PVS_data_AllCountries_24.09.19.dta", clear

*--------------
* Data cleaning
*--------------
	
	do "$codes/1 - clean_data.do"

*---------------------------------
* Impute missing values for income
*---------------------------------

	do "$codes/2 - impute_income.do"
	
	merge 1:1 respid using "$data/imputed_income.dta"
	drop _merge
	
	label var impcor_income "Income with missing values imputed by KNN method - most correlated variables"
	label var impchos_income "Income with missing values imputed by KNN method - selected variables"

*---------------------------------
* Generate Socio-Economic Clusters
*---------------------------------
	
	do "$codes/3 - clusters.do"
	
*---------------------------
* Generate Outcome variables
*---------------------------
	
	do "$codes/4 - indices.do"

********************
* Run Main Analyses
********************
	
	do "$codes/5 - regressions.do"
