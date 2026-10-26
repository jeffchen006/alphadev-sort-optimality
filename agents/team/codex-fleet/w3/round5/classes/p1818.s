# n=5 model=out iset=I1 prefix14_class=1818
cmp P3, P0
cmovge S0, P0
mov S2, P2
cmovg P0, P3
cmovge P3, S0
cmp P1, P2
cmovg S2, P1
cmovge P1, P2
cmp S2, P0
cmovge P2, P0
cmovle P2, S2
cmovl S2, P0
mov S2, P1
cmp P3, S2
