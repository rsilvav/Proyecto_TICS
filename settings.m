fs=40e3; % sampleo
header_f = 0.3; % delta tiempo de duracion del header 
info_size_f = 0.15; % delta tiempo por pixel 
info_pixel_f = 0.175; % 0.35
Rf = 4000; %fbase del rojo
Gf = 8000; %fbase del verde
Bf = 12000;% fbase del azul
Tf = 14000; % fbase del texto
header1=2000;% las tres frecs del header 
header2=1500;
header3=1000;
ancho=3000;
alto=1500;
len= 500;
delta=200;
dif = 100; % diferencia entre cada valor del pixel 
img='twitter.png';
p2f = @(px, b, d) px*d + b;
f2p = @(f, bf, d) round((f-bf)/d);
ttl1 = 8000;
ttl2 = 10000;
ttl3 = 12000;
ttl4 = 14000;
%========= FILTROS
w1=[(ttl1-100)/(fs/2) (ttl1+100)/(fs/2)];
w2=[(ttl2-100)/(fs/2) (ttl2+100)/(fs/2)];
w3=[(ttl3-100)/(fs/2) (ttl3+100)/(fs/2)];
w4=[(ttl4-100)/(fs/2) (ttl4+100)/(fs/2)];
n=50;
b1=fir1(n,w1,'stop','noscale');
b2=fir1(n,w2,'stop');
b3=fir1(n,w3,'stop');
b4=fir1(n,w4,'stop');
