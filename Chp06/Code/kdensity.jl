using RDatasets, KernelDensity
mlmf = dataset("mlmRev", "Gcsemv");

df = mlmf[complete_cases(mlmf[[:Written, :Course]]), :];
dc = array(df[:Course]);  kdc = kde(dc);
dw = array(df[:Written]); kdw = kde(dw);

using Winston
kdc = kde(dc); kdw = kde(dw);
plot(kdc.x, kdc.density, "r--", kdw.x, kdw.density, "b;")
