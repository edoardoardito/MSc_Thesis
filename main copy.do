
*******************************
*** Install necessary packages
*******************************

ssc install estout
ssc install pca
ssc install mca
ssc install st0318
ssc install missings
ssc install heatplot
ssc install palettes
ssc install colrspace
ssc install tabout
net install sgmediation2, from("https://tdmize.github.io/data/sgmediation2") replace

*******************************
*** Set working directories
*******************************

global data "/Users/edoardoardito/Library/CloudStorage/OneDrive-UniversitàCommercialeLuigiBocconi/Edoardo MSc Thesis/Data Analysis/Stata files"
global codes "/Users/edoardoardito/Desktop/Thesis_codes"
global figures "/Users/edoardoardito/Library/CloudStorage/OneDrive-UniversitàCommercialeLuigiBocconi/Edoardo MSc Thesis/Figures"
global tables "/Users/edoardoardito/Library/CloudStorage/OneDrive-UniversitàCommercialeLuigiBocconi/Edoardo MSc Thesis/Tables"

* ---------------------------------------------------------------------------- *

*******************************
*** Prepare data
*******************************

use "$data/PVSvacc_Italy", clear

* Data cleaning
	do "$codes/data_cleaning.do"
	
	export delimited using PVS_ita_clean, nolabel replace // Will be used for imputing missing values in Python

	python script 
	
* Manage missing values
	** Save a version of the dataset with 999's coded as missing
		foreach var of varlist _all {
			replace `var' = . if `var' == 999
		}
		save "$data/PVS_italy_clean_withmissing.dta", replace

		missings report //Shows the number of missing values of for each variable

	** Test whether missingness is random
		mcartest income age region gender area numofchildren priv_insured education usual_type_own political

		gen inc_missing = missing(income)
		logit inc_missing age region gender i.area numofchildren priv_insured education i.usual_type_own i.political

	** Missing value imputation for income
		
		* --> Run Python code 'missing_data_income.ipynb' <-- *
		
		use "$data/PVS_italy_clean_withmissing", clear
		merge 1:1 respid using "$data/imputed_income.dta"
		drop _merge

		label variable impcor_income "Income with missing values imputed by KNN method - most correlated variables"
		label variable impchos_income "Income with missing values imputed by KNN method - selected variables"

		save "$data/PVS_italy_clean_imp_withmissing.dta", replace

* Generate and import socio-economic clusters
	use "$data/PVS_italy_clean_imp_withmissing.dta", clear
	do "$codes/cluster_analysis_compact"
	
	use "$data/PVS_italy_clean_imp_withmissing.dta", clear
	merge 1:1 respid using "$data/clusters.dta"
	drop _merge
	save "$data/PVS_italy_clean_imp_withmissing_clusters.dta", replace

* Generate and import the outcome variables (indeces)
	use "$data/PVS_italy_clean_imp_withmissing_clusters.dta", clear
	do "$codes/create_indeces"
	
* Save the final dataset
	save "$data/dataset_thesis_final.dta", replace
	
**# Main analyses

use "$data/dataset_thesis_final.dta", clear

* Regressions

	** Model 0: controls only
	
		reg system_quality ///
			age /// 				// Demographics
			gender ///
			i.area ///
			visits ///
			fac_number ///			// Access
			priv_insured ///
			i.usual_type_own ///
			activation_manage ///	// Health literacy / efficacy
			activation_tell ///
			health ///				// Health status
			health_mental ///
			health_chronic ///
			trust_scientists ///	// Trust
			trust_ministry
						
		eststo mod_0_sq, r
		
		reg patient_satisfaction ///
			age /// 				// Demographics
			gender ///
			i.area ///
			visits ///
			fac_number ///			// Access
			priv_insured ///
			i.usual_type_own ///
			activation_manage ///	// Health literacy / efficacy
			activation_tell ///
			health ///				// Health status
			health_mental ///
			health_chronic ///
			trust_scientists ///	// Trust
			trust_ministry
			
		eststo mod_0_ps, r
	
	** Model 1: controls + income
		reg system_quality income ///
			age /// 				// Demographics
			gender ///
			i.area ///
			visits ///
			fac_number ///			// Access
			priv_insured ///
			i.usual_type_own ///
			activation_manage ///	// Health literacy / efficacy
			activation_tell ///
			health ///				// Health status
			health_mental ///
			health_chronic ///
			trust_scientists ///	// Trust
			trust_ministry
			
		eststo mod_1_sq, r

		reg patient_satisfaction income ///
			age /// 				// Demographics
			gender ///
			i.area ///
			visits ///
			fac_number ///			// Access
			priv_insured ///
			i.usual_type_own ///
			activation_manage ///	// Health literacy / efficacy
			activation_tell ///
			health ///				// Health status
			health_mental ///
			health_chronic ///
			trust_scientists ///	// Trust
			trust_ministry
						
		eststo mod_1_ps, r

	** Model 2: controls + education

		reg system_quality education ///
			age /// 				// Demographics
			gender ///
			i.area ///
			visits ///
			fac_number ///			// Access
			priv_insured ///
			i.usual_type_own ///
			activation_manage ///	// Health literacy / efficacy
			activation_tell ///
			health ///				// Health status
			health_mental ///
			health_chronic ///
			trust_scientists ///	// Trust
			trust_ministry	
	
		eststo mod_2_sq, r

		reg patient_satisfaction education ///
			age /// 				// Demographics
			gender ///
			i.area ///
			visits ///
			fac_number ///			// Access
			priv_insured ///
			i.usual_type_own ///
			activation_manage ///	// Health literacy / efficacy
			activation_tell ///
			health ///				// Health status
			health_mental ///
			health_chronic ///
			trust_scientists ///	// Trust
			trust_ministry			
		
		eststo mod_2_ps, r

	** Model 3: controls + income + education

		reg system_quality income education ///
			age /// 				// Demographics
			gender ///
			i.area ///
			visits ///
			fac_number ///			// Access
			priv_insured ///
			i.usual_type_own ///
			activation_manage ///	// Health literacy / efficacy
			activation_tell ///
			health ///				// Health status
			health_mental ///
			health_chronic ///
			trust_scientists ///	// Trust
			trust_ministry		
	
		eststo mod_3_sq, r
		
		reg patient_satisfaction income education ///
			age /// 				// Demographics
			gender ///
			i.area ///
			visits ///
			fac_number ///			// Access
			priv_insured ///
			i.usual_type_own ///
			activation_manage ///	// Health literacy / efficacy
			activation_tell ///
			health ///				// Health status
			health_mental ///
			health_chronic ///
			trust_scientists ///	// Trust
			trust_ministry	
		
		eststo mod_3_ps, r

esttab mod_0_sq mod_1_sq mod_2_sq mod_3_sq ///
		using "$tables/SQ_regressions.rtf", ///
		 se r2 replace

esttab mod_0_ps mod_1_ps mod_2_ps mod_3_ps ///
		using "$tables/PS_regressions.rtf", ///
		se r2 replace

		
	** Model 4: clusters
		reg system_quality ib3.ses_cluster
		eststo mod_4_sq, r
		
		reg patient_satisfaction ib3.ses_cluster
		eststo mod_4_ps, r
	
	** Model 5: clusters + control
		reg system_quality ib3.ses_cluster ///
			age /// 				// Demographics
			gender ///
			i.area ///
			visits ///
			fac_number ///			// Access
			priv_insured ///
			i.usual_type_own ///
			activation_manage ///	// Health literacy / efficacy
			activation_tell ///
			health ///				// Health status
			health_mental ///
			health_chronic ///
			trust_scientists ///	// Trust
			trust_ministry	
		
		eststo mod_5_sq, r

		reg patient_satisfaction ib3.ses_cluster ///
			age /// 				// Demographics
			gender ///
			i.area ///
			visits ///
			fac_number ///			// Access
			priv_insured ///
			i.usual_type_own ///
			activation_manage ///	// Health literacy / efficacy
			activation_tell ///
			health ///				// Health status
			health_mental ///
			health_chronic ///
			trust_scientists ///	// Trust
			trust_ministry	
			
		eststo mod_5_ps, r
	
	esttab mod_4_ps mod_5_ps mod_4_sq mod_5_sq using "$tables/ses_regressions.rtf", ///
		se r2 replace

	
* Mediation effects
	
	replace activation_manage = 5 - activation_manage
	replace activation_tell = 5 - activation_tell	
	
	** Regressions 
	
		** SES --> M
			reg activation_manage ib3.ses_cluster
				eststo ses_manage, r
			
			reg activation_tell ib3.ses_cluster
				eststo ses_tell, r
			
			reg health ib3.ses_cluster age
				eststo ses_health, r
			
			reg health_mental ib3.ses_cluster
				eststo ses_mental, r
			
			logit health_chronic ib3.ses_cluster age
				eststo ses_chronic, r
			
			reg trust_scientists ib3.ses_cluster
				eststo ses_scien, r
			
			reg trust_ministry ib3.ses_cluster
				eststo ses_minis, r
						
			esttab ses_manage ses_tell ses_health ses_mental ses_chronic ses_scien ses_minis ///
				using "$tables/mediations.rtf", ///
				se r2 replace

	** Sobel tests
		*** Patient satisfaction
			sgmediation2 patient_satisfaction, iv(ses_cluster) mv(activation_manage)
			sgmediation2 patient_satisfaction, iv(ses_cluster) mv(activation_tell)
			sgmediation2 patient_satisfaction, iv(ses_cluster) mv(health_mental)
			sgmediation2 patient_satisfaction, iv(ses_cluster) mv(trust_ministry)
		
		*** System quality
			sgmediation2 system_quality, iv(ses_cluster) mv(health)
			sgmediation2 system_quality, iv(ses_cluster) mv(trust_scientists)
			sgmediation2 system_quality, iv(ses_cluster) mv(trust_ministry)
				
	** Explore the mediation effects
		sgmediation2 outcome_1_2, iv(ses_cluster) mv(trust_scientists)
		sgmediation2 outcome_1_2, iv(ses_cluster) mv(trust_ministry)
		sgmediation2 outcome_1_2, iv(ses_cluster) mv(health)
		sgmediation2 outcome_1_2, iv(ses_cluster) mv(big_region)

* Regress outcome_2_1 on SES
	reg outcome_2_1 ib3.ses_cluster
	
	reg outcome_2_1 ib3.ses_cluster ///
				age ///
				gender ///
				health ///
				health_mental ///
				health_chronic ///
				trust_scientists ///
				trust_ministry ///
				i.area ///
				i.big_region
	eststo reg_2
				
	** Explore mediation effects
		sgmediation2 outcome_2_1, iv(ses_cluster) mv(age)
		sgmediation2 outcome_2_1, iv(ses_cluster) mv(health)
		sgmediation2 outcome_2_1, iv(ses_cluster) mv(health_mental)
		sgmediation2 outcome_2_1, iv(ses_cluster) mv(health_chronic)
		sgmediation2 outcome_2_1, iv(ses_cluster) mv(trust_ministry)

**# Figures and Tables
	
	* Box plots SES clusters
		label define clusters 1 "Cluster 1" 2 "Cluster 2" 3 "Cluster 3"
		label values ses_cluster clusters
		label var education "Education"
		label var impchos_income "Income"
		
		graph box education impchos_income, over(ses_cluster)
			graph export "$figures/ses_boxplots.jpg", replace
		
	* Interpret the clusters
		logit priv_insured i.ses_cluster 
		eststo robustness1
		
		logit is_usual_priv i.ses_cluster
		eststo robustness2
		
		esttab robustness1 robustness2 using "$tables/cluster_robustness.rtf", p replace		
		
	* Distribution of age in the three clusters
		twoway (kdensity age if ses_cluster == 1, lcolor(blue)) ///
       (kdensity age if ses_cluster == 2, lcolor(red)) ///
       (kdensity age if ses_cluster == 3, lcolor(green)), ///
       legend(label(1 "Cluster 1") label(2 "Cluster 2") label(3 "Cluster 3")) ///
	   ytitle (Density) xtitle(Age)
			graph export "$figures/age_distributions.jpg", replace


