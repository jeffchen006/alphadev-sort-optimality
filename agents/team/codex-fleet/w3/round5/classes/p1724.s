# n=5 model=out iset=I1 prefix14_class=1724
cmp P0, P1
mov S2, P1
cmovge S2, P0
cmovle P1, P0
cmp P2, P3
mov P0, P1
cmovle S0, P3
cmovl P3, P2
cmovl P2, S0
cmp P3, P1
cmovl P0, P3
cmovg P1, P3
cmp S2, P2
cmovg P0, P2
