settings;
size_dt = 0:1/fs:5*info_size_f;

direccion = [0 1 0 0];
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
