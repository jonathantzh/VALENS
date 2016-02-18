function [id,od,deg] = degrees_dir(CIJ)

%set threshold for determining degrees of nodes
for i=1:numel(CIJ)
   if (CIJ(i)<0.1)
      CIJ(i)=0; 
   end
end

% ensure CIJ is binary...
CIJ = double(CIJ~=0);

% compute degrees
id = sum(CIJ,1);    % indegree = column sum of CIJ
od = sum(CIJ,2)';   % outdegree = row sum of CIJ
deg = id+od;        % degree = indegree+outdegree

%plot the bar graph with titles and axes labels
figure;
bar(deg,'blue');  
title('Degrees of Nodes/Channels');
ylabel('Number of Degrees');
xlabel('Channels/Nodes');
