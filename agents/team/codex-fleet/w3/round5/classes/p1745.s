# n=5 model=out iset=I1 prefix14_class=1745
mov S1, P0
cmp P0, P1
cmovl P0, P1
cmovle P1, S1
mov S0, P3
cmp P3, P2
cmovge S0, P2
cmovle P3, P2
cmp S0, P1
mov P2, S0
cmovg P2, P1
mov S2, P3
cmovle S0, P1
cmovg P1, S0
