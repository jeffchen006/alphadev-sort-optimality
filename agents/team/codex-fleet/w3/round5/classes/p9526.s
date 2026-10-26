# n=5 model=out iset=I1 prefix14_class=9526
cmp P0, P2
cmovge S0, P2
cmovle S0, P0
cmovle P0, P2
mov S1, P1
cmp S1, P3
cmovge S1, P3
cmovle P1, P3
cmp S0, S1
cmovl S2, S0
cmovl S0, S1
cmovge S2, S1
cmovge S1, S0
mov S2, P0
