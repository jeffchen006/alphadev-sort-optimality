# n=5 model=out iset=I1 prefix14_class=2875
mov S2, P2
cmp S2, P1
cmovle S2, P1
cmovl P1, P2
mov P2, P0
cmp P0, P3
cmovl P0, P3
cmovge P2, P3
mov P3, S2
cmp P0, S2
cmovl S2, P0
cmovle P0, P3
cmp P1, P2
cmovl S1, P1
