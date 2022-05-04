% make_large_dSq
% The original dSq's are merged together to make new dSq's for applying 
% larger nN values in manifold embedding (nN > n). 
% Copyright (c) Ourmazd Lab 2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear
addpath('/home/sna/release/2.0/connecting',...
        '/home/sna/release/2.0/core',...
        '/home/sna/release/2.0/validation',...
        '/home/sna/release/2.0/variations')

param.io_format = 'double';
param.local_destination_old = './test_results/';

% % parameters of the original dSq files in ./test_results and consistent 
% % with dSq_N*_n*_c*_row*_col*.mat:
N = 147799;         % # of snapshots
concatOrder = 4096; % concatination order
n = 8982;           % same as "n" in dSq_N*_n*_c*_row*_col*.mat

% % generating new dSq files:
m = 2;       % number of original blocks inside the combined block
nComb = m*n; % make sure to choose an "m" so that nComb gets bigger than the proposed nN.
numROW = ceil((N-concatOrder)/nComb);
numCOL = numROW;
param.local_destination_new = ['test_results_n',int2str(n*m),'/'];
if ~exist(param.local_destination_new,'dir')
    mkdir(param.local_destination_new);
end
%####### 

nB = N-concatOrder;
numFile = 1;  
io_format = param.io_format;
directory_old = param.local_destination_old;
fileName_template = ['dSq_N' num2str(N) '_n' num2str(n) '_c%d_row%d_col%d.dat'];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Start to combine distance blocks:
for ROW=1:numROW
for COL=1:numCOL
dSq = cell(m,m);   
tic    
for row = (1:m)+(ROW-1)*m
  for col = (1:m)+(COL-1)*m
    row
    col
    if (col<row)
      dSq{row-(ROW-1)*m,col-(COL-1)*m} = ...
      read_dSq([directory_old fileName_template],io_format,concatOrder,col,row,n)';
    else
      dSq{row-(ROW-1)*m,col-(COL-1)*m} = ...
      read_dSq([directory_old fileName_template],io_format,concatOrder,row,col,n);
    end 
  end
end
toc

tic
dSq = cell2mat(dSq);
toc

%############################
%%% writing to a new DAT file
tic
write_format = 'double';
directory_new = param.local_destination_new;

fileName_template_combined = ['dSq_N' num2str(N) '_n' num2str(nComb) '_c%d_row%d_col%d.dat'];
fileName = sprintf(fileName_template_combined,concatOrder,ROW,COL);
fid = fopen(fullfile(directory_new, fileName),'w');
  if (fid<0)
    dSq = zeros(nComb);
    return
  end
  fwrite(fid,dSq,write_format);
  fclose(fid);
toc

end  
end  

% EOF