# n=5 model=out iset=I1 prefix14_class=8811
mov S2, P0
cmp S2, P1
cmovl P0, P1
cmovl P1, S2
mov S1, P3
cmp P2, P3
cmovg S1, P2
cmovle P3, P2
cmp P0, S1
cmovge P2, S1
cmovge S1, P0
cmovg P0, P2
cmp P3, P1
mov S0, P3
