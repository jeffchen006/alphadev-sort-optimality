# n=5 model=out iset=I1 prefix14_class=13623
cmp P0, P3
cmovle S0, P0
cmovl P0, P3
mov S1, P1
cmovle P3, S0
cmp P2, S1
cmovge P1, P2
mov S2, P3
cmovge P2, S1
cmp P3, P2
cmovge S2, P2
cmovl P3, P2
cmp P0, P1
cmovg P2, P1
