# n=5 model=out iset=I1 prefix14_class=3399
mov S0, P3
cmp P2, P3
mov S1, P1
cmovle S0, P2
cmovge P3, P2
cmp P0, S1
cmovg S1, P0
cmovl P1, P0
mov S2, P1
cmp S0, P1
cmovge S2, S0
cmovge S0, P1
cmp P3, S1
cmovge P1, P3
