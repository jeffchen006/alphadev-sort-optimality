# n=5 model=out iset=I1 prefix14_class=7669
cmp P0, P1
cmovge S1, P1
cmovle S1, P0
cmovl P0, P1
cmp P3, P2
cmovg S0, P2
cmovg P2, P3
cmovg P3, S0
cmp S1, P3
cmovl S2, S1
mov S0, P2
cmovle S1, P3
cmovl P3, S2
cmp S0, P0
