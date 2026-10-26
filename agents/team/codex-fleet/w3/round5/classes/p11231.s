# n=5 model=out iset=I1 prefix14_class=11231
mov S1, P1
cmp P1, P3
cmovge P1, P3
cmovg P3, S1
cmp P0, P2
cmovle S0, P2
mov S1, P3
cmovl P2, P0
cmovle P0, S0
cmp P0, S1
cmovg P3, P0
cmovg P0, S1
mov S1, P0
cmp P2, P1
