# n=5 model=out iset=I1 prefix14_class=5386
cmp P1, P0
cmovl S1, P0
cmovle P0, P1
cmovl P1, S1
mov S0, P3
cmp S0, P2
cmovle S0, P2
cmovge P3, P2
cmp P0, P3
cmovge P2, P3
cmovg P3, P0
cmovl P2, P0
mov P0, P1
cmp S0, P1
