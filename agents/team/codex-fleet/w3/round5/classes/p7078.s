# n=5 model=out iset=I1 prefix14_class=7078
mov S1, P3
cmp P0, P3
cmovge S1, P0
cmovge P0, P3
mov S2, P0
cmp P1, P2
cmovge P3, P1
cmovge P1, P2
cmovge P2, P3
cmp P1, P0
cmovl S2, P1
cmovle P1, P0
mov S0, P2
cmovg P0, P1
