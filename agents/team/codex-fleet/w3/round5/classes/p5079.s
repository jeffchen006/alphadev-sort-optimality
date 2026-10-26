# n=5 model=out iset=I1 prefix14_class=5079
cmp P2, P0
mov S0, P2
cmovle P2, P0
mov S2, P1
cmovg S0, P0
cmp S2, P3
cmovg S2, P3
cmovg P3, P1
cmp S0, S2
cmovge P0, S2
cmovg S2, S0
cmovl P0, S0
cmp P2, P3
cmovg P1, P2
