# n=5 model=out iset=I1 prefix14_class=3060
mov S1, P2
cmp P0, S1
cmovge S1, P0
cmovg P0, P2
mov P2, P1
cmp P3, P2
cmovle P2, P3
cmovl P3, P1
cmp P2, P0
cmovg P1, P2
cmovg P2, P0
cmovg P0, P1
cmp S1, P3
cmovle S0, P3
