# n=5 model=out iset=I1 prefix14_class=8498
cmp P2, P3
cmovle S1, P3
cmovle P3, P2
cmovl P2, S1
mov S2, P1
cmp S2, P0
cmovle S2, P0
mov S0, S2
cmovl P0, P1
cmp P2, S2
cmovle S0, P2
cmovge S2, P2
cmp P0, P3
cmovg P2, P3
