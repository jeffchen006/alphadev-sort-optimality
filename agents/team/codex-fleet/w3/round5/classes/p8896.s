# n=5 model=out iset=I1 prefix14_class=8896
mov S2, P3
cmp P1, P3
cmovge S2, P1
cmovg P1, P3
cmp P0, P2
cmovle P3, P0
cmovge P3, P2
cmovl P0, P2
cmp S2, P0
cmovle S0, S2
cmovle S2, P0
cmovle P0, S0
mov P2, P3
cmp P2, P1
