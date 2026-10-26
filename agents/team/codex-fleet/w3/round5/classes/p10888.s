# n=5 model=out iset=I1 prefix14_class=10888
cmp P1, P2
mov S2, P2
cmovge P2, P1
cmovle S2, P1
cmp P0, P3
cmovge S0, P3
cmovg P3, P0
mov S1, P3
cmovge P0, S0
cmp S1, P2
cmovl P3, P2
cmovl P2, S1
cmp S2, P0
cmovle S1, P0
