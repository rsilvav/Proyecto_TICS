settings;
size_dt = 0:1/fs:15*info_size_f;

div = 2;

direccion = [1 1 1 1];
s_dir = senal_direccion(direccion,size_dt,s1,s2,s3,s4);
r_senal = sin(2*pi*(ttl4)*size_dt)+sin(2*pi*(ttl3)*size_dt)+sin(2*pi*(ttl2)*size_dt)+sin(2*pi*(ttl1)*size_dt);

tf = 2;
soundsc(r_senal+s_dir,fs,16);
recorder = audiorecorder(fs, 16, 1);
recordblocking(recorder, tf);
senal = recorder.getaudiodata;
%======== PLOT FFT
frames_dim = length(senal);
NFFT = 2^nextpow2(frames_dim);
Y = fft(senal, NFFT)/frames_dim;
f = fs/2*linspace(0,1,NFFT/2+1);
a_fft = abs(Y(1:NFFT/2+1));
plot(f, 2*abs(Y(1:NFFT/2+1)));
audiowrite('ttl.wav',r_senal+s_dir,fs);


[c1 i_ttl1] = min(abs(f-ttl1));
[c2 i_ttl2] = min(abs(f-ttl2));
[c3 i_ttl3] = min(abs(f-ttl3));
[c4 i_ttl4] = min(abs(f-ttl4));

[c1 i_d1] = min(abs(f-s1));
[c2 i_d2] = min(abs(f-s2));
[c3 i_d3] = min(abs(f-s3));
[c4 i_d4] = min(abs(f-s4));

power = [a_fft(i_ttl1) a_fft(i_ttl2) a_fft(i_ttl3) a_fft(i_ttl4) a_fft(i_d1) a_fft(i_d2) a_fft(i_d3) a_fft(i_d4)];

amp = min(power);
amp = amp/div;