# n=5 model=out iset=I1 prefix14_class=3701
mov S1, P2
cmp S1, P1
mov S2, P0
cmovge P2, P1
cmovle S1, P1
mov P1, P2
cmp S2, P3
cmovl S2, P3
cmovl P3, P0
cmp P2, P3
cmovl P1, P3
cmovl P3, P2
cmp S2, S1
cmovle P2, S1
