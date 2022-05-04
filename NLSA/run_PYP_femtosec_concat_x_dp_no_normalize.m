% run_PYP_femtosec_concat_x_dp_no_normalize
% 
% copyright (c) Russell Fung 2016
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  addpath('/home/sna/release/2.0/connecting',...
          '/home/sna/release/2.0/core',...
          '/home/sna/release/2.0/validation',...
          '/home/sna/release/2.0/variations')
  D = 15498;            % # of pixels (Bragg points)
  N = 147799;           % # of snapshots before concatenation
  numTasks = 16;        % # of tasks on the cluster                   
  concatOrder = 4096;   % concatenation order
  n = ceil((N-concatOrder)/numTasks); 
  
%%%%%
% data parameters
% data file located on the computer cluster
  param.rawDataFile = ['/home/username/PYP/dataPYP_femto_nS147799_nBrg15498.mat'];
  %
  % data must first be uploaded onto the worker nodes
  %
  param.rawDataVar = 'T';
  param.io_format = 'double';
  param.D = D;
  param.N = N;
  param.n = n;
  param.c = concatOrder;
%%%%%
% local machine parameters
%  local machine is where you are sending the jobs from
%
  param.local_hostname = 'localServer.uwm.edu';
  param.local_destination = 'test_results/';
%%%%%
% remote cluster parameters
%  remote cluster is where you are sending the jobs to
%
  param.remote_hostname = 'remoteCluster.uwm.edu'; 
  userID = get_username();
  param.username = userID;
  param.share_directory = ['/home/' userID '/PYP/dataY/']; % on the cluster
  param.worker_directory_prefix = ['/local/worker_' userID '_']; % on worker nodes
%%%%%
  parallel_SnA_dp
  
  directory = ['dp_N' num2str(N) '_n' num2str(n) '_c' num2str(concatOrder) '/'];
  fileName_wildcard = ['dp_N' num2str(N) '_n' num2str(n) '_c' num2str(concatOrder) '_row*_col*.dat'];
  system(['mkdir ' directory]);
  %system(['mv ' fileName_wildcard ' ' directory]);
  system(['mv ' param.local_destination fileName_wildcard ' ' directory]);  

% end run_PYP_femtosec_concat_x_dp_no_normalize
