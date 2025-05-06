classdef MultiheadAttentionLayer < nnet.layer.Layer
    % MultiheadAttentionLayer   Custom multi-head attention layer for sequences
    % This file contains the baseline for a multihead attention layer as
    % described in the following research articles:
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % MA-VAE: Multi-head Attention-based Variational Autoencoder Approach for 
    % Anomaly Detection in Multivariate Time-series Applied 
    % to Automotive Endurance Powertrain Testing

    properties (Learnable)
        Wq   % Query projection weights
        Wk   % Key projection weights
        Wv   % Value projection weights
        Wo   % Output projection weights
    end

    properties
        NumHeads
        HeadDim
    end

    methods
        function layer = MultiheadAttentionLayer(name, numHeads, headDim, inputDim)
            % Constructor
            layer.Name = name;
            layer.NumHeads = numHeads;
            layer.HeadDim = headDim;
            outputDim = numHeads * headDim;

            % Initialize learnable parameters
            layer.Wq = randn(inputDim, outputDim, 'single') * sqrt(2 / inputDim);
            layer.Wk = randn(inputDim, outputDim, 'single') * sqrt(2 / inputDim);
            layer.Wv = randn(inputDim, outputDim, 'single') * sqrt(2 / inputDim);
            layer.Wo = randn(outputDim, inputDim, 'single') * sqrt(2 / outputDim);
        end

        function Z = predict(layer, X)
            % X: [timeSteps x inputDim x batchSize]
            [T, D, N] = size(X);
            H = layer.NumHeads;
            d = layer.HeadDim;

            % Project input to Q, K, V
            Q = pagemtimes(X, layer.Wq); % [T x H*d x N]
            K = pagemtimes(X, layer.Wk);
            V = pagemtimes(X, layer.Wv);

            % Reshape for multi-head split: [T x H x d x N]
            Q = reshape(Q, T, H, d, N);
            K = reshape(K, T, H, d, N);
            V = reshape(V, T, H, d, N);

            % Transpose for matrix multiplication: [H x N x d x T]
            QT = permute(Q, [2, 4, 3, 1]); % [H x N x d x T]
            KT = permute(K, [2, 4, 3, 1]);
            VT = permute(V, [2, 4, 3, 1]);

            % Compute attention scores: Q x K^T / sqrt(d)
            scores = pagemtimes(QT, 'none', KT, 'transpose') / sqrt(d); % [H x N x T x T]
            weights = softmax(scores, 4);

            % Apply attention to V
            context = pagemtimes(weights, VT); % [H x N x T x d]
            context = permute(context, [3, 1, 4, 2]); % [T x H x d x N]

            % Concatenate heads: [T x H*d x N]
            context = reshape(context, T, H*d, N);

            % Final projection: [T x inputDim x N]
            Z = pagemtimes(context, layer.Wo);
        end
    end
end
