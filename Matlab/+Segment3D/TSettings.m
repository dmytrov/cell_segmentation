% History:
%   Dmytro Velychko - created. Euler AG, CIN, Tuebingen, 2012-2013
%   mailto:dmytro.velychko@student.uni-tuebingen.de

classdef TSettings
    properties (Access = public)
        IsDebug;
        
        % General scanned stack parameters
        Resolution; % um/pixel
        Anisotropy; % scaling
        InvAnisotropy; %inverse scaling
        
        % Convergence parameters
        ConvergenceBlurVariance; % vector, pixels, to remove some photon noise and smooth the stack
        ConvergenceKernelVariance; % vector, micron
        
        % Classification criteria (rough)
        CellMinPixVolumeRough; % pixels, rough estimation
        CellMaxPixVolumeRough; % pixels, rough estimation
        CellMaxZAxisAngleRough; % cos of 1-st principal component and Z-axis
        
        % Classification criteria (fine)
        CellMinPixVolumeFine;  % pixels, fine estimation
        CellMaxPixVolumeFine;  % pixels, fine estimation
        CellMaxZAxisAngleFine; % cos of 1-st principal component and Z-axis
        CellMaxElongation;     % max/min principal components ratio 
        CellVolumeToBoundingVolumeRatio;
        CellMaxDistanceToCellPlane;        
        
        TesselationLevel;   % number of subdivision for tesselation. Each subdivision increases number of faces 4 times
        
        % Ray parameters
        RayRadius;          % micron
        RayStep;            % micron
        RayKernelVariance;  % micron
        
        BoundaryEstimationIterations;
        
        % Prior distributions
        RadiusPrior;            % radius, micron
        
        % THESE ARE NOT IMPLEMENTED YET
        %ConvexityPrior;         % local border roughness, convexity
        %BoundaryIntensityPrior; % relative to max/conter of the cell
        %IsosurfacePrior;        % relative to mean lateral boundary intensity
    end
    
    methods (Access = public)
        %------------------------------------------------------------------
        % Constructor
        
        function obj = TSettings()
            obj.IsDebug = 0;
            
            % Main parameter of the segmentation
            radius = 6.5; % typical cell raduis, micron
            
            obj.Resolution = [110/512, 110/512, 1]';
            obj.Anisotropy = [1, 1, obj.Resolution(1)/obj.Resolution(3)]';
            obj.InvAnisotropy = 1./obj.Anisotropy;
            
            obj.ConvergenceBlurVariance = [2, 2, 0.1]';
            obj.ConvergenceKernelVariance = [radius, radius, radius]' / 3.5;
            
            % Lots of magic munbers because they are parametrised by radius
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
            
            obj.TesselationLevel = 1;
            
            obj.RayRadius = 1.5 * radius;
            obj.RayStep = obj.PixToMicronXY(1)/4; % micron; 4 steps per pixel
            obj.RayKernelVariance = 1; % micron
            
            obj.BoundaryEstimationIterations = 3;
            
            % Priors
            obj.RadiusPrior = ...
                Bayesian.TGaussianPrior(radius, 0.3 * radius);
            % THESE ARE NOT IMPLEMENTED YET
            % obj.ConvexityPrior = ...
            %     Bayesian.TGaussianPrior(radius, 0.05 * radius);
            % obj.BoundaryIntensityPrior = ...
            %     Bayesian.TGaussianPrior(0.2, 0.1);
            % obj.IsosurfacePrior = ...
            %     Bayesian.TGaussianPrior(1, 0.1);
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