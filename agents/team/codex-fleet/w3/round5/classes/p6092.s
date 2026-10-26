# n=5 model=out iset=I1 prefix14_class=6092
mov S0, P3
cmp P3, P2
cmovl S0, P2
cmovl P2, P3
cmp P1, P0
cmovge S1, P1
cmovg P1, P0
cmovle S1, P0
cmp S1, S0
cmovg S2, S1
cmovge S1, S0
cmovg S0, S2
mov P0, P2
cmp P2, P1
