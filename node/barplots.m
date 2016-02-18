function [] = barplots(weights)

    outgoing = (sum(weights, 1))'; %sum outgoing strength along columns
    incoming = sum(weights, 2); %sum incoming strength along rows

%combined = [incoming, outgoing]; %concatenate arrays for combined bar plot
    
    %set negative strengths to zero
    for i=1:numel(outgoing)
       if (outgoing(i)<0)
          outgoing(i)=0; 
       end
    end
    
    %set negative strengths to zero
    for i=1:numel(incoming)
       if (incoming(i)<0)
          incoming(i)=0; 
       end
    end

    %plot the bar graph with titles and axes labels
    figure;
    bar(incoming,'blue');  
    title('Incoming Node Strength');
    ylabel('Beta-weight');
    xlabel('Channels/Nodes');
    
    figure;
    bar(outgoing,'red');
    title('Outgoing Node Strength');
    ylabel('Beta-weight');
    xlabel('Channels/Nodes');

    
%set up the legend and axes for combined plot
%     h = bar(combined); 
%     
%     grid on
%     l = cell(1,2);
%     l{1}='Incoming'; l{2}='Outgoing';    
%     legend(h,l);
%     
%     ylabel('beta-weight');
%     
end


