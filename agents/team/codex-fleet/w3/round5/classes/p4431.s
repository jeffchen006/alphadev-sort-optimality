# n=5 model=out iset=I1 prefix14_class=4431
mov S2, P2
cmp P3, P2
cmovge S2, P3
cmovg P3, P2
cmp P0, P1
cmovle S0, P0
cmovge S0, P1
cmovl P0, P1
cmp S2, P0
mov P1, S2
cmovle S2, P0
cmovg P1, P0
mov P0, P3
cmp P3, S0
