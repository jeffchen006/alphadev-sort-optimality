# n=5 model=out iset=I1 prefix14_class=2165
mov S1, P0
cmp P0, P1
cmovl P0, P1
cmovge S1, P1
cmp P2, P3
cmovl P1, P3
cmovl P3, P2
cmovl P2, P1
mov S2, P0
cmp P2, S2
cmovle S2, P2
cmovge P0, P2
cmp S1, P3
cmovl P2, P3
