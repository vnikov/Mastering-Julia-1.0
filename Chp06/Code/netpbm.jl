img = open("juliaset.pgm");
magic = chomp(readline(img));   # => "P5"
if magic == "P5"
 out = open("jsetcolor.ppm", "w");
 println(out, "P6");
 params = chomp(readline(img));  # => "800 400 255"
 println(out, params);
 (wd, ht, pmax) = int(split(params));
 for i = 1:ht
    buf = readbytes(img, wd);
    for j = 1:wd
      (r,g,b) = pseudocolor(buf[j]);
      write(out,r); write(out,g); write(out,b);
    end
 end
 close(out);
else
 error("Not a NetPBM grayscale file")
end
close(img);
