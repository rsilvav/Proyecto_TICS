function [r_ttl r_dir] = obt_ttl(f,a_fft,ttl1,ttl2,ttl3,ttl4,s1,s2,s3,s4)
    r_ttl = 0;
    r_dir = 0;
    [c1 i_ttl1] = min(abs(f-ttl1));
    [c2 i_ttl2] = min(abs(f-ttl2));
    [c3 i_ttl3] = min(abs(f-ttl3));
    [c4 i_ttl4] = min(abs(f-ttl4));
    
    if a_fft(i_ttl1) >= 0.0001
        r_ttl = r_ttl + 8;
    end
    if a_fft(i_ttl2) >= 0.0001
        r_ttl = r_ttl + 4;
    end
    if a_fft(i_ttl3) >= 0.0001
        r_ttl = r_ttl + 2;
    end
    if a_fft(i_ttl4) >= 0.0001
        r_ttl = r_ttl + 1;
    end
    
    [c1 i_d1] = min(abs(f-s1));
    [c2 i_d2] = min(abs(f-s2));
    [c3 i_d3] = min(abs(f-s3));
    [c4 i_d4] = min(abs(f-s4));
    
    if a_fft(i_d1) >= 0.0001
        r_dir = r_dir+8;
    end
    if a_fft(i_d2) >= 0.0001
        r_dir = r_dir+4;
    end
    if a_fft(i_d3) >= 0.0001
        r_dir = r_dir+2;
    end
    if a_fft(i_d4) >= 0.0001
        r_dir = r_dir+1;
    end
end