close all
clear
clc
settings;
while true
    %===== Grabar
    tf = 2; % duracion de la grabacion (segs)
    recorder = audiorecorder(fs, 16, 1);
    %set(recorder,'TimerPeriod',1,'TimerFcn',{@audioTimer});
    recordblocking(recorder, tf);
    senal = recorder.getaudiodata;
    %======== PLOT FFT
    frames_dim = length(senal);
    NFFT = 2^nextpow2(frames_dim);
    Y = fft(senal, NFFT)/frames_dim;
    f = fs/2*linspace(0,1,NFFT/2+1);
    a_fft = abs(Y(1:NFFT/2+1));
    ttl = 0;
    i_ttl1 = find(abs(f-ttl1)<0.15);
    i_ttl2 = find(abs(f-ttl2)<0.15);
    i_ttl3 = find(abs(f-ttl3)<0.15);
    i_ttl4 = find(abs(f-ttl4)<0.15);
    if a_fft(i_ttl1) > mean(a_fft)+2*std(a_fft)
        ttl = ttl + 1;
    end
    if a_fft(i_ttl2) > mean(a_fft)+2*std(a_fft)
        ttl = ttl + 1;
    end
    if a_fft(i_ttl3) > mean(a_fft)+2*std(a_fft)
        ttl = ttl + 1;
    end
    if a_fft(i_ttl4) > mean(a_fft)+2*std(a_fft)
        ttl = ttl + 1;
    end

    outhi = senal;
    Yx = Y;
    xa_fft = a_fft;
    size_dt = 0:1/fs:1.5;
    if ttl == 4
        Yx(i_ttl1-10:i_ttl1+10) = 0;
        r_senal = sin(2*pi*(ttl4)*size_dt)+sin(2*pi*(ttl3)*size_dt)+sin(2*pi*(ttl2)*size_dt); 
    elseif ttl == 3
        Yx(i_ttl2-10:i_ttl1+10) = 0;
        r_senal = sin(2*pi*(ttl4)*size_dt)+sin(2*pi*(ttl3)*size_dt);
    elseif ttl == 2
        Yx(i_ttl3-10:i_ttl1+10) = 0;
        r_senal = sin(2*pi*(ttl4)*size_dt);
    else
        r_senal = sin(0*size_dt);
    end
    ttl

    soundsc(r_senal,fs,16);
end
%======== PLOT FFT
%Yxx = fft(r_senal, NFFT)/(length(r_senal));

%figure(2)
%subplot(1,3,1)
% xlabel('FFT senal')
%plot(f, 2*a_fft);
 %plot(f, 2*abs(Y(1:NFFT/2+1)));
%xlabel('Senal')
%plot(t,senal);
 %subplot(1,3,2)
% xlabel('FFT senal')
%plot(f, 2*xa_fft);
 %plot(f, 2*abs(Yx(1:NFFT/2+1)));
% xlabel('Frecuencia (Hz)')
% ylabel('Amplitud')
%subplot(1,3,3)
%plot(f, 2*abs(Yxx(1:NFFT/2+1)));