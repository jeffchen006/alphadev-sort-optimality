# n=5 model=out iset=I1 prefix14_class=1503
cmp P2, P3
mov S0, P3
cmovl S0, P2
cmovge P3, P2
cmp P1, P0
mov S2, P1
cmovg S2, P0
cmovg P0, P1
cmp S0, S2
cmovg P1, S0
cmovg S0, S2
cmovg S2, P1
cmp P3, P0
cmovle P1, P3
