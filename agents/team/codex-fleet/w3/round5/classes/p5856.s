# n=5 model=out iset=I1 prefix14_class=5856
mov S2, P3
cmp S2, P0
cmovle S2, P0
mov S0, S2
cmovg P3, P0
mov P0, P1
cmp P2, P1
cmovl P0, P2
cmovl P2, P1
cmp P2, S2
cmovge S0, P2
cmovle S2, P2
cmp P0, P3
cmovle S1, P3
