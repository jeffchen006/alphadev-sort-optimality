# n=5 model=out iset=I1 prefix14_class=846
cmp P0, P1
cmovl S1, P1
mov S2, P3
cmovge S1, P0
cmovg P0, P1
cmp S2, P2
cmovg S2, P2
cmovg P2, P3
cmp S1, P2
mov P1, P2
cmovg P2, S1
cmovge S1, P1
cmp P0, S2
cmovle P2, S2
