# n=5 model=out iset=I1 prefix14_class=7142
mov S1, P1
cmp S1, P2
mov S2, P0
cmovl P1, P2
cmovle P2, S1
cmp S2, P3
cmovg P0, P3
mov S0, P2
cmovl S2, P3
cmp P0, P2
cmovg S0, P0
cmovg P0, P2
cmp P1, S2
cmovge P3, S2
