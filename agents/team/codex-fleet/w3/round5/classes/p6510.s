# n=5 model=out iset=I1 prefix14_class=6510
mov S2, P0
cmp P3, P0
cmovg S2, P3
cmovle P0, P3
mov S0, P1
cmp P2, P1
cmovle S0, P2
cmovl P2, P1
cmp S2, P2
cmovl S1, P2
cmovle P2, S2
mov P3, S0
cmovl S2, S1
cmp P0, S0
