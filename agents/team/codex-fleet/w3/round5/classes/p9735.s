# n=5 model=out iset=I1 prefix14_class=9735
cmp P1, P2
cmovge S1, P2
cmovle S1, P1
cmovg P2, P1
cmp P0, P3
mov S2, P0
cmovl P0, P3
cmovl P3, S2
cmp P2, P0
cmovge S0, P2
cmovge P2, P0
cmovge P0, S0
mov S2, P3
cmp S2, S1
