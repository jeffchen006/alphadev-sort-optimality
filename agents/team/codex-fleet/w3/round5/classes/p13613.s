# n=5 model=out iset=I1 prefix14_class=13613
cmp P3, P2
cmovle S2, P3
cmovl P3, P2
mov S0, P1
cmovle P2, S2
cmp P0, S0
cmovle P1, P0
cmovge S0, P0
mov P0, P2
cmp P1, P0
cmovge P0, P1
cmovl P2, P1
cmp S0, P3
cmovg P2, S0
