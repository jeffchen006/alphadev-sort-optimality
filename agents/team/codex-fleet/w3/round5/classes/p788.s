# n=5 model=out iset=I1 prefix14_class=788
mov S2, P0
cmp P3, P2
cmovl S0, P3
cmovle P3, P2
cmovl P2, S0
cmp S2, P1
mov S0, P2
cmovl P0, P1
cmovg S2, P1
cmp P0, P3
cmovge P1, P0
cmovg P0, P3
cmovg P3, P1
cmp P2, S2
