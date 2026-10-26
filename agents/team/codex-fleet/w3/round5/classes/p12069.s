# n=5 model=out iset=I1 prefix14_class=12069
cmp P1, P2
cmovge S2, P2
cmovle S2, P1
cmovl P1, P2
cmp P0, P3
cmovge S1, P0
cmovge P0, P3
cmovg P3, S1
mov S0, P0
cmp S0, S2
cmovge P0, S2
mov P2, P3
cmovl S0, S2
cmp P3, P1
