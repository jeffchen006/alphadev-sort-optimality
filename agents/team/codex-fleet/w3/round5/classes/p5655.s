# n=5 model=out iset=I1 prefix14_class=5655
cmp P2, P3
mov S2, P3
cmovl P3, P2
cmovle P2, S2
cmp P0, P1
mov S2, P0
mov S1, P3
cmovg S2, P1
cmovle P0, P1
cmp S2, S1
cmovle S1, S2
cmovl S2, P3
cmp P2, P0
cmovle S0, P2
