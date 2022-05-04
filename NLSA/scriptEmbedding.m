% scriptEmbedding
%
% copyright (c) Ourmazd Lab 2011
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 nS         = 143703;   % Number of samples
 nEigs      = 5;        % Number of eigenfunctions to compute
 nA         = 0;        % Autotuning parameter 
 nN         = 1000;     % Number of nearest neighbors
 nNA        = 0;        % No. of nearest neighbors used for autotuning
 sigma      = 54.0;     % Gaussian Kernel width (=1 for autotuning)
 alpha      = 1;        % Kernel normalization (=1 for Laplace Beltrami)
 
ifEmbed    = true;

addpath( './Dimitris' );

if ifEmbed

    logfileEmbed = [ 'dataPsi/dataPsi', ...
                      '_nS',     int2str( nS ), ...
		              '_nN',     int2str( nN ),  ...
	                  '_nA',    int2str( nA ), ...
		              '_sigma', num2str( sigma, '%1.2E' ), ...
		              '_nEigs', int2str( nEigs ), ...
                      '_embed.log' ];

    logfileLaplacian = [ 'dataPsi/dataPsi', ...
                          '_nS',     int2str( nS ), ...fig
		                  '_nN',     int2str( nN ),  ...
	                      '_nA',    int2str( nA ), ...
			              '_sigma', num2str( sigma, '%1.2E' ), ...
		                  '_nEigs', int2str( nEigs ), ...
		                  '_laplacian.log' ];

    
    fileNameDist = [ 'dataY/dataY', ...
                         '_nS',    int2str( nS ), ...
                         '_nN',    int2str( nN ),  ...
                         '_sym.mat' ];
    if nA > 0

        fileNameTune = [ 'dataYA/dataYA', ...
                         '_nS', int2str( nS ), ...
                         '_nN',    int2str( nNA ),  ...
                         '_nA',    int2str( nA ), ...
                         '.mat' ];
        load( fileNameTune, 'yA' );
        yA = sqrt( yA );

        [ lambda, v ] = sembedding_autotune( fileNameDist, nS, ... 
                         'sigma', yA, ...
                         'alpha', alpha, ...
                         'nEigs', nEigs, ...
		        		 'laplacianLogfile', logfileLaplacian, ...
					     'logfile', logfileEmbed );
    else


        [ lambda, v ] = sembedding( fileNameDist, nS, ... 
                                    'sigma', sigma, ...
                                    'alpha', alpha, ...
                                    'nEigs', nEigs );

    end

    psi = v( 1 : end, 2 : nEigs + 1 ) ...
        ./ repmat( v( 1 : end, 1 ), 1, nEigs );
    
    %$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
    % the Riemannian measure. 
    mu = v( 1 : end, 1 ) ;
    mu = mu.*mu; % note: sum(mu)=1
    %$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
    
    fileName = [ 'dataPsi/dataPsi', ...
                 '_nS',    int2str( nS ), ...
                 '_nN',    int2str( nN ),  ...
                 '_nA',    int2str( nA ), ...
                 '_sigma', num2str( sigma, '%1.2E' ), ...
                 '_nEigs', int2str( nEigs ), '.mat' ];
    save( fileName, 'psi', 'lambda' , 'mu' );

end

%EOF