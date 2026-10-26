# n=5 model=out iset=I1 prefix14_class=5861
mov S2, P2
cmp S2, P3
cmovl P2, P3
cmovg S2, P3
cmp P1, P0
mov P3, P0
cmovl P0, P1
cmovl P1, P3
mov S0, P2
cmp P1, P2
cmovge S0, P1
cmovle P2, P1
cmp S2, P0
cmovle S1, S2
