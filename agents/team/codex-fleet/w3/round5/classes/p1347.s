# n=5 model=out iset=I1 prefix14_class=1347
cmp P0, P2
mov S1, P1
cmovle S0, P0
cmovg S0, P2
cmovg P2, P0
cmp P3, P1
cmovl S1, P3
cmovge P1, P3
mov S2, P2
cmp P1, P2
cmovle P2, P1
cmovg S2, P1
mov S2, S0
cmp S2, S1
