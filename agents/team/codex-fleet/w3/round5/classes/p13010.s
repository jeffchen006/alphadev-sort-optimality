# n=5 model=out iset=I1 prefix14_class=13010
mov S2, P3
cmp P0, P2
cmovle S0, P2
cmovl P2, P0
cmovle P0, S0
cmp S2, P1
cmovg P3, P1
cmovle S2, P1
cmovl P1, P3
cmp P2, P3
cmovge P3, P2
cmovl P1, P2
cmp S2, P0
cmovl S0, P0
