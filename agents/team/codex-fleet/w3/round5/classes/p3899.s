# n=5 model=out iset=I1 prefix14_class=3899
mov S0, P2
cmp S0, P0
cmovg P2, P0
cmovge P0, S0
cmp P1, P3
cmovle S2, P1
cmovle P1, P3
cmovl P3, S2
mov S1, P2
cmp P2, P3
cmovle P2, P3
cmovl P3, S1
mov P3, P2
mov S1, P0
