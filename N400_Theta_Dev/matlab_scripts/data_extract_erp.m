% First load all ERP files into ERPlab
% load grand averaged varaible from ERSP analysis load('GA.mat')
clear erp_amp
clear ERP_MEASURES
current_row = 0;

cfg.toi=GA_OC.time;
timeconverter = (cfg.toi)*1000;
timeconverter(:,1:21) = []
timeconverter = round(timeconverter,0)
%timeconverter = (cfg.toi)*1000;
%RC 30:32,39:41
%LP  42:44 51 52
%MP  45:47 53:55
%RP   48:50 56 57
%MO  59:61
%[timeconverter{i}]

for t = timeconverter
    current_row = current_row+1
    pop_geterpvalues(ALLERP, t , 1,  [mean(42:45)], 'Baseline', 'pre', 'Erpsets',  1:226, 'FileFormat', 'wide', 'Fracreplace', 'NaN', 'InterpFactor',...
    1, 'Measure', 'instabl', 'PeakOnset',  1, 'Resolution',  3, 'SendtoWorkspace', 'on' );
    erp_amp_lp(current_row,:) = num2cell(ERP_MEASURES(1,:));
end

%if you need to average two cells together (in the event you have different
%groups of electrodes
M={erp_amp_rc,erp_amp_rc_1}
B=cat(3,M{:})
B = cell2mat(B)
erp_amp_rc=mean(B,3)


% Saving
erp_amp_f = erp_amp_f(:) 
save('/Users/julie/Box/N400 and Theta_WLNSF/erp_files/erp_amp_new_f.mat','erp_amp_f')

%% 
%clear erp_amp_lf
f = num2cell(erp_amp_f(:))
%mf = num2cell(erp_amp_mf(:))
%rf = num2cell(erp_amp_rf(:))
lc = num2cell(erp_amp_lc(:))
%mc = num2cell(erp_amp_mc(:)) 
rc = num2cell(erp_amp_rc(:))
lp = num2cell(erp_amp_lp(:))
%mp = erp_amp_mp(:) 
rp = num2cell(erp_amp_rp(:))
%mo = erp_amp_mo(:) 

%erp_combined = [ma;lf;mf;rf;lc;mc;rc;lp;mp;rp;mo];
erp_combined = [f;lc;rc;lp;rp]

% Convert cell to a table and use first row as variable names
T = cell2table(erp_combined)
 
% Write the table to a CSV file
writetable(T,'/Users/julie/Box/N400 and Theta_WLNSF/erp_files/erp_combined_new_ROIs.csv')
