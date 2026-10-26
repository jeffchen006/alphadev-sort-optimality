# n=5 model=out iset=I1 prefix14_class=6751
cmp P3, P0
mov S0, P2
cmovle S1, P0
cmovge S1, P3
cmovg P3, P0
cmp P2, P1
cmovge S0, P1
cmovl P2, P1
cmp S1, P2
cmovge P1, S1
cmovge S1, P2
cmovge P2, P1
cmp P3, S0
mov P2, S1
