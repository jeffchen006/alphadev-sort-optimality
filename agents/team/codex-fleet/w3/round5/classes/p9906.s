# n=5 model=out iset=I1 prefix14_class=9906
cmp P1, P0
cmovge S0, P1
cmovge P1, P0
cmovg P0, S0
mov S2, P3
cmp P3, P2
cmovle P3, P2
cmovle P2, S2
cmp P3, P0
cmovge S2, P0
cmovl S2, P3
cmovle P3, P0
mov P0, P2
cmp P2, P1
