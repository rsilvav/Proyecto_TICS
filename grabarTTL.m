settings;
size_dt = 0:1/fs:15*info_size_f;

direccion = [1 0 0 0];
s_dir = senal_direccion(direccion,size_dt,ttl1,ttl2,ttl3,ttl4);
r_senal = sin(2*pi*(ttl4)*size_dt)+sin(2*pi*(ttl3)*size_dt)+sin(2*pi*(ttl2)*size_dt)+sin(2*pi*(ttl1)*size_dt); 
soundsc(r_senal+s_dir,fs,16);

audiowrite('ttl.wav',r_senal+s_dir,fs);