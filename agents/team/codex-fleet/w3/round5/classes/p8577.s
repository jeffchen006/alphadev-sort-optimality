# n=5 model=out iset=I1 prefix14_class=8577
cmp P2, P0
cmovl S2, P2
mov S0, P1
cmovle P2, P0
cmovl P0, S2
cmp S0, P3
cmovge P1, P3
cmovle S0, P3
cmp P2, S0
cmovle P3, P2
cmovg P3, S0
cmovl P2, S0
cmp P1, P0
cmovle P2, P1
