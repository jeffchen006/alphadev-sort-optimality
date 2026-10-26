# n=5 model=out iset=I1 prefix14_class=11768
mov S0, P2
cmp P2, P3
cmovge S0, P3
cmovg P3, P2
cmp P0, P1
cmovle S1, P0
cmovle P0, P1
cmovl P1, S1
cmp P0, P3
mov S2, P3
cmovge S2, P0
cmovge P0, P3
cmp P1, S0
cmovge P3, P1
