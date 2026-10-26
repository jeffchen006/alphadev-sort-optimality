# n=5 model=out iset=I1 prefix14_class=6881
cmp P2, P0
mov S0, P3
cmovle S2, P2
cmovge S2, P0
cmovle P2, P0
cmp S0, P1
cmovle S0, P1
cmovg P3, P1
mov P0, S0
cmp P2, S0
cmovl P0, P2
cmovge S0, P2
cmp S2, P3
cmovle S1, P3
