# n=5 model=out iset=I1 prefix14_class=14185
cmp P0, P3
cmovge S0, P0
cmovl S0, P3
mov S1, P2
cmovle P3, P0
cmp S1, P1
cmovl P2, P1
cmovg S1, P1
cmp P2, S0
cmovge P1, P2
cmovg P2, S0
cmovg S0, P1
cmp S1, P3
cmovge S0, P3
