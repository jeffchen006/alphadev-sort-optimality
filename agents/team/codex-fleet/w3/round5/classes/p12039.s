# n=5 model=out iset=I1 prefix14_class=12039
mov S0, P3
cmp P2, P3
cmovge P3, P2
cmovge P2, S0
cmp P1, P0
mov S0, P0
cmovle P0, P1
cmovl P1, S0
cmovle S0, P0
cmp P0, P2
cmovl P0, P2
cmovge S0, P2
cmp P3, P1
cmovl S2, P1
