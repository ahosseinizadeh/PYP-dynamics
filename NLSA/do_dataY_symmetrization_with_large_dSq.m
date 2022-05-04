% do_dataY_symmetrization_with_large_dSq
% does symmetrization on the distance blocks from "make_large_dSq.m".
% Copyright (c) Ourmazd Lab, 2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 clear
 addpath('/home/sna/release/2.0/connecting',...
         '/home/sna/release/2.0/core',...
         '/home/sna/release/2.0/validation',...
         '/home/sna/release/2.0/variations');
      
 D = 15498;          % number of Bragg points
 N = 147799;         % number of samples before concatenation
 concatOrder = 4096; % concatenation parameter
 n = 17964;          % equal to nComb in "make_large_dSq.m" 
 nN = 5000;          % number of nearest-neighbors. Always must have: nN<n

 param.io_format = 'double';
 param.D = D;
 param.N = N;
 param.n = n;
 param.c = concatOrder;
 param.local_destination = './test_results_n17964/'; % output of "make_large_dSq.m"

 nB = N-concatOrder;
 numFile = 1;   % (N-concatOrder) = nB * numFile
 io_format = param.io_format;
 directory = param.local_destination;
 fileName_template = ['dSq_N' num2str(N) '_n' num2str(n) '_c%d_row%d_col%d.dat'];
 %%%%%%%%%%
 make_dataY_files
 
 clearvars -except N nN nB concatOrder yVal yCol yInd
 
 scriptDistanceSymmetrization
 %%%%%%%%%%

 %system(['rm -rf ' directory]);
 system('rm -f dataY*iB*');
 system('mv dataY*sym.* ./dataY');
 %clear
 
 % EOF