# n=5 model=out iset=I1 prefix14_class=3063
cmp P0, P2
cmovge S1, P2
cmovge P2, P0
cmovg P0, S1
cmp P3, P1
cmovge S1, P1
cmovle S1, P3
cmovl P3, P1
cmp S1, P0
cmovge P1, S1
mov S0, P3
cmovge S1, P0
cmovg P0, P1
mov S1, P0
