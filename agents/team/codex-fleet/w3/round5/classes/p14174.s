# n=5 model=out iset=I1 prefix14_class=14174
cmp P0, P3
mov S1, P3
cmovle S1, P0
cmovge P3, P0
cmp P2, P1
cmovge S0, P2
cmovl S0, P1
cmovl P1, P2
cmp P3, S0
mov S2, P1
cmovg P2, S0
cmovg S0, P3
cmovg P3, P2
cmp S1, S2
