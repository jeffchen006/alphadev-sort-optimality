# n=5 model=out iset=I1 prefix14_class=2544
mov S2, P0
cmp P1, S2
cmovl P0, P1
mov S0, P3
cmovl P1, S2
cmp S0, P2
cmovl P3, P2
mov S1, P1
cmovl P2, S0
cmp P1, P3
cmovle S1, P3
cmovg P1, P3
cmp P0, P2
cmovge S2, P2
