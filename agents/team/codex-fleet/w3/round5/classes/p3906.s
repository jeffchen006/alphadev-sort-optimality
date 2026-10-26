# n=5 model=out iset=I1 prefix14_class=3906
mov S0, P1
cmp P1, P0
cmovge P1, P0
cmovg P0, S0
cmp P3, P2
mov S0, P3
cmovl P3, P2
cmovle P2, S0
cmp P1, P2
cmovge S2, P1
cmovle S2, P2
cmovl P2, P1
mov P2, S2
cmp P3, P0
