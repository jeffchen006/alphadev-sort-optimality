# n=5 model=out iset=I1 prefix14_class=9381
cmp P2, P1
cmovge S0, P1
cmovge P1, P2
mov S1, P1
cmovge P2, S0
cmp P3, P0
cmovle S0, P3
cmovl P3, P0
cmovl P0, S0
cmp P0, P2
mov S2, P0
cmovg S2, P2
cmovg P2, P0
cmp S1, P3
