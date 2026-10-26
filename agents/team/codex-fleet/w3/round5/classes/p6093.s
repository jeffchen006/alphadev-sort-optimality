# n=5 model=out iset=I1 prefix14_class=6093
mov S0, P3
cmp P3, P2
cmovl S0, P2
cmovl P2, P3
cmp P1, P0
cmovge S1, P1
cmovg P1, P0
cmovle S1, P0
cmp S1, S0
cmovge P3, S1
cmovge S1, S0
cmovg S0, P3
mov P0, P2
cmp P2, P1
