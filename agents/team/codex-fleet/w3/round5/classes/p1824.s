# n=5 model=out iset=I1 prefix14_class=1824
cmp P0, P2
cmovge S2, P2
cmovg P2, P0
cmovg P0, S2
mov S0, P1
cmp P3, S0
cmovge P1, P3
cmovge P3, S0
cmp P1, P2
cmovle S0, P1
cmovge S0, P2
cmovle P1, P2
cmp P3, P0
cmovl P2, P0
