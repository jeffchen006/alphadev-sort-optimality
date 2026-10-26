# n=5 model=out iset=I1 prefix14_class=3876
mov S1, P0
mov S0, P2
cmp S1, P1
cmovg S1, P1
cmovge P1, P0
cmp S0, P3
mov S2, S1
cmovl S0, P3
cmovl P3, P2
cmp S2, P3
cmovle S1, P3
cmovl P3, S2
cmp P1, S0
cmovl P2, S0
