function plot_actual_shuffle_gaussian_fit(x, y, ntrials, species, prop, output_folder)

rng(0); % initialize random number generator
idx = ~isnan(y); x = x(idx); y = y(idx); % remove NaNs

trialsToPlot = datasample(1:ntrials, 5);
try
    f = fit(x,y,'gauss1'); % fit gaussian
    actualSigma = f.c1;     % get sigma of the fitted gaussian

    ttl = sprintf('[species=%s; n=%d; sigma=%s]', species, size(x,1),...
        sprintf('%0.2e',actualSigma)); 
    xlbl = prop; ylbl = 'Odorant Receptor Response (spikes/s)'; 
    savename = sprintf('scatter_resp_%s_%s_actual', species, prop);

    plot_scatter(x, y, f, ttl, xlbl, ylbl, savename, output_folder)
    
    % fit gaussian and get sigma for n number of trials
    count = 0;
    for i = 1:ntrials
        shuffledY = y(randperm(numel(y)));
        shuffledF = fit(x,shuffledY,'gauss1'); % fit gaussian
        shuffledSigma = shuffledF.c1;

        if shuffledSigma <= actualSigma
           count = count  + 1; 
        end
        
        if any(trialsToPlot == i)
            ttl = sprintf('[species=%s; n=%d; sigma=%s; trial=%d]', species, size(x,1),...
                sprintf('%0.2e',shuffledSigma), i); 
            xlbl = prop; ylbl = 'Odorant Receptor Response (spikes/s)'; 
            savename = sprintf('scatter_resp_%s_%s_trial%d', species, prop, i);

            plot_scatter(x, shuffledY, shuffledF, ttl, xlbl, ylbl, savename, output_folder)
        end
    end

    % calculate p-value
    p = count/ntrials;  % probabaility that standard devition of random distribution is less
                        than the actual standard deviation

catch Me
     fprintf(1,'Error: %s\n',Me.message);
     p = NaN;
end

end

