# n=5 model=out iset=I1 prefix14_class=11184
cmp P3, P2
mov S1, P1
cmovge S2, P2
cmovg P2, P3
cmovge P3, S2
cmp S1, P0
cmovl S1, P0
cmovle P0, P1
cmp P2, S1
cmovge S2, P2
cmovg P2, S1
cmovg S1, S2
cmp P0, P3
mov P1, P0
