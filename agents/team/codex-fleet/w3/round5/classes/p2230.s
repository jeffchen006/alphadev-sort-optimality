# n=5 model=out iset=I1 prefix14_class=2230
cmp P1, P3
mov S1, P3
cmovge P3, P1
cmovg P1, S1
cmp P2, P0
cmovge S0, P2
cmovle S0, P0
mov S1, S0
cmovge P2, P0
cmp S1, P3
cmovl S0, P3
cmovl P3, S1
cmp P1, P2
cmovge S1, P2
