# n=5 model=out iset=I1 prefix14_class=13700
mov S2, P0
cmp S2, P1
cmovg S2, P1
cmovle P0, P1
cmp P2, P3
cmovge P1, P3
cmovge P3, P2
cmovg P2, P1
cmp P2, S2
cmovge S0, S2
cmovl S0, P2
cmovg S2, P2
mov S1, P3
cmp P0, P3
