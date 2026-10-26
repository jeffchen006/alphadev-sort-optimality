# n=5 model=out iset=I1 prefix14_class=8571
cmp P3, P1
cmovle S2, P3
cmovle P3, P1
cmovl P1, S2
mov S0, P0
cmp S0, P2
cmovg P0, P2
cmovle S0, P2
cmovge P2, S0
cmp P2, P3
cmovg P2, P3
cmovl S0, P3
mov S0, P0
cmp S0, P1
