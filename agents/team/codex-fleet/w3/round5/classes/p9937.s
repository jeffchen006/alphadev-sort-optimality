# n=5 model=out iset=I1 prefix14_class=9937
cmp P1, P0
cmovle S0, P0
cmovge S0, P1
cmovl P0, P1
mov S1, S0
cmp P3, P2
cmovg P1, P3
cmovg P3, P2
cmovg P2, P1
cmp S0, P2
cmovg S0, P2
cmovl S1, P2
mov S1, S0
cmp P0, P3
