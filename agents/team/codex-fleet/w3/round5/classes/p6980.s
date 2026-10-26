# n=5 model=out iset=I1 prefix14_class=6980
cmp P0, P1
mov S1, P3
cmovg S0, P1
cmovg P1, P0
cmovg P0, S0
cmp P2, P3
cmovl S1, P2
mov S2, P1
cmovg P3, P2
cmp P1, P3
cmovge S2, P3
cmovle P1, P3
cmp S1, P0
cmovge S0, P0
