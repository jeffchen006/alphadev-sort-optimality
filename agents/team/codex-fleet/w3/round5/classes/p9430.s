# n=5 model=out iset=I1 prefix14_class=9430
cmp P3, P0
cmovle S1, P0
cmovge S1, P3
cmovg P3, P0
mov S2, P1
cmp P2, P1
cmovle P1, P2
mov S0, P1
cmovle P2, S2
cmp P1, P3
cmovl S0, P3
cmovge P1, P3
cmp P2, S1
mov P1, S0
