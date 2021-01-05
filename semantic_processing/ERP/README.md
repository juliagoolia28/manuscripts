## ERP Analysis for the "Neural underpinnings of preschooler’s semantic processing: evidence from the N400 and theta frequency of the EEG"

This 

1. Load EEGlab
2. ERPlab > Load ERP > Load 3-5_groupavg.erp
3. Create ROI:

```
ERP = pop_erpchanoperator( ERP, {  'ch63 = (ch9+ch10+ch11+ch27+ch28+ch29+ch36+ch37+ch38)/9 label Frontal Central'} , 'ErrorMsg', 'popup',...
 'KeepLocations',  0, 'Warning', 'on' );
```
4. Create Average Condition (related):

```
ERP = pop_binoperator( ERP, {  'b4 = (b1+b3)/2 label Related'});
```
5. Plot ERP Waveform:

```
ERP = pop_ploterps( ERP, [ 2 4],  63 , 'AutoYlim', 'on', 'Axsize', [ 0.05 0.08], 'BinNum', 'on', 'Blc', 'pre', 'Box', [ 1 1], 'ChLabel', 'on',...
 'FontSizeChan',  10, 'FontSizeLeg',  12, 'FontSizeTicks',  10, 'LegPos', 'bottom', 'Linespec', {'k-' , 'r-' }, 'LineWidth',  1, 'Maximize',...
 'on', 'Position', [ 103.714 29.6471 106.857 31.9412], 'Style', 'Classic', 'Tag', 'ERP_figure', 'Transparency',  0, 'xscale',...
 [ -99.0 998.0   -50 0:200:800 ], 'YDir', 'normal' );
 ```
6. Plot ERP Scalp Map:

```
ERP = pop_scalplot( ERP, [ 2 4], [ 300 450] , 'Blc', 'pre', 'Colormap', 'viridis', 'Electrodes', 'on', 'FontName', 'Courier New', 'FontSize',...
  10, 'Legend', 'bn-la', 'Maplimit', 'absmax', 'Mapstyle', 'both', 'Maptype', '2D', 'Mapview', '+X', 'Plotrad',  0.55, 'Value', 'mean' );
```
