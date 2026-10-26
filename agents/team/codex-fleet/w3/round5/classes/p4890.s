# n=5 model=out iset=I1 prefix14_class=4890
mov S2, P2
mov S1, P1
cmp P0, S2
cmovle S2, P0
cmovle P0, P2
cmp P3, P1
cmovl S1, P3
mov P2, S1
cmovle P3, P1
cmp S1, S2
cmovg S1, S2
cmovl P2, S2
cmp P0, P3
cmovge S2, P0
