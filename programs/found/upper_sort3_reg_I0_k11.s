# n=3 R=4 iset=I0 model=reg source=upper:mcmc (MODEL 1) k=11
cmp P0, P2
mov S0, P2
cmovg S0, P0
cmovg P0, P2
mov P2, P1
cmp P2, P0
cmovl P1, P0
cmovl P0, P2
cmp P2, S0
cmovl P2, S0
cmovg P1, S0
