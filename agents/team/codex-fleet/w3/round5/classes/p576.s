# n=5 model=out iset=I1 prefix14_class=576
cmp P0, P2
cmovge S1, P0
cmovle S1, P2
cmovl P2, P0
cmp P3, P1
mov P0, P2
mov S0, S1
cmovg S2, P1
cmovle S2, P3
cmovg P1, P3
cmp P1, S0
cmovge S1, P1
cmovle S0, P1
cmp S2, P0
