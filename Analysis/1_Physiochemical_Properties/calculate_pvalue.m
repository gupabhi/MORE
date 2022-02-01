%  this function calculate functions as follows:-
% 1) fit gaussian to data and calculate sigma (let's call it actual sigma)
% 2) shuffle data n (ntrials) number of times and then for each shuffled
% data calculate the sigma
% 3) At last, check number of times shuffled sigma < actual sigma -- p-val
% = number of times condition is true/ total number of trials

function [p, actualSigma, actualFit] = calculate_pvalue(x, y, ntrials)

rng(0); % initialize random number generator
idx = ~isnan(y); x = x(idx); y = y(idx); % remove NaNs

try
    actualFit = fit(x,y,'gauss1'); % fit gaussian
    actualSigma = actualFit.c1;     % get sigma of the fitted gaussian

    % fit gaussian and get sigma for n number of trials
    count = 0;
    for i = 1:ntrials
        shuffledY = y(randperm(numel(y)));
        shuffledF = fit(x,shuffledY,'gauss1'); % fit gaussian
        shuffledSigma = shuffledF.c1;

        if shuffledSigma <= actualSigma
           count = count  + 1; 
        end
    end

    % calculate p-value
    p = count/ntrials;  % probabaility that standard devition of random distribution is less
                        % than the actual standard deviation

catch Me
     fprintf(1,'Error: %s\n',Me.message);
     p = NaN;
end
    
end

