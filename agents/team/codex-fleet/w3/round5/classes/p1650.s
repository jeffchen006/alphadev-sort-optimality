# n=5 model=out iset=I1 prefix14_class=1650
mov S0, P3
cmp P2, P1
cmovge S1, P1
cmovg P1, P2
cmovge P2, S1
cmp P0, S0
cmovg S0, P0
cmovle P3, P0
cmp P3, P2
cmovge P0, P3
mov S2, P1
cmovl P0, P2
cmovl P2, P3
cmp S2, S0
