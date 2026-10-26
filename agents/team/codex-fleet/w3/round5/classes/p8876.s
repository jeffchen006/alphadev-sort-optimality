# n=5 model=out iset=I1 prefix14_class=8876
cmp P1, P3
cmovge S0, P3
cmovg P3, P1
cmovg P1, S0
mov S2, P2
cmp S2, P0
cmovg S2, P0
cmovl P2, P0
cmovg P0, P2
cmp P3, P2
cmovg P0, P3
cmovg P3, P2
cmp P1, S2
cmovle S0, P1
