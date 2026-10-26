# n=5 model=out iset=I1 prefix14_class=10367
mov S0, P0
cmp P3, P1
cmovle S2, P3
cmovle P3, P1
cmovl P1, S2
cmp P0, P2
cmovl S0, P2
cmovge P0, P2
cmovle P2, P0
cmp S0, P3
cmovg S2, S0
cmovg S0, P3
cmovg P3, S2
cmp P1, P0
