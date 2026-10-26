# n=5 model=out iset=I1 prefix14_class=10577
cmp P2, P3
cmovge S0, P3
cmovle S0, P2
mov S2, P0
cmovge P3, P2
cmp P0, P1
mov S1, P3
cmovge S2, P1
cmovge P1, P0
cmp P1, S1
cmovg S1, P1
cmovl P3, P1
cmp S0, S2
cmovl P1, P3
