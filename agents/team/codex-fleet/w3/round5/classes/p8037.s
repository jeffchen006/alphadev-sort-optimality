# n=5 model=out iset=I1 prefix14_class=8037
cmp P2, P1
mov S1, P2
cmovge S1, P1
cmovg P1, P2
cmp P3, P0
cmovg S0, P3
cmovg P3, P0
cmovg P0, S0
cmp S1, P3
cmovl S2, P3
cmovle P3, S1
mov P2, P0
cmovl S1, S2
cmp P0, P1
