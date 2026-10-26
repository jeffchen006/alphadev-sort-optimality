# n=5 model=out iset=I1 prefix14_class=2474
mov S2, P0
cmp P0, P3
cmovl S2, P3
cmovg P0, P3
mov S0, S2
cmp P2, P1
cmovge P3, P1
cmovge P1, P2
cmovg P2, P3
cmp S2, P1
cmovle S2, P1
mov S1, P0
cmovle P1, S0
cmp P2, P0
