% History:
%   Dmytro Velychko - created. Euler AG, CIN, Tuebingen, 2012-2013
%   mailto:dmytro.velychko@student.uni-tuebingen.de

classdef TSettings < handle
    properties (Constant = true)
        RETINAL     = 0;
        CORTICAL    = 1;
    end
    
    properties (Access = public)
        IsDebug;
        
        % General scanned stack parameters
        ScanType;   % RETINAL or CORTICAL
        Resolution; % um/pixel
        Anisotropy; % scaling
        InvAnisotropy; %inverse scaling
        
        % Convergence parameters
        ConvergenceBlurVariance; % vector, pixels, to remove some photon noise and smooth the stack
        ConvergenceKernelVariance; % vector, micron
        ConvergenceThreshold; % [0-1], fraction of maxConvergenceValue
        
        % Classification criteria  for retinal scan (rough)
        CellMinPixVolumeRough; % pixels, rough estimation
        CellMaxPixVolumeRough; % pixels, rough estimation
        CellMaxZAxisAngleRough; % cos of 1-st principal component and Z-axis
        
        % Classification criteria for retinal scan (fine)
        CellMinPixVolumeFine;  % pixels, fine estimation
        CellMaxPixVolumeFine;  % pixels, fine estimation
        CellMaxZAxisAngleFine; % cos of 1-st principal component and Z-axis
        CellMaxElongation;     % max/min principal components ratio 
        CellVolumeToBoundingVolumeRatio;
        CellMaxDistanceToCellPlane;        
        
        % Classification criteria for cortiacal scan
        
        TesselationLevel;   % number of subdivision for tesselation. Each subdivision increases number of faces 4 times
        
        % Ray parameters for final cell model estimations
        RayRadius;          % micron
        RayStep;            % micron
        RayKernelVariance;  % micron
        
        % Priors and parameters for final cell model estimations
        BoundaryEstimationIterations;
        RadiusPrior;            % radius, micron
        CurvaturePrior;         % distance from plane formed by surrounding vertices, micron
        
        % THESE ARE NOT IMPLEMENTED YET
        %BoundaryIntensityPrior; % relative to max/conter of the cell
        %IsosurfacePrior;        % relative to mean lateral boundary intensity
        
        FrameRate; % functional scan aquisition frame rate
        
        % Other parameters
        EnableFunctionalStackAlignment;
        EnableMorphologyStackAlignment;
    end
    
    methods (Access = public)
        %------------------------------------------------------------------
        % Constructor
        
        function obj = TSettings()
            obj.InitForRetinalScan()
        end
        
        function InitForRetinalScan(obj)
            obj.IsDebug = 0;
            
            % Main parameter of the segmentation
            radius = 6.5; % typical cell raduis, micron
            
            obj.ScanType = obj.RETINAL;            
            obj.Resolution = [110/512, 110/512, 1]';
            obj.Anisotropy = [1, 1, obj.Resolution(1)/obj.Resolution(3)]';
            obj.InvAnisotropy = 1./obj.Anisotropy;
            
            obj.ConvergenceBlurVariance = [2, 2, 0.1]';
            %obj.ConvergenceKernelVariance = [radius, radius, radius]' / 2.5;
            obj.ConvergenceKernelVariance = [radius, radius, radius]' / 3.5;
            obj.ConvergenceThreshold = 0.5;
            
            % Lots of magic numbers because they are parametrised by radius
            pixInCell = prod(radius ./ obj.Resolution);
            obj.CellMinPixVolumeRough = round(0.0336 * pixInCell); 
            obj.CellMaxPixVolumeRough = round(0.6723 * pixInCell); 
            obj.CellMaxZAxisAngleRough = 0.4; % range: [0, 1] - dot prod

            obj.CellMinPixVolumeFine = round(0.0017 * pixInCell);
            obj.CellMaxPixVolumeFine = round(1.6808 * pixInCell);
            obj.CellMaxZAxisAngleFine = 0.9; % range: [0, 1] - dot prod
            obj.CellVolumeToBoundingVolumeRatio = 0.001;
            obj.CellMaxElongation = 5;
            obj.CellMaxDistanceToCellPlane = 1.5 * radius;      
            
            obj.TesselationLevel = 2;
            
            obj.RayRadius = 1.5 * radius;
            obj.RayStep = obj.PixToMicronXY(1)/4; % micron; 4 steps per pixel
            obj.RayKernelVariance = 1; % micron
            
            obj.BoundaryEstimationIterations = 4;
            
            % Priors
            obj.RadiusPrior = ...
                Bayesian.TGaussianPrior(radius, 0.3 * radius);
            obj.CurvaturePrior = ...
                Bayesian.TGaussianPrior(0.1 * radius / obj.TesselationLevel, ...
                                        0.3 * radius / obj.TesselationLevel);
            
            obj.FrameRate = 1000/128;
            
            obj.EnableFunctionalStackAlignment = 1;
            obj.EnableMorphologyStackAlignment = 0;
        end
        
        function InitForCorticalScan(obj)
            obj.IsDebug = 0;
            
            % Main parameter of the segmentation
            radius = 10; % typical cell raduis, micron
            
            obj.ScanType = obj.CORTICAL;            
            obj.Resolution = [200/512, 200/512, 100/375]';
            obj.Anisotropy = [1, 1, obj.Resolution(1)/obj.Resolution(3)]';
            obj.InvAnisotropy = 1./obj.Anisotropy;
            
            obj.ConvergenceBlurVariance = [2, 2, 0.1]';
            obj.ConvergenceKernelVariance = [radius, radius, radius]' / 2.5;
            obj.ConvergenceThreshold = 0.5;
            
            % Lots of magic numbers because they are parametrised by radius
            pixInCell = prod(radius ./ obj.Resolution);            
            obj.CellMinPixVolumeFine = round(0.0336 * pixInCell);
            obj.CellMaxPixVolumeFine = round(0.6723 * pixInCell); 
            obj.CellMaxElongation = 10;
            obj.CellVolumeToBoundingVolumeRatio = 0.05;
            
            obj.TesselationLevel = 2;
            
            obj.RayRadius = 1.5 * radius;
            obj.RayStep = obj.PixToMicronXY(1)/4; % micron; 4 steps per pixel
            obj.RayKernelVariance = 1; % micron
            
            obj.BoundaryEstimationIterations = 4;
            
            % Priors
            obj.RadiusPrior = ...
                Bayesian.TGaussianPrior(radius, 0.3 * radius);
            obj.CurvaturePrior = ...
                Bayesian.TGaussianPrior(0.1 * radius / obj.TesselationLevel, ...
                                        0.3 * radius / obj.TesselationLevel);
            
            obj.FrameRate = 1000/128;
            
            obj.EnableFunctionalStackAlignment = 1;
            obj.EnableMorphologyStackAlignment = 0;
        end
        
        %------------------------------------------------------------------
        % Helper functions
        
        function res = PixToMicron(obj, x)
            res =  bsxfun(@times, x, obj.Resolution); 
        end
        
        function res = MicronToPix(obj, x)
            res =  bsxfun(@times, x, 1./obj.Resolution); 
        end
            
        function res = PixToMicronXY(obj, x)
            scale = obj.Anisotropy(1) * obj.Resolution(1);    
            res = x * scale; 
        end
        
        function res = MicronToPixXY(obj, x)
            scale = 1/(obj.Anisotropy(1) * obj.Resolution(1));    
            res = x * scale;
        end
    end
end