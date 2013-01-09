classdef TSettings
    properties (Access = public)
        % General scanned stack parameters
        Resolution; % um/pixel
        Anisotropy; % scaling
        InvAnisotropy; %inverse scaling
        
        % Prior distributions
        CellRadiusPrior;
        CellBorderCurveturePrior;        
    end
    
    methods (Access = public)
        function obj = TSettings()
            obj.Resolution = [110/512, 110/512, 1]';
            obj.Anisotropy = [1, 1, obj.Resolution(1)/obj.Resolution(3)]';
            obj.InvAnisotropy = 1./obj.Anisotropy;
        end
    end
end