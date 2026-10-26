# n=5 model=out iset=I1 prefix14_class=5829
cmp P2, P3
mov S1, P3
cmovle S1, P2
cmovg P3, P2
cmp P0, P1
cmovle P2, P0
cmovl P0, P1
cmovl P1, P2
cmp S1, P1
mov S0, S1
cmovle S0, P1
cmovge S1, P1
mov P1, P0
cmp P0, P3
