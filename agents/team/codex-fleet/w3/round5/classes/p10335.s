# n=5 model=out iset=I1 prefix14_class=10335
mov S0, P3
cmp P1, P3
cmovg P3, P1
mov S2, P2
cmovl S0, P1
cmp S2, P0
cmovle P2, P0
cmovle P0, S2
cmp P3, P2
cmovge P1, P3
cmovge P3, P2
cmovge P2, P1
cmp P0, S0
cmovg P1, P0
