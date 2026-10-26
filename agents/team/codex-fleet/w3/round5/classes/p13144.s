# n=5 model=out iset=I1 prefix14_class=13144
cmp P3, P0
cmovle S1, P3
cmovg S1, P0
cmovl P3, P0
cmp P1, P2
cmovge S0, P2
cmovl S0, P1
cmovl P1, P2
cmp S1, S0
cmovg P0, S1
cmovge S1, S0
cmovg S0, P0
mov S1, P3
cmp S1, P1
