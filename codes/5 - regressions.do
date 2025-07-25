
*************
* Regressions
*************

*-----------------------
* Model 0: controls only
*-----------------------

	* System Quality
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
	
	* Patient satisfaction
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

*---------------------------
* Model 1: controls + income
*---------------------------
	
	* System quality
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
	
	* Patient satisfaction
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

*------------------------------
* Model 1: controls + education
*------------------------------

	* System quality
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
	
	* Patient satisfaction
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

*---------------------------------------
* Model 1: controls + income + education
*---------------------------------------
	
	* System quality
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
	
	* Patient satisfaction
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

*-------------------
* Model 4: clusters
*-------------------
	
	* System quality
		reg system_quality ib3.ses_cluster
		
		eststo mod_4_sq, r
	
	* Patient satisfaction
		reg patient_satisfaction ib3.ses_cluster
		
		eststo mod_4_ps, r

*-----------------------------
* Model 5: clusters + controls
*-----------------------------
	
	* System quality
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

	* Patient satisfaction
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


		
esttab mod_0_sq mod_1_sq mod_2_sq mod_3_sq ///
		using "$tables/SQ_regressions.rtf", ///
		 se r2 replace

esttab mod_0_ps mod_1_ps mod_2_ps mod_3_ps ///
		using "$tables/PS_regressions.rtf", ///
		se r2 replace

esttab mod_4_ps mod_5_ps mod_4_sq mod_5_sq using "$tables/ses_regressions.rtf", ///
		se r2 replace

*******************
* Mediation effects
*******************
	
	* Regressions 
	
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

	* Sobel tests
		
		** Patient satisfaction
			sgmediation2 patient_satisfaction, iv(ses_cluster) mv(activation_manage)
			sgmediation2 patient_satisfaction, iv(ses_cluster) mv(activation_tell)
			sgmediation2 patient_satisfaction, iv(ses_cluster) mv(health_mental)
			sgmediation2 patient_satisfaction, iv(ses_cluster) mv(trust_ministry)
		
		** System quality
			sgmediation2 system_quality, iv(ses_cluster) mv(health)
			sgmediation2 system_quality, iv(ses_cluster) mv(trust_scientists)
			sgmediation2 system_quality, iv(ses_cluster) mv(trust_ministry)
				

*******************
* Plotting section
*******************
	
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
				
		esttab robustness1 robustness2 using "$tables/cluster_robustness.rtf", p replace		
		
	* Distribution of age in the three clusters
		twoway (kdensity age if ses_cluster == 1, lcolor(blue)) ///
       (kdensity age if ses_cluster == 2, lcolor(red)) ///
       (kdensity age if ses_cluster == 3, lcolor(green)), ///
       legend(label(1 "Cluster 1") label(2 "Cluster 2") label(3 "Cluster 3")) ///
	   ytitle (Density) xtitle(Age)
			graph export "$figures/age_distributions.jpg", replace

