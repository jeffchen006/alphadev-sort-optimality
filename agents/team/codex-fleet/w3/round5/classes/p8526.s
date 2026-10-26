# n=5 model=out iset=I1 prefix14_class=8526
mov S0, P3
cmp S0, P2
cmovle P3, P2
mov S2, P1
cmovle P2, S0
cmp P0, S2
cmovg P1, P0
cmovl S2, P0
cmp P3, P1
cmovg P0, P1
cmovge P1, P3
cmovg P3, P0
cmp S2, P2
cmovge S1, S2
