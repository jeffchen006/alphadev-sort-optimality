# n=5 model=out iset=I1 prefix14_class=14400
mov S0, P2
mov S1, P1
cmp P3, P2
cmovle S0, P3
cmovl P3, P2
mov S2, P3
cmp S1, P0
cmovge P1, P0
cmovle S1, P0
cmp P1, S0
cmovle P0, S0
cmovl S0, P1
cmovle P1, P0
mov P2, P1
