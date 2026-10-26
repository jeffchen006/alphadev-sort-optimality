# n=5 model=out iset=I1 prefix14_class=6660
mov S2, P1
cmp P3, P1
cmovg S2, P3
cmovl P1, P3
mov S0, S2
mov S1, P0
cmp P0, P2
cmovg P0, P2
cmovl S1, P2
cmp S1, S0
cmovle S0, S1
cmovge S2, S1
cmp P0, P1
cmovle S1, P1
