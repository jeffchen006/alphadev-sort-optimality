# n=5 model=out iset=I1 prefix14_class=11885
mov S2, P0
mov S0, P3
cmp P0, P2
cmovl S2, P2
cmovl P2, P0
cmp S0, P1
cmovle S0, P1
cmovg P3, P1
cmp S2, S0
cmovge P1, S0
cmovge S0, S2
cmovge S2, P1
cmp P3, P2
cmovle S0, P2
