# n=5 model=out iset=I1 prefix14_class=10343
mov S2, P1
cmp S2, P2
cmovle P1, P2
cmovl P2, S2
mov S1, P0
cmovg S2, P2
cmp P0, P3
cmovl P0, P3
cmovl P3, S1
cmp P1, P0
cmovge S0, P0
cmovge P0, P1
cmovg P1, S0
mov S1, P1
