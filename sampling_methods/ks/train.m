% Solve an Input-Output Fitting problem with a Neural Network
% Script generated by Neural Fitting app
% Created 12-Jan-2022 15:15:33
%
% This script assumes these variables are defined:
%
%   train_des - input data.
%   train_tar - target data.

train_des = load("train_des.csv")
train_tar = load("train_tar.csv")
x = train_des';
t = train_tar';

% Choose a Training Function
% For a list of all training functions type: help nntrain
% 'trainlm' is usually fastest.
% 'trainbr' takes longer but may be better for challenging problems.
% 'trainscg' uses less memory. Suitable in low memory situations.
trainFcn = 'trainbr';  % Bayesian Regularization backpropagation.

% Create a Fitting Network
hiddenLayerSize = 5;
net = fitnet(hiddenLayerSize,trainFcn);

% Choose Input and Output Pre/Post-Processing Functions
% For a list of all processing functions type: help nnprocess
net.input.processFcns = {'removeconstantrows','mapminmax'};
net.output.processFcns = {'removeconstantrows','mapminmax'};

% Setup Division of Data for Training, Validation, Testing
% For a list of all data division functions type: help nndivision
net.divideFcn = 'dividerand';  % Divide data randomly
net.divideMode = 'sample';  % Divide up every sample
net.divideParam.trainRatio = 100/100;
net.divideParam.valRatio = 0/100;
net.divideParam.testRatio = 0/100;

% Choose a Performance Function
% For a list of all performance functions type: help nnperformance
net.performFcn = 'mse';  % Mean Squared Error

% Choose Plot Functions
% For a list of all plot functions type: help nnplot
net.plotFcns = {'plotperform','plottrainstate','ploterrhist', ...
    'plotregression', 'plotfit'};

% Train the Network
[net,tr] = train(net,x,t);

% Test the Network
y = net(x);
e = gsubtract(t,y);
performance = perform(net,t,y)

% Recalculate Training, Validation and Test Performance
% trainTargets = t .* tr.trainMask{1};
% valTargets = t .* tr.valMask{1};
% testTargets = t .* tr.testMask{1};
% trainPerformance = perform(net,trainTargets,y)
% valPerformance = perform(net,valTargets,y)
% testPerformance = perform(net,testTargets,y)

% View the Network
% view(net)

% Plots
% Uncomment these lines to enable various plots.
%figure, plotperform(tr)
%figure, plottrainstate(tr)
%figure, ploterrhist(e)
%figure, plotregression(t,y)
%figure, plotfit(net,x,t)

% Deployment
% Change the (false) values to (true) to enable the following code blocks.
% % See the help for each generation function for more information.
% if (false)
%     % Generate MATLAB function for neural network for application
%     % deployment in MATLAB scripts or with MATLAB Compiler and Builder
%     % tools, or simply to examine the calculations your trained neural
%     % network performs.
%     genFunction(net,'myNeuralNetworkFunction');
%     y = myNeuralNetworkFunction(x);
% end
% if (false)
%     % Generate a matrix-only MATLAB function for neural network code
%     % generation with MATLAB Coder tools.
%     genFunction(net,'myNeuralNetworkFunction','MatrixOnly','yes');
%     y = myNeuralNetworkFunction(x);
% end
% if (false)
%     % Generate a Simulink diagram for simulation or deployment with.
%     % Simulink Coder tools.
%     gensim(net);
% end

test_x = load("test_des.csv")
pred_test = net(test_x')
dlmwrite("test_results.csv", pred_test)
pred_train = net(x)
dlmwrite("train_results.csv", pred_train)