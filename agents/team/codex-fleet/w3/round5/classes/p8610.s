# n=5 model=out iset=I1 prefix14_class=8610
cmp P0, P2
cmovle S1, P2
cmovg S1, P0
cmovl P2, P0
cmp P1, P3
cmovge S2, P1
cmovg P1, P3
cmovg P3, S2
mov S0, S1
mov P0, P2
cmp S0, P3
cmovge S1, P3
cmovge P3, S0
cmp P0, P1
