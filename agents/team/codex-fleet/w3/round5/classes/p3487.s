# n=5 model=out iset=I1 prefix14_class=3487
mov S1, P0
cmp S1, P1
mov S2, P2
cmovg S1, P1
cmovle P0, P1
cmp P2, P3
cmovl P2, P3
cmovg S2, P3
cmp S1, S2
mov P3, S1
cmovge S1, S2
cmovl P3, S2
cmp P0, P2
cmovle S0, P0
