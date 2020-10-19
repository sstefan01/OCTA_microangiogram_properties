classdef dicePixelClassification3dLayer < nnet.layer.ClassificationLayer
    % This layer implements the generalized dice loss function for training
    % semantic segmentation networks.
    
    % References
    % ----------
    % Sudre, Carole H., et al. "Generalised Dice overlap as a deep learning
    % loss function for highly unbalanced segmentations." Deep Learning in
    % Medical Image Analysis and Multimodal Learning for Clinical Decision
    % Support. Springer, Cham, 2017. 240-248.
    %
    % Copyright 2018 The MathWorks, Inc.
    
    properties(Constant)
        % Small constant to prevent division by zero. 
        Epsilon = 1e-8;
    end
    
    methods
        
        function layer = dicePixelClassification3dLayer(name)
            % layer =  dicePixelClassification3dLayer(name) creates a Dice
            % pixel classification layer with the specified name.
            
            % Set layer name.          
            layer.Name = name;
            
            % Set layer description.
            layer.Description = 'Dice loss';
        end
        
        
        function loss = forwardLoss(layer, Y, T)
            % loss = forwardLoss(layer, Y, T) returns the Dice loss between
            % the predictions Y and the training targets T.   

            % Weights by inverse of region size.
            W = 1./ max(eps,sum(sum(sum(T,1),2),3).^2);
            
            % over spatial dimensions 1,2,3
            intersection = sum(sum(sum(Y.*T,1),2),3);
            union = sum(sum(sum(Y.^2 + T.^2, 1),2),3);          
            
            %over channels dim (4) :-  representing classes
            numer = 2*sum(W.*intersection,4) + layer.Epsilon;
            denom = sum(W.*union,4) + layer.Epsilon;
            
%             numer = 2*sum(intersection,4) + layer.Epsilon;
%             denom = sum(union,4) + layer.Epsilon;
            % Compute Dice score.
            dice = numer./denom;
            % Return average Dice loss over minibatch (5th dim).
            N = size(Y,5);
           loss = sum((1-dice))/N;

            
            
           
            
        end
        
        function dLdY = backwardLoss(layer, Y, T)
            % dLdY = backwardLoss(layer, Y, T) returns the derivatives of
            % the Dice loss with respect to the predictions Y.
            
            % Weights by inverse of region size.
           W = 1./ max(eps,sum(sum(sum(T,1),2),3).^2);
%             
            intersection = sum(sum(sum(Y.*T,1),2),3);
            union = sum(sum(sum(Y.^2 + T.^2, 1),2),3);
     
            numer = 2*sum(W.*intersection,4) + layer.Epsilon;
            denom = sum(W.*union,4) + layer.Epsilon;
            
            N = size(Y,5);
      
            dLdY = (2*W.*Y.*numer./denom.^2 - 2*W.*T./denom)./N;
              
%             intersection = sum(sum(sum(Y.*T,1),2),3);
%              union = sum(sum(sum(Y.^2 + T.^2, 1),2),3);
%             
%                 num =  T.*union - 2*Y.*intersection;
%                 denom = union.^2;
%                 
%                 dLdY = 2*num./denom;
           
        end
    end
end
