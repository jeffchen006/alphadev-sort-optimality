# n=5 model=out iset=I1 prefix14_class=1176
cmp P1, P0
mov S2, P1
cmovl P1, P0
cmovle P0, S2
cmp P3, P2
mov S0, P3
cmovle S0, P2
cmovg P3, P2
cmp P1, S0
cmovle P2, S0
cmovg P2, P1
cmovge P1, S0
cmp P0, P3
cmovge P2, P0
