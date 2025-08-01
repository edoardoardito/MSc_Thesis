
********************
*** Select sample
********************
	
	keep if country == 14	// Italy, 1001 obs

********************
*** Clean variables
********************
	
	rename respondent_serial respid
	drop respondent_id
	
*------------------
* Geography
*------------------
	
	* Region
	replace region = mod(region, 100)
	
	label define region_lbl ///
		1  "Sicilia"                        ///
		2  "Campania"                       ///
		3  "Molise"                         ///
		4  "Calabria"                       ///
		5  "Basilicata"                     ///
		6  "Puglia"                         ///
		7  "Sardegna"                       ///
		8  "Liguria"                        ///
	   10  "Lazio"                          ///
	   11  "Piemonte"                       ///
	   12  "Abruzzo"                        ///
	   13  "Toscana"                        ///
	   14  "Umbria"                         ///
	   15  "Marche"                         ///
	   16  "Friuli‑Venezia Giulia"          ///
	   17  "Provincia Autonoma Trento"      ///
	   18  "Lombardia"                      ///
	   19  "Emilia‑Romagna"                 ///
	   20  "Veneto"                         ///
	   21  "Provincia Autonoma Bolzano/Bozen"
	label values region region_lbl
	
	* Area of residence
	forvalues i = 1(1)4 {
		replace q5 = `i' if q5 == 1400`i'
	}
	
	label define areas ///
		1 "City" ///
		2 "Suburb of a city" ///
		3 "Small town" ///
		4 "Rural area"
	label values q5 areas
	
	rename q5 area

*------------------
* Health Insurance
*------------------

	rename insur_type priv_insured
	drop insured

*------------------
* Income
*------------------
	drop income
	
	forvalues i = 1(1)7 {
		replace q51 = `i' if q51 == 1400`i'
	}
	
	label define inc ///
		1 "Less than 10,000 euros" ///
		2 "10,000-15,000 euros" ///
		3 "15,000-26,000 euros" ///
		4 "26,000-55,000 euros" ///
		5 "55,000-75,000 euros" ///
		6 "75,000-120,000 euros" ///
		7 "More than 120,000 euros"
	label values q51 inc
	rename q51 income

*------------------
* Education
*------------------
	
	drop education
	
	forvalues i = 2(1)7 {
		replace q8 = `i'-1 if q8 == 1400`i'
	}
	
	label define edu ///
		1 "Scuola primaria" ///
		2 "Scuola secondaria di primo grado" ///
		3 "Scuola secondaria di secondo grado" ///
		4 "Liceo, Istituto tecnico o professionale" ///
		5 "Laurea triennale" ///
		6 "Laurea magistrale"
	label values q8 educ
	
	rename q8 education

*----------------------
* Political affiliation
*----------------------
	
	drop q52_gb // Great Britain only
	
	forvalues i = 1(1)6 {
		replace q52 = `i' if q52 == 1400`i'
	}
	
	label define parties ///
		1 "Fratelli d'Italia" ///
		2 "Forza Italia" ///
		3 "Lega per Salvini Premier" ///
		4 "Azione / Italia Viva" ///
		5 "Partito democratico" ///
		6 "Movimento cinque stelle"
	label values q52 parties
	
	rename q52 political
	
*-------------------
* Patient activation
*-------------------
	
	foreach x in a b {
	
		replace q12_`x' = q12_`x' + 1
		
		label define act ///
			1 "Not at all confident" ///
			2 "Not too confident" ///
			3 "Somewhat confident" ///
			4 "Very confident"
		label values q12_`x' act
		label drop act
		
	}
	
	rename q12_a activation_manage
	rename q12_b activation_tell

*-------------------
* Confidence
*-------------------

	drop conf_sick conf_afford
	rename q41_a conf_sick
	rename q41_b conf_afford

********************
*** Drop Variables
********************
	
	rename qual_public xqual_public
	rename qual_private xqual_private
	
	drop country_reg mode q*
	
	rename xqual_public qual_public
	rename xqual_private qual_private
