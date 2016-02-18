function [weights] = pbetaweights(data, nchannels) %channels in columns, %timepoints in rows

    a=corr(data); %acquire pearson correlation matrix

    a = inv(a);
    
    b = diag(a);
    
    for k=1:nchannels
        for l=1:nchannels
            weights(k,l) = -a(k,l)./b(k); %acquire beta weights
        end
    end
    
    barplots(weights); %plot the bar graph of incoming and outgoing node strengths
end

