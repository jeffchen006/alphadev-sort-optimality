# n=5 model=out iset=I1 prefix14_class=8123
mov S1, P3
cmp P2, P3
cmovl P3, P2
cmovle P2, S1
cmp P0, P1
cmovl S0, P1
mov S1, P3
cmovle P1, P0
cmovl P0, S0
cmp S1, P1
cmovge P3, P1
cmovle S1, P1
cmp P0, P2
mov P1, P0
