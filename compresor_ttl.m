function amp = compresor_ttl(f,a_fft,ttl1,ttl2,ttl3,ttl4,s1,s2,s3,s4,div)
    i_ttl1 = min(abs(f-ttl1));
    i_ttl2 = min(abs(f-ttl2));
    i_ttl3 = min(abs(f-ttl3));
    i_ttl4 = min(abs(f-ttl4));
    
    i_d1 = min(abs(f-s1));
    i_d2 = min(abs(f-s2));
    i_d3 = min(abs(f-s3));
    i_d4 = min(abs(f-s4));
    
    power = [a_fft(i_ttl1) a_fft(i_ttl2) a_fft(i_ttl3) a_fft(i_ttl4) a_fft(i_d1) a_fft(i_d2) a_fft(i_d3) a_fft(i_d4)];
    
    amp = min(power);
    amp = amp/div;
end
