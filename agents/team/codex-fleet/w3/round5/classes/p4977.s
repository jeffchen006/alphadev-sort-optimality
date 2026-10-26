# n=5 model=out iset=I1 prefix14_class=4977
mov S2, P2
cmp S2, P0
mov S1, P3
cmovl S2, P0
cmovle P0, P2
cmp P1, S1
cmovge P3, P1
cmovge P1, S1
cmp P1, P0
cmovle S0, P0
cmovle P0, P1
cmovl P1, S0
mov P2, S2
cmp S2, P3
