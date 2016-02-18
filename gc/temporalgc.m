%% Figure 28.3 (note: this cell takes a while to run)

% load sample EEG data
clear
close all
clc
load sampleEEGdata
load subject_1

% define channels for granger prediction
chan1name = 'LG1';
chan2name = 'LG2';

% Granger prediction parameters
timewin = 200; % in ms
order   =  15; % in ms

% temporal down-sample results (but not data!)
times2save = -400:20:1000; % in ms


% convert parameters to indices
timewin_points = round(timewin/(1000/ecog.hdr.SampleRate));
order_points   = round(order/(1000/ecog.hdr.SampleRate));

% find the index of those channels
chan1 = find(strcmpi(chan1name,{ecog.hdr.Label}));
chan2 = find(strcmpi(chan2name,{ecog.hdr.Label}));

% remove ERP from selected electrodes to improve stationarity
eegdata = bsxfun(@minus,EEG.data([chan1 chan2],:,:),mean(EEG.data([chan1 chan2],:,:),3));
eegdata = transpose(ecog.data(1:640, 1:2));

% convert requested times to indices
times2saveidx = dsearchn(EEG.times',times2save');

% initialize
[x2y,y2x] = deal(zeros(1,71)); % the function deal assigns inputs to all outputs, length(times2save) = 71
bic = zeros(71,15); % Bayes info criteria (hard-coded to order=15)

for timei=1:71
    
    % data from all trials in this time window
    tempdata = squeeze(eegdata(:,times2saveidx(timei)-floor(timewin_points/2):times2saveidx(timei)+floor(timewin_points/2)-mod(timewin_points+1,2),:));
    
    % detrend and zscore all data
    %for triali=1:size(eegdata)
        tempdata(1,:) = zscore(detrend(squeeze(tempdata(1,:))));
        tempdata(2,:) = zscore(detrend(squeeze(tempdata(2,:))));
        
        % At this point with real data, you should check for stationarity
        % and possibly discard or mark data epochs that are extreme stationary violations.
    %end
    
    % reshape tempdata for armorf
    tempdata = reshape(tempdata,2,timewin_points);
    
    % fit AR models (model estimation from bsmart toolbox)
    [Ax,Ex] = armorf(tempdata(1,:),1,timewin_points,order_points);
    [Ay,Ey] = armorf(tempdata(2,:),1,timewin_points,order_points);
    [Axy,E] = armorf(tempdata     ,1,timewin_points,order_points);
    
    % time-domain causal estimate
    y2x(timei)=log(Ex/E(1,1));
    x2y(timei)=log(Ey/E(2,2));
    
    % test BIC for optimal model order at each time point
    % (this code is used for the following cell)
    for bici=1:size(bic,2)
        % run model
        [Axy,E] = armorf(tempdata,1,timewin_points,bici);
        % compute Bayes Information Criteria
        bic(timei,bici) = log(det(E)) + (log(length(tempdata))*bici*2^2)/length(tempdata);
    end
end

% draw lines
figure
plot(times2save,x2y)
hold on
plot(times2save,y2x,'r')
legend({[ 'GP: ' chan1name ' -> ' chan2name ];[ 'GP: ' chan2name ' -> ' chan1name ]})
title([ 'Window length: ' num2str(timewin) ' ms, order: ' num2str(order) ' ms' ])
xlabel('Time (ms)')
ylabel('Granger prediction estimate')

%% Figure 28.4

% see "bici" for-loop above for code to compute BIC

figure

subplot(121)
plot((1:size(bic,2))*(1000/EEG.srate),mean(bic,1),'--.')
xlabel('Order (converted to ms)')
ylabel('Mean BIC over all time points')

[bestbicVal,bestbicIdx]=min(mean(bic,1));
hold on
plot(bestbicIdx*(1000/EEG.srate),bestbicVal,'mo','markersize',15)

title([ 'Optimal order is ' num2str(bestbicIdx) ' (' num2str(bestbicIdx*(1000/EEG.srate)) ' ms)' ])

subplot(122)
[junk,bic_per_timepoint] = min(bic,[],2);
plot(times2save,bic_per_timepoint*(1000/EEG.srate),'--.')
xlabel('Time (ms)')
ylabel('Optimal order (converted to ms)')
title('Optimal order (in ms) at each time point')
