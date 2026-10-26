# n=5 model=out iset=I1 prefix14_class=8349
cmp P2, P1
cmovle S1, P1
cmovle P1, P2
mov S0, P1
cmovl P2, S1
mov S2, P0
cmp P3, S2
cmovg P0, P3
cmovge P3, S2
cmp S0, P3
cmovl S0, P3
cmovg P1, P3
cmp P2, P0
mov P1, S0
