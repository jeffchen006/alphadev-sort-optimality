# n=5 model=out iset=I1 prefix14_class=9178
cmp P1, P0
mov S0, P0
cmovg P0, P1
mov S2, P2
cmovle S0, P1
cmp P3, P2
cmovle P2, P3
cmovl P3, S2
mov S1, P0
cmp S0, P2
cmovge S2, S0
cmovge S0, P2
cmovg P2, S2
cmp P3, S1
