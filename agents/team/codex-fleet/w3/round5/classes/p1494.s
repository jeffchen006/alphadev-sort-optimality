# n=5 model=out iset=I1 prefix14_class=1494
mov S0, P0
mov S2, P1
cmp P1, P3
cmovl S2, P3
cmovg P1, P3
cmp S0, P2
cmovl S0, P2
cmovl P2, P0
cmp S0, S2
cmovge P0, S2
cmovg S2, S0
cmovg S0, P0
mov S2, P1
cmp P2, P1
