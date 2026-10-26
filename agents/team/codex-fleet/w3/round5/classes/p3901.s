# n=5 model=out iset=I1 prefix14_class=3901
mov S0, P2
cmp P2, P0
cmovge P2, P0
cmovge P0, S0
cmp P1, P3
cmovl S1, P1
mov S0, P2
cmovl P1, P3
cmovl P3, S1
cmp S0, P3
cmovle S0, P3
cmovle P3, P2
mov P3, S0
cmp P1, P0
