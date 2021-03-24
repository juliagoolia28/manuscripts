## ERP Analysis for the "Neural underpinnings of preschooler’s semantic processing: evidence from the N400 and theta frequency of the EEG"

The group average file was created based on individual analyses done using the [erplab analysis script](https://github.com/juliagoolia28/manuscripts/blob/master/semantic_processing/ERP/erplab_analysis.m).
 - binlist.txt file is used for BINLISTER
 - great_grand_avg_erp.txt file is used to upload all files and creat grand average that is used below

1. Load EEGlab
2. ERPlab > Load ERP > Load 3-5_groupavg.erp
3. Create ROI:

```
ERP = pop_erpchanoperator( ERP, {  'ch63 = (ch5+ch3+ch12+ch14)/4 label Frontal ERP Cluster'} , 'ErrorMsg', 'popup', 'KeepLocations',  0, 'Warning', 'on' );
```
4. Create Average Condition (related; should already be created, but optional if your data does not already have this):
```
ERP = pop_binoperator( ERP, {  'b4 = (b1+b3)/2 label Related'});
```
5. Plot ERP Waveform:

```
ERP = pop_ploterps( ERP, [ 2 4],  63 , 'AutoYlim', 'on', 'Axsize', [ 0.05 0.08], 'BinNum', 'on', 'Blc', 'pre', 'Box', [ 1 1], 'ChLabel', 'on',...
 'FontSizeChan',  10, 'FontSizeLeg',  12, 'FontSizeTicks',  10, 'LegPos', 'bottom', 'Linespec', {'k-' , 'r-' }, 'LineWidth',  1, 'Maximize',...
 'on', 'Position', [ 63.1429 15.5882 106.857 31.9412], 'Style', 'Classic', 'Tag', 'ERP_figure', 'Transparency',  0, 'xscale',...
 [ -99.0 998.0   -50 0:200:800 ], 'YDir', 'normal' );
 ```
6. Extract ERP Values using ERPlab Measurement Tool: ![erplab_params](https://github.com/juliagoolia28/manuscripts/blob/master/semantic_processing/ERP/erplab_params.png)

