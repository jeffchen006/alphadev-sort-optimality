# n=5 model=out iset=I1 prefix14_class=10691
cmp P0, P2
cmovle S0, P2
mov S2, P3
cmovl P2, P0
cmovl P0, S0
cmp P3, P1
cmovge P3, P1
cmovg P1, S2
mov S2, P1
cmp P0, P1
cmovl P1, P0
cmovle P0, S2
cmp P2, P3
cmovge S2, P2
