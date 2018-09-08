settings;
checked = 0;
mi_dir = 3;
mi_id = 16;
vecinos = [2];
r_vecinos = zeros(length(vecinos(1)),length(vecinos));
stop = zeros(length(vecinos(1)),length(vecinos));
counter = zeros(length(vecinos(1)),length(vecinos));
my_dir = mi_dir*ones(length(vecinos(1)),length(vecinos));
v_r = [vecinos;r_vecinos;stop;counter;my_dir];
len = length(vecinos);

size_dt = 0:1/fs:1;
tf = 1.5; % duracion de la grabacion (segs)

token = 0;

if token == 1
    check(v_r);
    checked = 1;
end

while true
    recorder = audiorecorder(fs, 16, 1);
    recordblocking(recorder, tf);
    pause(0.5);
    senal = recorder.getaudiodata;
    %======== PLOT FFT
    frames_dim = length(senal);
    NFFT = 2^nextpow2(frames_dim);
    Y = fft(senal, NFFT)/frames_dim;
    f = fs/2*linspace(0,1,NFFT/2+1);
    a_fft = abs(Y(1:NFFT/2+1));
    [r_ttl r_dir] = obt_ttl(f,a_fft,ttl1,ttl2,ttl3,ttl4,s1,s2,s3,s4);
    disp(['ttl recibido = ' num2str(r_ttl) ' direccion = ' num2str(r_dir)])
    r_senal = sin(0*size_dt);
    if (r_ttl == 0 && r_dir == mi_dir) || (r_ttl == mi_id && r_dir == 0)
        aux_dir = de2bi(mi_dir,4);
        r_senal = senal_direccion(aux_dir,size_dt,s1,s2,s3,s4);
        soundsc(r_senal,fs,16);
        pause(1.5);
    elseif r_ttl == 0 && r_dir == 15
        mi_id = randi(4)-1;
        mi_id = 2^mi_id;
        aux_dir = de2bi(mi_id,4);
        r_senal = senal_direccion(aux_dir,size_dt,ttl1,ttl2,ttl3,ttl4);
        soundsc(r_senal,fs,16);
        pause(1.5);
    elseif r_ttl == 4 && r_dir == mi_dir
        break;
    end
end
