# n=5 model=out iset=I1 prefix14_class=11855
mov S1, P1
cmp P0, P2
mov S2, P0
cmovg S2, P2
cmovg P2, P0
cmp P1, P3
cmovl S1, P3
cmovle P3, P1
mov S0, S1
cmp S0, P2
cmovl S0, P2
cmovl P2, S1
cmp P3, S2
cmovge P1, S2
