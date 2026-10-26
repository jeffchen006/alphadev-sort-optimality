# n=5 model=out iset=I1 prefix14_class=4224
mov S0, P2
cmp P0, P1
cmovle S1, P1
cmovge S1, P0
cmovg P0, P1
cmp P3, P2
cmovge S0, P3
cmovg P3, P2
cmp P3, P0
cmovl P1, P0
cmovl P0, P3
cmovge P1, P3
cmp S1, S0
cmovle S2, S0
