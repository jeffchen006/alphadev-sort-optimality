# n=5 model=out iset=I1 prefix14_class=11149
cmp P3, P1
cmovle S1, P3
cmovle P3, P1
mov S2, P0
cmovl P1, S1
cmp S2, P2
cmovl P0, P2
cmovg S2, P2
mov P2, P3
cmp P0, P2
cmovl P3, P0
cmovle P0, P2
cmp S2, P1
cmovge S0, P1
