# DIG Trial: Subgroup Analysis of Digoxin on Heart Failure Hospitalization

**Author:** Jay Sminchak  
**Language:** SAS 9.4

## Overview

This project performs a stratified subgroup analysis using data from the **Digitalis Investigation Group (DIG) clinical trial** — a large-scale, randomized, double-blind trial across 300+ centers in North America examining the effect of Digoxin on outcomes in patients with congestive heart failure.

**Research Question:** Is the effect of Digoxin vs. placebo on hospitalization due to worsening heart failure (WHF) modified by a history of hypertension at baseline?

## Dataset

The DIG trial dataset contains baseline and follow-up data on **6,800 subjects** randomized to Digoxin or placebo, with data collected from 1991 through mid-1995. Variables include treatment assignment, demographics, cardiac function measures, and hospitalization outcomes.

## Analysis

| Step | Method | Purpose |
|---|---|---|
| Descriptive statistics | PROC MEANS, PROC FREQ | Assess covariate balance across treatment arms within each subgroup |
| Overall effect | PROC FREQ (RD, RR, OR) | Estimate primary treatment effect |
| Stratified analysis | PROC FREQ with CMH | Compare treatment effects across hypertension subgroups |
| Interaction test | PROC LOGISTIC (trtmt\|hyperten) | Formally test for effect modification |
| Forest plot | PROC SGPLOT + ODS GRAPHICS | Visualize stratified odds ratios with 95% CIs |

## Key Results

- Digoxin reduced odds of WHF hospitalization in **both** subgroups (OR 0.71 and 0.68)
- Breslow-Day test: **no significant interaction** (p = 0.703)
- Hypertension history did **not** modify the treatment effect of Digoxin

## Repository Contents

| File | Description |
|---|---|
| `ILE_Analysis.sas` | Full SAS analysis program |
| `ILE_Report.pdf` | Written report: methods, results, discussion |
| `Figure1_StratifiedORs.png` | Forest plot of stratified odds ratios |

## Skills Demonstrated

- Stratified subgroup analysis in a randomized clinical trial setting
- Effect modification assessment (statistical interaction testing)
- Multiple effect measures: risk difference, risk ratio, odds ratio with 95% CIs
- Breslow-Day test for homogeneity of odds ratios
- ODS GRAPHICS for publication-quality forest plot output
- Regulatory-adjacent documentation (written report with methods and limitations)

## Reference

The Digitalis Investigation Group. (1997). The effect of digoxin on mortality and morbidity in patients with heart failure. *New England Journal of Medicine, 336*(8), 525–533.
