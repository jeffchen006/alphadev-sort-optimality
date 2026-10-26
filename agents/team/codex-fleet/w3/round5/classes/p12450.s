# n=5 model=out iset=I1 prefix14_class=12450
mov S0, P0
cmp P2, P3
mov S2, P2
cmovle P2, P3
cmovl P3, S2
cmp S0, P1
cmovle S0, P1
cmovge P0, P1
cmp P0, P3
cmovl P1, P0
mov S1, S0
cmovl P0, P3
cmovl P3, P1
cmp P2, S1
