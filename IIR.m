% Disign a IIR bandpass digital Filter

% Filter specification

wp = [1200 1700];
ws = [900 1900];
Rp = 0.14;
Rs = 58;


% Designing the analog filter

[n,wn] = buttord(wp,ws,Rp,Rs,"s");
[b,a] = butter(n,wn,"s");
filter = tf(b,a);
w_sam = 4600;
t_sam = 2*pi/w_sam;
f_sam = 1/t_sam;


% Analog filter magnitude response
w = linspace(-2200,2200,4400);
h = freqs(b, a, w);
mag = abs(h);

figure(1)
plot(w,mag2db(mag))
title("Magnitude response of the analog filter")
xlabel("Frequency (rad/s)")
ylabel("Magnitude (dB)")
grid minor


% Prewrapping frequencies
wp(1) = 2/t_sam*tan(wp(1)*t_sam/2);
wp(2) = 2/t_sam*tan(wp(2)*t_sam/2);
ws(1) = 2/t_sam*tan(ws(1)*t_sam/2);
ws(2) = 2/t_sam*tan(ws(2)*t_sam/2);


% Frequancy Normalizing
wp = [wp(1)/(w_sam/2) wp(2)/(w_sam/2)];
ws = [ws(1)/(w_sam/2) ws(2)/(w_sam/2)];

% Transforming to a Digital filter
[n,wc] = buttord(wp,ws,Rp,Rs,'s');
disp(n)
[z,p,k] = buttap(n);
[A,B,C,D] = zp2ss(z,p,k);
[At,Bt,Ct,Dt] = lp2bp(A,B,C,D,sqrt(wp(1)*wp(2)),wp(2)-wp(1));

w=linspace(-2200/(w_sam/2),2200/(w_sam/2),4400);
[Ad,Bd,Cd,Dd] = bilinear(At,Bt,Ct,Dt,1/pi); % Bilinear Transformation here
filter = ss2sos(Ad,Bd,Cd,Dd);
[b,a] = sos2tf(filter);

filter = tf(b,a); % Coefficients of the transfer function
[num,den] = tfdata(filter);
num
den
fvtool(b,a);
filtord(b,a)
[hd,f] = freqz(b,a,w,2);


% Digital filter magnitude response
magn = abs(hd);
wp=[1200/(w_sam/2) 1700/(w_sam/2)]; 
ws=[900/(w_sam/2) 1900/(w_sam/2)];
figure(2)

plot(w,mag2db(magn))
title("Magnitude response of the digital filter")
xlabel("Frequency (rad/sample)")
ylabel("Magnitude (dB)")
grid minor


% Magnitude response of the passband

figure(3)
plot(w,mag2db(magn))
axis ([ 0.5 , 0.8 , -0.1 , 0.1]);
title("Magnitude response of the passband")
xlabel("Frequency (rad/sample)")
ylabel("Magnitude (dB)")
grid("minor")
