# n=5 model=out iset=I1 prefix14_class=8088
mov S0, P2
cmp S0, P0
cmovle P2, P0
cmovge S0, P0
cmp P1, P3
cmovge P0, P3
cmovge P3, P1
mov S2, S0
cmovg P1, P0
cmp P1, S2
cmovge S0, P1
cmovl S2, P1
mov S1, P3
cmp P2, S1
