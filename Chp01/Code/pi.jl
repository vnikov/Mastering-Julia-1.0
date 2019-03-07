using Printf
K = 0; N = 10000000;
@time begin
for i in 1:N
  if (rand()^2 + rand()^2) < 1.0
    global K += 1
  end
end
end
p = (4*K)/N
@printf "Estimation of PI is %.6f\n" p
