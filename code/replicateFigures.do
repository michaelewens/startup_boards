/***

Figure 1, 2, 3, and 4 Code

***/

clear all

*** TO CUSTOMIZE ****
global input_dir "data/input"
global output_dir "figures"
*********************

	*** Figure 1

	* Import replication dataset
	import delimited "$input_dir/board_composition.csv", delimiter(",") varnames(1) clear
	
		* Drop if missing financing round number 
		drop if mi(financingroundnumer)
		
		* Aggregate all rounds at or after the fifth into "5"
		replace financingroundnumer = 5 if financingroundnumer > 5
		
		* Compute Averages
		preserve
			collapse (mean) avg_dir = numout avg_exe = numexecs avg_vc = numvcs, by(financingroundnumer)
			tempfile avg_data
			save `avg_data'
		restore

		* Compute Medians
		preserve
			collapse (median) med_dir = numout med_exe = numexecs med_vc = numvcs, by(financingroundnumer)
			tempfile med_data
			save `med_data'
		restore

		* Load Averages and Graph
		use `avg_data', clear
		twoway  (connected avg_dir financingroundnumer, lpattern(solid) lcolor(gs7) lwidth(thick) mcolor(gs7) msize(small)) ///
				(connected avg_exe financingroundnumer, lpattern(dash_dot) lcolor(dkorange) lwidth(thick) mcolor(dkorange) msize(small)) ///
				(connected avg_vc financingroundnumer, lpattern(dash) lcolor(emerald) lwidth(thick) mcolor(emerald) msize(small)), ///
				title("Average") ///
				ytitle("# of seats") ///
				xtitle("Financing round") ///
				ylabel(0(1)4) ///
				legend(order(3 "VCs" 2 "Executives" 1 "IDs") position(6) col(3) region(lcolor(black))) ///
				name(avg_graph)

		* Load Medians and Graph
		use `med_data', clear
		twoway  (connected med_dir financingroundnumer, lpattern(solid) lcolor(gs7) lwidth(thick) mcolor(gs7) msize(small)) ///
				(connected med_exe financingroundnumer, lpattern(dash_dot) lcolor(dkorange) lwidth(thick) mcolor(dkorange) msize(small)) ///
				(connected med_vc financingroundnumer, lpattern(dash) lcolor(emerald) lwidth(thick) mcolor(emerald) msize(small)), ///
				title("Median") ///
				ytitle("# of seats") ///
				xtitle("Financing round") ///
				legend(off) ///
				ylabel(0(1)4) ///
				name(med_graph)

		* Combine both graphs into one layout
		grc1leg avg_graph med_graph, legendfrom(avg_graph) // requires ssc installation
		
		* Export Figure 1
		graph export "$output_dir/figure_1.png", replace
		
	*** Figure 2

	* Import replication dataset
	import delimited "$input_dir/board_composition.csv", delimiter(",") varnames(1) clear
	
		* Drop if missing financing round number 
		drop if mi(financingroundnumer)
		
		* Get total board seat 
		gen numtotal = numout + numexecs + numvcs 
		
		* Aggregate all rounds at or after the fifth into "5"
		replace financingroundnumer = 5 if financingroundnumer > 5
		
		* Get pct of each seat category 
		gen pctout = numout / numtotal 
		gen pctexecs = numexecs / numtotal
		gen pctvcs = numvcs /numtotal
		
		* Compute Averages
		preserve
			collapse (mean) avg_dir = pctout avg_exe = pctexecs avg_vc = pctvcs avg_total = numtotal, by(financingroundnumer)
			tempfile avg_data
			save `avg_data'
		restore

		* Compute Medians
		preserve
			collapse (median) med_dir = pctout med_exe = pctexecs med_vc = pctvcs med_total = numtotal, by(financingroundnumer)
			tempfile med_data
			save `med_data'
		restore

		* Load Averages and Graph
		use `avg_data', clear
		twoway  (connected avg_dir financingroundnumer, lpattern(solid) lcolor(gs7) lwidth(thick) mcolor(gs7) msize(small)) ///
				(connected avg_exe financingroundnumer, lpattern(dash_dot) lcolor(dkorange) lwidth(thick) mcolor(dkorange) msize(small)) ///
				(connected avg_vc financingroundnumer, lpattern(dash) lcolor(emerald) lwidth(thick) mcolor(emerald) msize(small)) ///
				(connected avg_total financingroundnumer, lpattern(dot) lcolor(maroon) lwidth(thick) mcolor(maroon) msize(small) yaxis(2)), ///
				title("Average") ///
				ytitle("% of seats") ///
				ytitle("Total seats", axis(2)) ///
				xtitle("Financing round") ///
				ylabel(0(0.1)0.6) ///
				ylabel(0 1 2 3 4 5 6, axis(2)) ///
				legend(order(3 "% VCs" 2 "% Executives" 1 "% IDs" 4 "Board size") position(6) col(2) region(lcolor(black))) ///
				name(avg_graph, replace)

		* Load Medians and Graph
		use `med_data', clear
		twoway  (connected med_dir financingroundnumer, lpattern(solid) lcolor(gs7) lwidth(thick) mcolor(gs7) msize(small)) ///
				(connected med_exe financingroundnumer, lpattern(dash_dot) lcolor(dkorange) lwidth(thick) mcolor(dkorange) msize(small)) ///
				(connected med_vc financingroundnumer, lpattern(dash) lcolor(emerald) lwidth(thick) mcolor(emerald) msize(small)) ///
				(connected med_total financingroundnumer, lpattern(dot) lcolor(maroon) lwidth(thick) mcolor(maroon) msize(small) yaxis(2)), ///
				title("Median") ///
				ytitle("% of seats") ///
				ytitle("Total seats", axis(2)) ///
				xtitle("Financing round") ///
				ylabel(0(0.1)0.6) ///
				ylabel(0 1 2 3 4 5 6, axis(2)) ///
				legend(off) ///
				name(med_graph, replace)

		* Combine both graphs into one layout
		grc1leg avg_graph med_graph, legendfrom(avg_graph) // requires ssc installation
		
		* Export Figure 2
		graph export "$output_dir/figure_2.png", replace
		
	*** Figure 3
	
	/* 
	We call a board "VC-controlled" if VC directors hold strictly more
	than 50% of seats, or if they hold exactly 50% of seats and executives hold strictly less (i.e.,
	the remaining 50% of seats are split between executives and independent directors).14 We call
	a board "entrepreneur-controlled" if executives hold strictly more than 50% of seats, or if they
	hold exactly 50% and VCs hold strictly less.
	*/

	* Import replication dataset
	import delimited "$input_dir/board_composition.csv", delimiter(",") varnames(1) clear
	
		* Drop if missing financing round number 
		drop if mi(financingroundnumer)
		
		* Get total board seat 
		gen numtotal = numout + numexecs + numvcs 
		
		* Aggregate all rounds at or after the fifth into "5"
		replace financingroundnumer = 5 if financingroundnumer > 5
		
		* Get pct of each seat category 
		gen pctout = numout / numtotal 
		gen pctexecs = numexecs / numtotal
		gen pctvcs = numvcs /numtotal
		
		* Define VC controlled, Entrepreneur controlled, and neither (shared)
		gen vc_controlled = (pctvcs > 0.5 | (pctvcs == 0.5 & pctexecs < 0.5))
		gen ent_controlled = (pctexecs > 0.5 | (pctexecs == 0.5 & pctvcs < 0.5))
		gen neither = (!vc_controlled & !ent_controlled) 
		
		* Compute shares of control 
		collapse (mean) pct_vcs = vc_controlled pct_ent = ent_controlled pct_shared = neither, by(financingroundnumer)

		* Graph
		twoway  (connected pct_shared financingroundnumer, lpattern(solid) lcolor(gs7) lwidth(thick) mcolor(gs7) msize(small)) ///
				(connected pct_ent financingroundnumer, lpattern(dash_dot) lcolor(dkorange) lwidth(thick) mcolor(dkorange) msize(small)) ///
				(connected pct_vcs financingroundnumer, lpattern(dash) lcolor(emerald) lwidth(thick) mcolor(emerald) msize(small)), ///
				ytitle("% of startups") ///
				xtitle("Financing round number") ///
				ylabel(0(0.1)0.7) ///
				legend(order(3 "VC" 2 "Entrepreneur" 1 "Shared") position(6) col(3) region(lcolor(black)))		
		
		* Export Figure 3
		graph export "$output_dir/figure_3.png", replace
		
	*** Figure 4

	* Import replication dataset
	import delimited "$input_dir/board_composition.csv", delimiter(",") varnames(1) clear
	
		* Get first financing year for each firm
		preserve
			keep cik1 year 
			duplicates drop 
			bys cik1 (year): keep if _n == 1
			rename year firstfinancingyear
			tempfile firstfinyear
			save `firstfinyear'
		restore
		
		merge m:1 cik1 using `firstfinyear', nogen
			
		* Keep if round 1 ~ 3
		keep if inlist(financingroundnumer, 1, 2, 3)
		
		* Get total board seat 
		gen numtotal = numout + numexecs + numvcs 
		
		* Get pct of each seat category 
		gen pctout = numout / numtotal 
		gen pctexecs = numexecs / numtotal
		gen pctvcs = numvcs /numtotal
		
		* Define VC controlled, Entrepreneur controlled, and neither (shared)
		gen vc_controlled = (pctvcs > 0.5 | (pctvcs == 0.5 & pctexecs < 0.5))
		gen ent_controlled = (pctexecs > 0.5 | (pctexecs == 0.5 & pctvcs < 0.5))
		gen neither = (!vc_controlled & !ent_controlled) 
		
		* Compute percentage of startups where the board is VC controlled grouped by first financing year & round number
		preserve
			collapse (mean) pct_vc_cont = vc_controlled, by(financingroundnumer firstfinancingyear)
			keep if firstfinancingyear <= 2013
			tempfile vccontrolled
			save `vccontrolled'
		restore

		* Compute percentage of startups where the board is Entrepreneur controlled grouped by first financing year & round number
		preserve
			collapse (mean) pct_ent_cont = ent_controlled, by(financingroundnumer firstfinancingyear)
			keep if firstfinancingyear <= 2013
			tempfile entcontrolled
			save `entcontrolled'
		restore
		
		* Compute percentage of startups where the board is Shared controlled grouped by first financing year & round number
		preserve
			collapse (mean) pct_share_cont = neither, by(financingroundnumer firstfinancingyear)
			keep if firstfinancingyear <= 2013
			tempfile sharecontrolled
			save `sharecontrolled'
		restore

		* Load Shares and Graph
		use `vccontrolled', clear
		twoway  (connected pct_vc_cont firstfinancingyear if financingroundnumer == 3, lpattern(solid) lcolor(gs7) lwidth(thick) mcolor(gs7) msize(small)) ///
				(connected pct_vc_cont firstfinancingyear if financingroundnumer == 2, lpattern(dot) lcolor(dkorange) lwidth(thick) mcolor(dkorange) msize(small)) ///
				(connected pct_vc_cont firstfinancingyear if financingroundnumer == 1, lpattern(dash) lcolor(emerald) lwidth(thick) mcolor(emerald) msize(small)), ///
				title("VC control") ///
				xtitle("Year first VC") ///
				ytitle("") ///
				ylabel(0(0.1)0.8) ///
				xlabel(2002 2004 2006 2008 2010 2012) ///
				legend(order(3 "Round 1" 2 "Round 2" 1 "Round 3") position(6) col(3) region(lcolor(black))) ///
				name(vccont, replace)

		use `entcontrolled', clear
		twoway  (connected pct_ent_cont firstfinancingyear if financingroundnumer == 3, lpattern(solid) lcolor(gs7) lwidth(thick) mcolor(gs7) msize(small)) ///
				(connected pct_ent_cont firstfinancingyear if financingroundnumer == 2, lpattern(dot) lcolor(dkorange) lwidth(thick) mcolor(dkorange) msize(small)) ///
				(connected pct_ent_cont firstfinancingyear if financingroundnumer == 1, lpattern(dash) lcolor(emerald) lwidth(thick) mcolor(emerald) msize(small)), ///
				title("Entrepreneur control") ///
				xtitle("Year first VC") ///
				ytitle("") ///
				ylabel(0(0.1)0.8) ///
				xlabel(2002 2004 2006 2008 2010 2012) ///
				legend(off) ///
				name(entcont, replace)
				
		use `sharecontrolled', clear
		twoway  (connected pct_share_cont firstfinancingyear if financingroundnumer == 3, lpattern(solid) lcolor(gs7) lwidth(thick) mcolor(gs7) msize(small)) ///
				(connected pct_share_cont firstfinancingyear if financingroundnumer == 2, lpattern(dot) lcolor(dkorange) lwidth(thick) mcolor(dkorange) msize(small)) ///
				(connected pct_share_cont firstfinancingyear if financingroundnumer == 1, lpattern(dash) lcolor(emerald) lwidth(thick) mcolor(emerald) msize(small)), ///
				title("Shared control") ///
				xtitle("Year first VC") ///
				ytitle("") ///
				ylabel(0(0.1)0.8) ///
				xlabel(2002 2004 2006 2008 2010 2012) ///
				legend(off) ///
				name(sharedcont, replace)

		* Combine both graphs into one layout
		grc1leg vccont entcont sharedcont, legendfrom(vccont) cols(3) // requires ssc installation
		
		* Export Figure 4
		graph export "$output_dir/figure_4.png", replace
		
