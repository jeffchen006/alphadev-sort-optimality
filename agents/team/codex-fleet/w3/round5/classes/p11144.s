# n=5 model=out iset=I1 prefix14_class=11144
cmp P3, P1
mov S0, P0
cmovle S1, P3
cmovle P3, P1
cmovl P1, S1
cmp S0, P2
cmovle P0, P2
cmovge S0, P2
cmp P0, P3
mov P2, P0
cmovle P0, P3
cmovl P3, P2
mov S2, P1
mov P0, P3
