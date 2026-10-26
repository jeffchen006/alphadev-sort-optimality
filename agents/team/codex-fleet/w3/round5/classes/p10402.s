# n=5 model=out iset=I1 prefix14_class=10402
cmp P3, P2
cmovg S1, P3
cmovg P3, P2
cmovg P2, S1
mov S0, P1
cmp S0, P0
cmovg S0, P0
mov S2, P2
cmovl P1, P0
cmp P1, S2
cmovle P2, P1
cmovg S2, P1
cmp S0, P3
cmovge S2, P3
