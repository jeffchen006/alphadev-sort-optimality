# n=5 model=out iset=I1 prefix14_class=1821
cmp P2, P0
cmovg S0, P0
cmovge P0, P2
mov S2, P3
cmovg P2, S0
cmp P1, P3
cmovg S2, P1
cmovg P1, P3
cmp S2, P0
cmovle P3, S2
cmovl S2, P0
mov S2, P1
cmovge P3, P0
cmp P2, S2
