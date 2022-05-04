% run_PYP_femtosec_concat_x_USV
%
  addpath('/home/sna/release/2.0/connecting',...
          '/home/sna/release/2.0/core',...
          '/home/sna/release/2.0/validation',...
          '/home/sna/release/2.0/variations');
% loading data file located on the local host machine
load('../dataPYP/dataPYP_femto_nS147799_nBrg15498.mat','T');
X1 = T'; 
sigmaOpt = 5.4E+02; % sigma of diffusion map (same as that in dataPsi*.mat below)
% loading diffusion map eigenfunctions located on the local host machine
dataPsi_template = './dataPsi/dataPsi_nS143703_nN1000_nA0_sigma5.40E+02_nEigs5.mat';
read_format = 'double';
D = 15498;          % # of pixels (Bragg points)
N = 147799;         % # of snapshots before concatenation
n = 8982;           % compatible with dp_N*_n*_c* folder
concatOrder = 4096; % concatenation order
num_copy = 1000;    % # of copies (topos) for unwrapping
ell = 4;            % # of \psi's for projecting

sigmaList0 = 10.^linspace(log10(sigmaOpt/10),log10(sigmaOpt),7);
sigmaList1 = 10.^linspace(log10(sigmaOpt),log10(sigmaOpt*20),10);
sigmaList = unique([sigmaList0 sigmaList1]);

% compute SVD for different sigma values (sigma search)
for jj=7%1:16 %(jj=7 gives sigmaList=1)
  sigma = sigmaList(jj);
  dataPsi = sprintf(dataPsi_template,num2str(sigma,'%.4f'));
  [U,S,V] = extract_topos_chronos(ell,X1,dataPsi,read_format,D,N,n,concatOrder,num_copy);
  fileNameUSV = ['SVD_results_sigma' num2str(sigma,'%.2f') '.mat'];
  save(fileNameUSV,'U','S','V','-v7.3')
end

%EOF