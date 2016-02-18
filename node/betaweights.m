function [weights] = betaweights(data, nchannels, timepoints) %channels in columns, %timepoints in rows

    a=hilbert(data); %perform hilbert transform
    a=a./abs(a); %normalise data

    for i=1:nchannels    
        for j=1:nchannels
            y(i,j) = sum(abs(a(:,i)-a(:,j))); 
        end
    end
    a = y./timepoints; %acquire phase locking factor
    a = inv(a);
    
    b = diag(a);
    
    for k=1:nchannels
        for l=1:nchannels
            weights(k,l) = -a(k,l)./b(k); %acquire beta weights
        end
    end
    
    barplots(weights); %plot the bar graph of incoming and outgoing node strengths
end

