# n=5 model=out iset=I1 prefix14_class=7178
mov S2, P3
cmp P1, P3
cmovg S2, P1
cmovg P1, P3
cmp P0, P2
cmovl S0, P2
cmovle P2, P0
mov S1, P1
cmovl P0, S0
cmp S1, P2
cmovle S1, P2
cmovge P1, P2
cmp P0, S2
mov P1, S2
