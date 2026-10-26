# n=5 model=out iset=I1 prefix14_class=8214
cmp P1, P0
cmovg S0, P1
cmovge P1, P0
cmovle S0, P0
cmp P2, P3
cmovle P0, P2
cmovl P2, P3
cmovle P3, P0
mov S1, P2
cmp P1, P3
cmovge S2, P3
cmovge P3, P1
cmovg P1, S2
cmp P2, S0
