# n=5 model=out iset=I1 prefix14_class=984
cmp P3, P1
mov S0, P0
cmovge S2, P3
cmovl S2, P1
cmovl P1, P3
cmp S0, P2
cmovg P0, P2
cmovg P2, S0
cmovle S0, P2
cmp S2, P2
cmovge P2, S2
cmovg S2, S0
cmp P1, P0
cmovge S1, P0
