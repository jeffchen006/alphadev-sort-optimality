# n=5 model=out iset=I1 prefix14_class=10986
cmp P1, P2
cmovge S2, P1
mov S1, P0
cmovg P1, P2
cmovg P2, S2
cmp S1, P3
cmovl P0, P3
cmovle P3, S1
cmp P0, P2
mov S0, P0
cmovle P0, P2
cmovle P2, S0
cmp P1, P3
cmovle S0, P3
