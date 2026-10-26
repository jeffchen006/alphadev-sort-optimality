# n=5 model=out iset=I1 prefix14_class=13854
mov S2, P0
mov S1, P3
cmp S2, P1
cmovg S2, P1
cmovl P0, P1
cmp P2, S1
cmovl P3, P2
cmovge S1, P2
cmp P0, S1
cmovle S0, S1
cmovle S1, P0
cmovle P0, S0
mov P0, P3
cmp S2, P3
