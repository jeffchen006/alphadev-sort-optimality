# n=5 model=out iset=I1 prefix14_class=12508
mov S0, P0
cmp S0, P1
cmovle S0, P1
mov S2, S0
cmovl P1, P0
mov S1, P3
cmp P2, S1
cmovle S1, P2
cmovge P3, P2
cmp P1, S1
cmovle P0, P1
cmovl P1, S1
cmovl S1, P0
mov P2, P1
