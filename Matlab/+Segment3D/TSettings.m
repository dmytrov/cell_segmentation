classdef TSettings
    properties (Access = public)
        IsDebug;
        
        % General scanned stack parameters
        Resolution; % um/pixel
        Anisotropy; % scaling
        InvAnisotropy; %inverse scaling
        
        ConvergenceBlurVariance; % vector, pixels, to remove some photon noise and smooth the stack
        ConvergenceKernelVariance; % vector, micron
        ConvergenceVolumeThresold; % pixels
        
        % Ray parameters
        RayRadius;          % micron
        RayStep;            % micron
        RayKernelVariance;  % micron
        
        % Prior distributions
        RadiusPrior;            % radius, micron
        ConvexityPrior;         % local border roughness, convexity
        BoundaryIntensityPrior; % relative to max/conter of the cell
        IsosurfacePrior;        % relative to mean lateral boundary intensity
    end
    
    methods (Access = public)
        %------------------------------------------------------------------
        % Constructor
        
        function obj = TSettings()
            obj.IsDebug = 1;
            
            radius = 6.5; % typical cell raduis, micron
            
            obj.Resolution = [110/512, 110/512, 1]';
            obj.Anisotropy = [1, 1, obj.Resolution(1)/obj.Resolution(3)]';
            obj.InvAnisotropy = 1./obj.Anisotropy;
            
            obj.ConvergenceBlurVariance = [2, 2, 0.1]';
            obj.ConvergenceKernelVariance = [radius, radius, radius]' / 3.5;
            obj.ConvergenceVolumeThresold = 16;
            
            obj.RayRadius = 1.5 * radius;
            obj.RayStep = obj.PixToMicronXY(1)/4; % micron; 4 steps per pixel
            obj.RayKernelVariance = 1; % micron
            
            % Priors
            obj.RadiusPrior = ...
                Bayesian.TGaussianPrior(radius, 0.3 * radius);
            obj.ConvexityPrior = ...
                Bayesian.TGaussianPrior(radius, 0.05 * radius);
            obj.BoundaryIntensityPrior = ...
                Bayesian.TGaussianPrior(0.2, 0.1);
            obj.IsosurfacePrior = ...
                Bayesian.TGaussianPrior(1, 0.1);
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