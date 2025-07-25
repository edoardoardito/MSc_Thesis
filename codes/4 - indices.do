
**************************************
* Outcome 1: System Quality Perception
**************************************

* Normalize variables

	sum conf_sick conf_afford qual_public qual_private ///
		trust_scientists trust_ministry ///
		phc_women phc_child phc_chronic phc_mental
	
	foreach q of varlist conf_sick conf_afford qual_public qual_private ///
						 trust_scientists trust_ministry ///
						 phc_women phc_child phc_chronic phc_mental {
		egen z_`q' = std(`q')
	}
	
* Preliminary checks	
	
	pwcorr z_conf_sick z_conf_afford z_qual_public ///
		   z_trust_scientists z_trust_ministry z_qual_private ///
		   z_phc_women z_phc_child z_phc_chronic z_phc_mental
	
	alpha z_conf_sick z_conf_afford z_qual_public ///
	   	  z_trust_scientists z_trust_ministry ///
		  z_qual_private z_phc_women ///
		  z_phc_child z_phc_chronic z_phc_mental // --> 0.85 

* Principal Component Analysis

	pca z_conf_sick z_conf_afford z_qual_public z_qual_private
	
	estat kmo // --> 0.710
	
	predict system_quality
	label var system_quality "System Quality Perception Index"
		
*********************************
* Outcome 2: Patient Satisfaction
*********************************

* Preliminary checks

	sum last_skills last_supplies last_respect last_know last_explain ///
		last_decisions last_visit_rate last_wait_rate last_courtesy ///
		last_sched_rate
		
	pwcorr last_skills last_supplies last_respect last_know last_explain ///
		   last_decisions last_visit_rate last_wait_rate last_courtesy ///
		   last_sched_rate
			
	alpha last_skills last_supplies last_respect ///
			last_know last_explain last_decisions ///
			last_visit_rate last_wait_rate ///
			last_courtesy last_sched_rate // --> 0.92
			

			
* Principal Component Analysis

	pca last_skills last_supplies last_respect ///
		last_know last_explain last_decisions ///
		last_visit_rate last_wait_rate last_courtesy ///
		last_sched_rate
		
	estat kmo // --> 0.95
	
	predict patient_satisfaction
	label var patient_satisfaction "Patient Satisfaction Index"

