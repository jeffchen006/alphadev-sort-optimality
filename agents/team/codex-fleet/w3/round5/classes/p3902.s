# n=5 model=out iset=I1 prefix14_class=3902
mov S0, P2
cmp P2, P0
cmovge P2, P0
cmovge P0, S0
cmp P1, P3
mov S2, P2
cmovl S0, P1
cmovl P1, P3
cmovl P3, S0
cmp S2, P3
cmovle S2, P3
cmovle P3, P2
mov P3, S2
cmp P1, P0
