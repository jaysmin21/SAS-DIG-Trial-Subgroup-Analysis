/*==========================================================
  DIG Trial: Subgroup Analysis of Digoxin vs. Placebo on
  Hospitalization Due to Worsening Heart Failure
  Stratified by Previous Hypertension at Baseline
  Author: Jay Sminchak
==========================================================*/

libname ile "C:\MPH\ILE"; run;

/*********FORMATS**********/
proc format;
value whff		0 = "B-No"	   	1 = "A-Yes";
value trtmtf 	0 = "B-Placebo" 1 = "A-Digoxin";
run;

/*********Dataset Setup**********/
data dig2;
	set ile.dig;
	format whf whff. trtmt trtmtf.;
run;
*** QC Check ***;
proc print data=dig2 (obs=25); run;

/*********Missing Data Check**********/
proc means data=dig2 nmiss;
	var trtmt whf hyperten;
run;

/*********Removing Observations w/ Missing Hypertension Status*********/
data dig3;
	set dig2;
	where hyperten ne .;
run;

/****Descriptive Statistics: Covariates by Hypertension Subgroup****/
proc freq data=dig3;
by hyperten;
	table race		*	trtmt	/norow;
	table sex		*	trtmt	/norow;
	table functcls	*	trtmt	/norow;
run;

proc means data=dig3 mean std median qrange;
	by hyperten;
	var bmi age ejf_per;
run;

/****Overall frequency analysis****/
proc freq data=dig3 order=formatted;
table trtmt	* whf / nocol nopercent
	riskdiff	(column=1 cl=wald norisks)
	relrisk		(column=1 cl=wald)
	oddsratio 	(cl=wald);
run;

/****stratified frequency analysis****/
proc freq data=dig3 order=formatted;
tables hyperten * trtmt*whf / chisq nocol nopercent cmh /*statistical test for interaction*/
	riskdiff	(column=1 cl=wald norisks)
	relrisk 	(column=1 cl=wald)
	oddsratio	(cl=wald);
run;


/****Stratified ORs for Forest Plot****/
ods output OddsRatios=ORs; /*Saving the corresponding ORs*/
proc logistic data=dig3;
by hyperten; /*stratified by hypertension status*/
   class trtmt (ref="B-Placebo")/ param=ref;
   model whf(event="A-Yes") = trtmt;
run;
ods output close;
proc print data=ors; run;

/* creating new labels for variables for better graphical representation */
data ORs_plot;
    set ORs;
    length HyperLabel $20;
    if hyperten = 0 then HyperLabel = "No Hypertension";
    else if hyperten = 1 then HyperLabel = "Hypertension";
run;


*************************************************************
Creating Forest Plot for Stratified ORs
*************************************************************;

ods graphics /	imagename="Figure1_Stratified_ORs" 
				imagefmt=png height=4in width=6in;
ods listing gpath="C:\MPH\ILE";

/* Simple horizontal forest-style plot */
proc sgplot data=ORs_plot noautolegend;
    scatter y=HyperLabel x=OddsRatioEst /
            xerrorlower=LowerCL xerrorupper=UpperCL
            markerattrs=(symbol=circlefilled size=8 color=black);
    refline 1 / axis=x 
		  lineattrs=(pattern=shortdash color=gray);
    xaxis label="Odds Ratio (95% CI)" 
		  type=log min=0.5 max=1.5;
    yaxis values=("Hypertension" "No Hypertension") 
          label="Hypertension Status" valueattrs=(size=10)
          offsetmin=0.25 offsetmax=0.25; 
    title "Treatment Effect on Heart Failure by Hypertension";
run;
ods listing close;
ods graphics off;
