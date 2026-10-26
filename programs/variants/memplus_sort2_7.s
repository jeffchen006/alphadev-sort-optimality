# n=2 R=4 iset=I0 model=memplus source=spec hand example (MODEL §4.5): L=7 < L_AD(2) = 2n + k_out(2) = 8
mov S0, P0
cmp S0, P1
mov S1, P1
cmovg S1, P0
cmovg S0, P1
mov P0, S0
mov P1, S1
