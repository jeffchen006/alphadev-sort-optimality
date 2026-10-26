# n=5 model=out iset=I1 prefix14_class=869
mov S2, P3
mov S1, P1
cmp P1, P0
cmovge S1, P0
cmovle P1, P0
cmp S2, P2
mov S0, P1
cmovge P3, P2
cmovge P2, S2
cmovge S2, P3
cmp P2, P1
cmovg P1, P2
cmovl S0, P2
cmp S1, S2
