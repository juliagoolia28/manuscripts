%% load grand averaged varaible from ERSP analysis 
% load('GA.mat')
   
%% Define freq band boundaries
    theta_window = [4 8];
    alpha_window = [9 12];
    lowbeta_window = [13 19];
    upperbeta_window = [20 30];
    gamma_window = [30 50];
    
    cfg.toi=GA_OC.time ; 
    cfg.foi=GA_OC.freq;
    timeconverter = (cfg.toi)*1000;
    current_row = 0;

    %Define electrode regions
          Regionking.ROI_F = {'FP1','FPZ','FP2','AF3','AF4','F7','F5','F3','FT7','FC5','FC3','F1','FZ','F2','FC1','FCZ','FC2','F4','F6','F8','FC4','FC6','FT8'};
                    for yo = 1:length(Regionking.ROI_F)
                        Regionnums.ROI_F(yo)=find(strcmp(GA_OC.label, Regionking.ROI_F{yo}));
                    end
          Regionking.ROI_LC = {'T7','C5','C3','TP7','CP5','CP3','C1','CP1'};
                    for yo = 1:length(Regionking.ROI_LC)
                        Regionnums.ROI_LC(yo)=find(strcmp(GA_OC.label, Regionking.ROI_LC{yo}));
                    end
         Regionking.ROI_RC = {'C4','C6','T8','CP4','CP6','TP8','C2','CP2'};
                    for yo = 1:length(Regionking.ROI_RC)
                        Regionnums.ROI_RC(yo)=find(strcmp(GA_OC.label, Regionking.ROI_RC{yo}));
                    end 
         Regionking.ROI_LP = {'P7','P5','P3','PO7','PO5','P1','PO3'};
                    for yo = 1:length(Regionking.ROI_LP)
                        Regionnums.ROI_LP(yo)=find(strcmp(GA_OC.label, Regionking.ROI_LP{yo}));
                    end
         Regionking.ROI_RP = {'P4','P6','P8','PO6','PO8','P2','PO4'};
                    for yo = 1:length(Regionking.ROI_RP)
                         Regionnums.ROI_RP(yo)=find(strcmp(GA_OC.label, Regionking.ROI_RP{yo}));
                    end
%         Regionking.ROI_MA = {'FP1','FPZ','FP2','AF3','AF4'};
%                     for yo = 1:length(Regionking.ROI_MA)
%                         Regionnums.ROI_MA(yo)=find(strcmp(GA_OC.label, Regionking.ROI_MA{yo}));
%                     end
%         
%         Regionking.ROI_LF = {'F7','F5','F3','FT7','FC5','FC3'};
%                     for yo = 1:length(Regionking.ROI_LF)
%                         Regionnums.ROI_LF(yo)=find(strcmp(GA_OC.label, Regionking.ROI_LF{yo}));
%                     end
%         
%         Regionking.ROI_MF = {'F1','FZ','F2','FC1','FCZ','FC2'};
%                     for yo = 1:length(Regionking.ROI_MF)
%                         Regionnums.ROI_MF(yo)=find(strcmp(GA_OC.label, Regionking.ROI_MF{yo}));
%                     end
%        
%         Regionking.ROI_RF = {'F4','F6','F8','FC4','FC6','FT8'};
%                     for yo = 1:length(Regionking.ROI_RF)
%                         Regionnums.ROI_RF(yo)=find(strcmp(GA_OC.label, Regionking.ROI_RF{yo}));
%                     end
%         
%         Regionking.ROI_LC = {'T7','C5','C3','TP7','CP5','CP3'};
%                     for yo = 1:length(Regionking.ROI_LC)
%                         Regionnums.ROI_LC(yo)=find(strcmp(GA_OC.label, Regionking.ROI_LC{yo}));
%                     end
%         
%         Regionking.ROI_MC = {'C1','CZ','C2','CP1','CPZ','CP2'};
%                     for yo = 1:length(Regionking.ROI_MC)
%                         Regionnums.ROI_MC(yo)=find(strcmp(GA_OC.label, Regionking.ROI_MC{yo}));
%                     end
%                     
%         Regionking.ROI_RC = {'C4','C6','T8','CP4','CP6','TP8'};
%                     for yo = 1:length(Regionking.ROI_RC)
%                         Regionnums.ROI_RC(yo)=find(strcmp(GA_OC.label, Regionking.ROI_RC{yo}));
%                     end
%                     
%         Regionking.ROI_LP = {'P7','P5','P3','PO7','PO5'};
%                     for yo = 1:length(Regionking.ROI_LP)
%                         Regionnums.ROI_LP(yo)=find(strcmp(GA_OC.label, Regionking.ROI_LP{yo}));
%                     end
%                     
%         Regionking.ROI_MP = {'P1','PZ','P2','PO3','POZ','PO4'};
%                     for yo = 1:length(Regionking.ROI_MP)
%                         Regionnums.ROI_MP(yo)=find(strcmp(GA_OC.label, Regionking.ROI_MP{yo}));
%                     end
%                     
%         Regionking.ROI_RP = {'P4','P6','P8','PO6','PO8'};
%                     for yo = 1:length(Regionking.ROI_RP)
%                          Regionnums.ROI_RP(yo)=find(strcmp(GA_OC.label, Regionking.ROI_RP{yo}));
%                     end
%                     
%         Regionking.ROI_MO = { 'O1','OZ','O2'};
%                     for yo = 1:length(Regionking.ROI_MO)
%                         Regionnums.ROI_MO(yo)= find(strcmp(GA_OC.label, Regionking.ROI_MO{yo}));
%                     end
%                     
%         regions = {'ROI_MA','ROI_LF','ROI_MF','ROI_RF','ROI_LC','ROI_MC','ROI_RC','ROI_LP','ROI_MP','ROI_RP','ROI_MO'};
 regions = {'ROI_F','ROI_LC','ROI_RC','ROI_LP','ROI_RP'};      
% establish subject list
[d,s,r]=xlsread('wlnsf_subjects.xlsx');
subject_list = r;
numsubjects = (1:length(s));

start_sample_ersp = 0.25;
end_sample_ersp = 0.65;

for s=1:length(numsubjects)
    subject = subject_list{s};
    for t = 1:(length(timeconverter)-1)
                 
       [start_sample_ersp] =  t;
       [end_sample_ersp]   =  (t+1);
       binnum=timeconverter(t+1);

            % Loop through clusters
            for c = 1:length(regions); %length(FT_CFG.label);       
           
                 current_row = current_row+1; %current row to write data to in various arrays 
                
                 %Subject id
                subject_id{current_row, 1} = char(subject);
                
                %cluster info
                cluster_ID(current_row, 1) = regions(c);

                theta_pow(current_row, 1) = mean(squeeze(freq_OC.(['sub_' subject]).powspctrm(Regionnums.(char(regions(c))),theta_window(1):theta_window(2),start_sample_ersp:end_sample_ersp)),'all');
                lowbeta_pow(current_row, 1) = mean(squeeze(freq_OC.(['sub_' subject]).powspctrm(Regionnums.(char(regions(c))),lowbeta_window(1):lowbeta_window(2),start_sample_ersp:end_sample_ersp)),'all');
                alpha_pow(current_row, 1) = mean(squeeze(freq_OC.(['sub_' subject]).powspctrm(Regionnums.(char(regions(c))),alpha_window(1):alpha_window(2),start_sample_ersp:end_sample_ersp)),'all');
                upperbeta_pow(current_row, 1) = mean(squeeze(freq_OC.(['sub_' subject]).powspctrm(Regionnums.(char(regions(c))),upperbeta_window(1):upperbeta_window(2),start_sample_ersp:end_sample_ersp)),'all');
                
                %Time bin
                timebin(current_row, 1) =binnum ;

            end
    end

end

%reduced data table
data_table = table(subject_id, cluster_ID, theta_pow,alpha_pow,lowbeta_pow,upperbeta_pow,timebin); %create a data table with the information you extracted above
writetable(data_table, ['all_ersp_data_new_ROIs.csv']); %write the data to a csv file (add a filepath here if you want it saved somewhere other than the working directory)

