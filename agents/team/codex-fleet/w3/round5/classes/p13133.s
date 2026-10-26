# n=5 model=out iset=I1 prefix14_class=13133
mov S1, P2
cmp P2, P0
cmovle S1, P0
cmovge P2, P0
cmp P3, P1
cmovle S2, P3
cmovl P3, P1
mov S0, P2
cmovl P1, S2
cmp P2, P1
cmovge S0, P1
cmovg P1, P2
cmp S1, P3
cmovl P0, P3
