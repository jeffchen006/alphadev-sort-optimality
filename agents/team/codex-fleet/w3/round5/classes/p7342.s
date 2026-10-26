# n=5 model=out iset=I1 prefix14_class=7342
mov S0, P0
cmp P3, P0
cmovl S0, P3
mov S2, P1
cmovge P0, P3
cmp P2, P1
cmovle P1, P2
cmovl P2, S2
cmp S0, P1
cmovle S2, S0
cmovle S0, P1
mov P3, P0
cmovl P1, S2
cmp P3, P2
