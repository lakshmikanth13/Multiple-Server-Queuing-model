clear all
close all
clc

lambda=input('The arrival rate for this system per minute is: ');
mu=input('What is the service rate of the system per minute?:');
ser=input('How many servers are there in this system?:'); %this represents number of servers in the system.
num=1000; % this represents the population.

%Initializing the arrival,queue and departure times.
arrivaltime=zeros(1,num);
queuetime=zeros(1,num);
departuretime=zeros(1,num);

interarrivaltimes=exprnd(lambda,1,num);

servicetime=exprnd(mu,1,num);
for c=2:ser
    servicetime=[servicetime;exprnd(mu,1,num)];
end
%finding the arrivaltimes of the population
arrivaltime(1)=interarrivaltimes(1);
for t=2:num
    arrivaltime(t)=arrivaltime(t-1)+interarrivaltimes(t);
end
%This represents the index number for the servers.
index=zeros(1,ser);
index(1)=1;
recsernum=ones(1,ser);   % this represents to record the customers who ever leaves.
%queuetime(1)=0;   %As we know at the initial times the queue will be empty.
departuretime(1)=queuetime(1)+servicetime(1,1);
leav=0;
leavpos=0;
%This represents calculation of the queuetimes and the departure times when
%customers are less than number of servers.
for c=1:ser
    queuetime(c)=arrivaltime(c);
    departuretime(c)=queuetime(c)+servicetime(c,recsernum(1));
    recsernum(c)=recsernum(c)+1;
    index(c)=c;
end
minimumtime=0;
minimumtime(1,1)=departuretime(index(1));
for i=2:ser
        minimumtime=[minimumtime;departuretime(index(i))];
end
minimumtime=minimumtime.';

% This loop is to find the queuetime,departure times of the system when
% customers are greater than the servers.
for c=(ser+1):num
    
    [leav, leavpos]=min(minimumtime); % this records the time where the customer leaves which tells that the server is empty.

    if arrivaltime(c)>leav
        queuetime(c)=arrivaltime(c);
    else
        last=index(leavpos);
        queuetime(c)=servicetime(last);
    end
    departuretime(c)=queuetime(c)+servicetime(leavpos,recsernum(leavpos));
    recsernum(leavpos)=recsernum(leavpos)+1;
    index(leavpos)=c;
end

lenat = zeros(num,2);
lendt = zeros(num,2);

%Here we are noting the arrivaltimes and the departure times of the
%customers and taking 1 when an arrival happens and -1 when a departure
%happens.
for i = 1:num
    lenat(i,1) = arrivaltime(1,i);
    lenat(i,2) = 1;
    
    lendt(i,1) = departuretime(1,i);
    lendt(i,2) = -1;
    
end

length=[lenat;lendt];
length=sortrows(length,1);%sorting because the next arrival happens when the service in any of the servers is done.
lengthfin=zeros(size(length,1),1);%the length final represents the length of the queue at the respective time stamps.
for c=2:size(length,1)
    if length(c,2)>0
        lengthfin(c,1)=lengthfin(c-1,1) + 1;
    else 
        if lengthfin(c-1,1)>0
            lengthfin(c,1)=lengthfin(c-1,1)-1;
        else
            lengthfin(c,1)=0;
        end
    end
end
figure,plot(queuetime);% represents the waitimg time as the customers keeps joining.
avgwaitinqueue=mean(queuetime);
fprintf('\n The average waiting time for the customer in the queue is: %f \n' ,avgwaitinqueue);
t=1:size(length,1);
figure,plot(t,lengthfin);title('length of queue wrt time');xlabel('time');ylabel('queuelength');
averagequeuelength=mean(lengthfin);
fprintf('The average length of queue in the system at any time is : %f \n' ,averagequeuelength);
avgtimeinsys=mean(departuretime-arrivaltime);
fprintf('The average time spent by a customer in the system is : %f \n' ,avgtimeinsys);

