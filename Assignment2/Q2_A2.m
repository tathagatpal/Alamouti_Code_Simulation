%Simulation window parameters
r = [1 10 20 30 40 50 60 70 80 90 100] ; %radius of disk

ht = 30;        %height of BS
hr = 3;         %height of receiver


fc = 900; %freq = 900 MHz

P_r_avg1 = zeros(1,length(r));
SNR_avg1 = zeros(1,length(r));

%% PPP
for i = 1:length(r)
xx0=0; yy0=0; %centre of disk
areaTotal=pi*r(i)^2; %area of disk

lambda=2; %density 
%Simulate Poisson point process
numbPoints=poissrnd(areaTotal*lambda);%Poisson number of points
theta=2*pi*(rand(numbPoints,1)); %angular coordinates
rho=r(i)*sqrt(rand(numbPoints,1)); %radial coordinates

%Convert from polar to Cartesian coordinates
[xx,yy]=pol2cart(theta,rho); %x/y coordinates of Poisson points
%Shift centre of disk to (xx0,yy0)

xx=xx+xx0;
yy=yy+yy0;

%% Urban PL
a_hr_f = (3.2*(log10(11.75*hr))^2 - 4.97);
C = 3;      %urban region

PL = [];
for ind = 1:length(xx)
    d = sqrt((xx(i)-xx0)^2 + (yy(i)-yy0)^2)/1000;
    PL = [PL 46.3 + 33.9*log10(fc) - 13.82*log10(ht) - a_hr_f + ...
        (44.9 - 6.55*log10(ht))*log10(d) + C];
end

Pt_1 = 0*ones(1,length(PL));       %dBW (transmit power = 1W)
Pt_2 = 6.9897*ones(1,length(PL));  %5W

Pr1 = Pt_1 - PL;
P_r_avg1(i) = mean(Pr1);

Pr2 = Pt_2 - PL;
P_r_avg2(i) = mean(Pr2);

%% SNR
N0 = -204; %dBW

SNR1 = Pr1 - N0;
SNR_avg1(i) = mean(SNR1);

SNR2 = Pr2 - N0;
SNR_avg2(i) = mean(SNR2);

%% UE Plots 
figure(i)
plot(xx,yy,'o');
hold on;
title("r = " + r(i) + " m");
xlabel('x'); ylabel('y');
axis square;
grid on;

end

%% P_r and SNR plots
figure('DefaultAxesFontSize',20);
plot(r, P_r_avg1,'linewidth',2);
hold on;
title("Received Power v/s radius size, P_t = 1W");
xlabel("Radius (m)"); ylabel("Power(dBW)");
grid on;

figure('DefaultAxesFontSize',20);
plot(r, (SNR_avg1),'linewidth',2);
hold on;
title("SNR v/s radius size, P_t = 1W" );
xlabel("Radius (m)"); ylabel("SNR");
grid on;

figure('DefaultAxesFontSize',20);
plot(r, P_r_avg2,'linewidth',2);
hold on;
title("Received Power v/s radius size, P_t = 5W");
xlabel("Radius (m)"); ylabel("Power(dBW)");
grid on;

figure('DefaultAxesFontSize',20);
plot(r, (SNR_avg2),'linewidth',2);
hold on;
title("SNR v/s radius size, P_t = 5W" );
xlabel("Radius (m)"); ylabel("SNR");
grid on;


%% Observations:
% It is very clear from the plots that as the radius size increases, the
% path loss and the SNR (averaged over UEs) decreases. When the transmit
% power is increased from 1W to 5W, the received power increases by around
% 6.9897 dBW. Similarly, the SNR also increases when the transmit power is
% increased to 5W. 

%references:
% for PPP: https://in.mathworks.com/matlabcentral/answers/300022-i-want-to-spatially-distribute-1000-mobile-devices-in-a-network-according-to-poisson-point-process
% for Urban PL: L. M. Correia, "A view of the COST 231-Bertoni-Ikegami model," 2009 3rd European Conference on Antennas and Propagation, Berlin, 2009, pp. 1681-1685.

