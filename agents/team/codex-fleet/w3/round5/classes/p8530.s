# n=5 model=out iset=I1 prefix14_class=8530
mov S0, P3
mov S2, P1
cmp P1, P2
cmovl S2, P2
cmovle P2, P1
cmovle P1, S2
cmp P3, P0
cmovle P3, P0
cmovle P0, S0
cmp P3, S2
cmovg P1, P3
cmovge P3, S2
cmp P0, P2
cmovge S0, P2
