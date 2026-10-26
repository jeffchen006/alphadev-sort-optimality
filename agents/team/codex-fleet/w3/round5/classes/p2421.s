# n=5 model=out iset=I1 prefix14_class=2421
mov S1, P1
cmp S1, P0
cmovge P1, P0
mov S2, P3
cmovge P0, S1
cmp P2, P3
cmovl P3, P2
mov S0, P0
cmovge S2, P2
cmp S0, S2
cmovge P0, S2
cmovg S2, S0
cmp P1, P3
cmovle S2, P3
