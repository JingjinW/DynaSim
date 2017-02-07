function [data,studyinfo] = ImportPlots(file,varargin)
%% [data,studyinfo]=ImportData(data_file)
% data=ImportPlots(data_file)
% Purpose: load info about saved images (generated by SimulateMode or AnalyzeData)
%          alongwith corresponding varied model components. This command
%          only loads the paths to the image files, not the acutal images.
% Inputs:
%   file - studyinfo structure, study_dir, or studyinfo file (see CheckStudyinfo)
%   options -
%     'process_id',[],[],... % process identifier for loading studyinfo if necessary
% Outputs:
%   DynaSim data structure:
%     data.varied         : list of varied model components
%     data.plotpath       : path of corresponding plot file (png, svg, etc.)
% 
% Check inputs
options=CheckOptions({},{...
  'process_id',[],[],... % process identifier for loading studyinfo if necessary
  },false);

studyinfo=CheckStudyinfo(file,'process_id',options.process_id);
sim_info = studyinfo.simulations(:);

    for i = 1:length(sim_info)
        tmp_data.varied={};
        modifications=sim_info(i).modifications;
        modifications(:,1:2) = cellfun( @(x) strrep(x,'->','_'),modifications(:,1:2),'UniformOutput',0);
        for j=1:size(modifications,1)
            varied=[modifications{j,1} '_' modifications{j,2}];

            tmp_data.varied{end+1}=varied;
            tmp_data.(varied)=modifications{j,3};
        end    

        % Get plot files
        result_files = sim_info(i).result_files;
        
        % Add extension to file names as needed 
        result_files2 = cellfun(@(x) ls([x, '*']),result_files,'UniformOutput',0);
        result_files3 = cellfun(@(x) x(1:end-1),result_files2,'UniformOutput',0);      % ls returns strings with trailing spaces at the end. Need to remove these.
        tmp_data.plot_files = result_files3;
        
        data(i) = tmp_data;

    end

end

