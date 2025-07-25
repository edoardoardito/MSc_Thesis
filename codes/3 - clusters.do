
**********************************************
* Three clusters based on income and education
**********************************************

*-------------
* Prepare data
*-------------
	
	* Normalize

		drop if education == . 
		egen z_educ = std(education)
	
		egen z_inc = std(impchos_income)
		
	* Assess the quality of income and education as determinants for clusters
		
		pwcorr impchos_income educ, sig // --> 0.31, ss
				
*-------------------------------------------
* Generate clusters, weighted average method
*-------------------------------------------
	
	cluster wav z_inc z_educ
	cluster gen ses_cluster = gr(3)
	
*-----------		
* Validation
*------------

	* Silhouette
		sort respid
		matrix dissimilarity D = (z_inc z_educ)
		version 10: silhouette ses_cluster, distmat(D) idvar(respid)
	
	* are people in poorer clusters less likely to have a private insurance?
		logit priv_insured ib3.ses_cluster // --> Ok
		
	* How is age distributed in each cluster?
		reg age i.ses_cluster // --> Makese sense
			kdensity age if ses_cluster == 1
			kdensity age if ses_cluster == 2
			kdensity age if ses_cluster == 3
		
	* Do people in poorer clusters live more often out of the cities?
		graph bar (percent), over(area, label(angle(45))) ///
							over(ses_cluster) nolabel

