pskModulator = comm.PSKModulator(2);    %BPSK modulation
input_signal = randi([0,pskModulator.ModulationOrder-1],16,1);
channelInput = pskModulator(input_signal);

%% Delay [0  0] (single path)
rayleigh_channel_sp = comm.RayleighChannel( ...
    'SampleRate',10e6, ...
    'PathDelays',[0 0], ...
    'AveragePathGains',[0 0], ...
    'Visualization','Impulse and frequency responses');

rc_single = rayleigh_channel_sp(channelInput);

%% Delay [0 5e-6]
rayleigh_channel1 = comm.RayleighChannel( ...
    'SampleRate',10e6, ...
    'PathDelays',[0 5e-6], ...
    'AveragePathGains',[0 -3], ...
    'Visualization','Impulse and frequency responses');

rc_5 = rayleigh_channel1(channelInput);
%% Delay [0 10e-6]
rayleigh_channel_2 = comm.RayleighChannel( ...
    'SampleRate',10e6, ...
    'PathDelays',[0 10e-6], ...
    'AveragePathGains',[0 -3], ...
    'Visualization','Impulse and frequency responses');

rc_10 = rayleigh_channel_2(channelInput);


%% Time domain

fc = 10e6; %f_c = 10 MHz
t = 0:1:15;

rc_5_t = zeros(1,length(rc_5));
for i = 1:length(rc_5)
    in_phase = real(rc_5(i));
    quad = imag(rc_5(i));
    carrier = in_phase*cos(2*pi*fc*t(i)) - quad*sin(2*pi*fc*t(i));
    
    rc_5_t(i) =  carrier;
end


rc_single_t = zeros(1,length(rc_single));
for i = 1:length(rc_single)
    in_phase = real(rc_single(i));
    quad = imag(rc_single(i));
    carrier = in_phase*cos(2*pi*fc*t(i)) - quad*sin(2*pi*fc*t(i));
    
    rc_single_t(i) =  carrier;
end


rc_10_t = zeros(1,length(rc_10));
for i = 1:length(rc_10)
    in_phase = real(rc_10(i));
    quad = imag(rc_10(i));
    carrier = in_phase*cos(2*pi*fc*t(i)) - quad*sin(2*pi*fc*t(i));
    
    rc_10_t(i) =  carrier;
end

figure('DefaultAxesFontSize',20);
stairs(t,rc_5_t, 'b','linewidth',2);
hold on;
grid on;
title("Multipath delay [0 5] µs");
xlabel('Time'); ylabel('Amplitude');

figure('DefaultAxesFontSize',20);
stairs(t,rc_single_t,'r', 'linewidth',2);
hold on;
grid on;
title("Single Path");
xlabel('Time'); ylabel('Amplitude');


figure('DefaultAxesFontSize',20);
stairs(t,rc_10_t,'m', 'linewidth',2);
hold on;
grid on;
title("Multipath delay [0 10] µs");
xlabel('Time'); ylabel('Amplitude');

%% Observations:
% i) It is evident from the plots that the maximum attenuation observed 
% is when the time delay is maximum, i.e., [0 10] µs case. Whereas for 
% single path channel, the attenuation observed is the least.
% ii) In the impulse response plots, the impulses are observed at the time 
% instants where there is delay. Hence, for single path, the impulse is
% obtained at t=0. But for multipath with delay = [0 5] µs, the impulses
% can be seen at t = 0 and 5 µs.
% iii) In frequency response plots, the dips in the power is largest for 
% [0 10] µs case. Whereas, for the single path channel, the power is
% constant throught. 

%% References:

%Rayleigh simulator: https://in.mathworks.com/help/comm/ref/comm.rayleighch
%annel-system-object.html

%Modulation and demodulation: https://in.mathworks.com/help/comm/ref/comm.
%pskmodulator-system-object.html

