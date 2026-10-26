# n=5 model=out iset=I1 prefix14_class=12982
cmp P3, P1
cmovge S1, P3
cmovg P3, P1
cmovle S1, P1
mov P1, P0
cmp P2, P0
cmovl P1, P2
cmovl P2, P0
cmp P1, P3
cmovge S2, P3
cmovge P3, P1
cmovg P1, S2
cmp S1, P2
mov S0, P3
