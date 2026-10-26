# n=5 model=out iset=I1 prefix14_class=4388
cmp P1, P3
cmovge S1, P3
cmovge P3, P1
mov S2, P2
cmovg P1, S1
cmp P0, P2
cmovl P2, P0
cmovge S2, P0
cmp S2, P3
cmovle S0, P3
cmovg S0, S2
cmovg S2, P3
mov P3, P1
cmp P3, P2
