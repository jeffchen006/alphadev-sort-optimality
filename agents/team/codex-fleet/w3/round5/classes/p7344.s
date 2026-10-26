# n=5 model=out iset=I1 prefix14_class=7344
mov S0, P0
mov S2, P3
cmp P1, S0
cmovge P0, P1
cmovl S0, P1
cmp P2, S2
cmovle S2, P2
cmovle P2, P3
cmp S0, S2
cmovl P1, S0
mov P3, P2
cmovle S0, S2
cmovl S2, P1
cmp P2, P0
