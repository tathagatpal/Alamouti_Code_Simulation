f = 900*10^6;
lambda = 3*10^8/f;
R = -1;
h_t = 50; h_r = 2;
G_l = 1;
d = 1:1:100000;
G_r = [1 0.316 0.1 0.01];
x_l = sqrt((h_t+h_r)^2 + d.^2) - sqrt((h_t-h_r)^2+d.^2);
phi = 2*pi*x_l/(lambda);
theta = d./(h_t-h_r);
f_d = 40*cos(theta/lambda);

lambda = 3*10^-8./f_d;

d_axis = log10(d);
P_t = 1;

for i = 1:4
P_r = P_t*(lambda./(4*pi)).^2.* abs(sqrt(G_l)./sqrt((h_t-h_r)^2+d.^2)...
    + R*sqrt(G_r(i))*exp(-1j*phi)./(sqrt((h_t+h_r)^2 + d.^2)));

P_r = P_r/P_r(1);

d_c = 4*h_t*h_r./lambda;
d_c = log10(d_c);
p_d_c = ones(1,length(d_c)).*d_c;

figure(i);
plot(d_axis, 10*log10(P_r),'b','linewidth',2);
hold on;
grid on;
title("G_r = " + G_r(i));
% xline(d_c,'k--','linewidth',1.5); 
xline(log10(h_t),'m--','linewidth',1.5)
legend('Two-ray model power falloff', 'Critical distance (d_c)',...
    'Height of Transmitter');
xlabel('log_1_0(d)'); ylabel('Received Power (dB)');

end

%As the receiver gain decreases, the power is proportional to the distance
%squared and hence the nature between h_t and d_c becomes more linear. 
%For small distances, the rays add constructively and path loss is
%slowly increasing. For distances > h_t, upto critical distance d_c, the
%signal experiences constructive as well as destructive itnerference of the
%two rays and thus oscillates. For d > d_c, the signal is a result of
%destructive interference and hence the rapid falloff.

