# n=5 model=out iset=I1 prefix14_class=3949
mov S0, P0
cmp P0, P1
cmovge S0, P1
cmovl P0, P1
cmp P3, P2
mov P1, S0
cmovle S1, P3
cmovle P3, P2
cmovle P2, S1
mov S2, P0
cmp P2, S0
cmovg P1, P2
cmovle S0, P2
cmp S2, P3
