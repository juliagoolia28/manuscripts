# Age and vocabulary knowledge differentially influence the N400 and theta responses during word processing. 
# Scripts and analyses run by Julie M. Schneider (juschnei@lsu.edu)

## Read these instructions for analysis of EEG data

1. Interpolate missing channels and resample data to 500 using interp_resample.m
2. Epoch the data and rereference to the average. Then reject artifacts using ft_preproc.m

## Prepare ERPs
At the bottom of the ft_preproc.m script there is a section for ERP Analysis. This section will create an average ERP for each individual. 

## Prepare for Fieldtrip time frequency analysis (ERSP)

To transform EEG data into the frequency domain, open the ft_multivariate.m script. This script will allow you to create an average frequency structure which we will extract frequency amplitude from. *Be sure to save the GA variable you construct at the end*.

## Extract ERP and ERSP measures 
I recommend conducting the ERSP analysis first.
1. Open the data_extract_ERSP.m script
2. Load your grand averaged variable from the previous step.
3. Determine which ROIs you are interested in and run the script.
4. The outcome will be table of frequency structures * time * subject
*This script is adapted from Jacob Momsen at San Diego State University*
5. Now open the data_extract_ERP.m script
6. Load all averaged .erp files (for each subject)
7. You will also still want your grand averaged ERSP file loaded as it contains the time windows of interest.
8. This script can be a little wonky, but basically, you are extracting the ERP amplitude at every time point averaging across each ROI. This stores each outcome as an individual ROI and then you average them together. *Full Disclosure*: I tried this script by averaging electrodes within an ROI together and running it, but often the data was innaccurate if electrodes were not touching (e.g. 45:52 20:23 does not work), so I ran them as mini-ROIs and averaged them together (e.g. 45:52 on its' own, then 20:23 and averaged together).
9. This will also produce a table of outcomes which we will analyze in R.

## R statistical analysis
All subsequent analyses were run in R (erp_ersp_oc_analysis_ROIs.Rmd). 

Plotting of the ERPs and ERSPs was done using the STUDY function of Matlab and information about this process can be shared by contacting the first author directly. 
