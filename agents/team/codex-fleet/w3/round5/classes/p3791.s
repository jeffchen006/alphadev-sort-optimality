# n=5 model=out iset=I1 prefix14_class=3791
cmp P1, P3
mov S0, P1
cmovge P1, P3
mov S2, P1
cmovge P3, S0
cmp P0, P2
cmovg S0, P2
cmovle S0, P0
cmovl P0, P2
cmp S2, S0
cmovl P1, S0
cmovl S0, S2
cmp P0, P3
mov S0, P3
