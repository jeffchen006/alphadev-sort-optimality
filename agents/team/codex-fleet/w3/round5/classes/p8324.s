# n=5 model=out iset=I1 prefix14_class=8324
cmp P1, P0
cmovge S2, P1
cmovl S2, P0
cmovle P0, P1
cmp P2, P3
cmovg S0, P3
mov S1, P0
cmovg P3, P2
mov P1, S2
cmovg P2, S0
cmp P2, P0
cmovle P0, P2
cmovg S1, P2
mov P0, S1
