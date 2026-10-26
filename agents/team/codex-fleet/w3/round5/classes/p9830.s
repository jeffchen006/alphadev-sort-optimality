# n=5 model=out iset=I1 prefix14_class=9830
cmp P0, P2
cmovl S1, P2
cmovge S1, P0
cmovl P2, P0
mov S0, P1
cmp P1, P3
cmovg P1, P3
cmovl S0, P3
mov S2, S1
cmp S2, S0
cmovg S2, S0
cmovle S1, S0
cmp P1, P2
cmovg S0, P1
