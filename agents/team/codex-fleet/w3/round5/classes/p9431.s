# n=5 model=out iset=I1 prefix14_class=9431
cmp P1, P2
mov S2, P2
cmovle P2, P1
cmovle P1, S2
cmp P0, P3
mov S1, P2
cmovge S2, P0
cmovl S2, P3
cmovg P0, P3
cmp P2, P0
cmovge S1, P0
cmovge P0, P2
mov S1, P0
mov S0, P1
