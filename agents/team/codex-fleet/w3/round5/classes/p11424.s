# n=5 model=out iset=I1 prefix14_class=11424
mov S0, P2
cmp P1, P3
cmovge S1, P1
cmovle S1, P3
cmovge P1, P3
cmp S0, P0
cmovg P2, P0
cmovg P0, S0
cmp P2, P1
mov S2, P2
cmovl S2, P1
cmovl P1, P2
cmp P0, S1
cmovge P2, S1
