# n=5 model=out iset=I1 prefix14_class=11911
mov S2, P0
cmp S2, P1
cmovle P0, P1
cmovl P1, S2
cmp P2, P3
cmovle S0, P3
mov S1, P1
cmovl P3, P2
cmovle P2, S0
cmp P2, P0
cmovge S0, P2
cmovge P2, P0
cmovg P0, S0
cmp P3, P1
