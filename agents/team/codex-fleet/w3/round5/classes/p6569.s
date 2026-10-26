# n=5 model=out iset=I1 prefix14_class=6569
cmp P2, P1
cmovle S1, P1
cmovge S1, P2
cmovge P2, P1
cmp P0, P3
mov S0, P0
cmovl S0, P3
cmovl P3, P0
cmp S0, S1
cmovle P1, S1
cmovle S1, S0
mov P0, S1
cmovle S0, P1
cmp P2, P3
