# n=5 model=out iset=I1 prefix14_class=1823
cmp P2, P0
cmovge S2, P0
cmovg P0, P2
cmovg P2, S2
mov S0, P1
cmp P3, S0
cmovge P1, P3
cmovg P3, S0
cmp P1, P0
cmovle S0, P1
cmovge S0, P0
cmovle P1, P0
cmp P3, P2
cmovl P0, P2
