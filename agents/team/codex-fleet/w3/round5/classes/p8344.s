# n=5 model=out iset=I1 prefix14_class=8344
cmp P3, P0
cmovle S2, P0
cmovl P0, P3
cmovl P3, S2
cmp P1, P2
mov S1, P2
cmovg S1, P1
cmovg P1, P2
cmp P0, P1
mov P2, S1
cmovle S0, P0
cmovle P0, P1
cmovge S0, P1
cmp S1, P3
