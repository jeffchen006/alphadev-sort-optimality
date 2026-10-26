# n=5 model=out iset=I1 prefix14_class=951
cmp P0, P2
mov S0, P2
mov S1, P3
cmovge S0, P0
cmovl P2, P0
mov S2, S0
cmp P3, P1
cmovg S1, P1
cmovg P1, P3
cmp P1, S2
cmovg S0, P1
cmovge P1, S2
cmp S1, P2
cmovle S2, S1
