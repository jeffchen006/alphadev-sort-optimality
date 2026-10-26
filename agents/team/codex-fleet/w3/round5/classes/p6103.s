# n=5 model=out iset=I1 prefix14_class=6103
mov S2, P2
cmp P2, P0
cmovle S2, P0
cmovl P0, P2
cmp P3, P1
cmovg S1, P3
cmovle S1, P1
mov S0, S1
cmovg P3, P1
cmp S1, S2
cmovg S1, S2
cmovg S2, S0
cmp P3, P0
cmovge S2, P0
