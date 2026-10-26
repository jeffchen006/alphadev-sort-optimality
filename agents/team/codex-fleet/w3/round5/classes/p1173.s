# n=5 model=out iset=I1 prefix14_class=1173
cmp P2, P0
mov S0, P2
cmovl P2, P0
cmovle P0, S0
cmp P3, P1
mov S2, P3
cmovle S2, P1
cmovg P3, P1
cmp P2, S2
cmovle P1, S2
cmovge P1, P2
cmovge P2, S2
cmp P3, P0
cmovge S1, P3
