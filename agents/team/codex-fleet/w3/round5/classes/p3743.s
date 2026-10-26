# n=5 model=out iset=I1 prefix14_class=3743
mov S0, P1
cmp P3, S0
cmovle S0, P3
cmovg P1, P3
cmp P2, P0
mov S1, P1
cmovge S2, P0
cmovg P0, P2
cmovge P2, S2
cmp P2, S0
mov P3, S0
cmovl P3, P2
cmovge S0, P2
cmp S1, P0
