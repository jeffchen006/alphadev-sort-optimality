# n=5 model=out iset=I1 prefix14_class=10735
mov S2, P3
cmp S2, P1
cmovle P3, P1
cmovge S2, P1
cmp P0, P2
mov P1, S2
mov S0, P3
cmovle S1, P0
cmovl P0, P2
cmovl P2, S1
cmp P0, P3
cmovge P3, P0
cmovge P0, S0
mov P3, P0
