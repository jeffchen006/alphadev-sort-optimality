# n=5 model=out iset=I1 prefix14_class=13768
mov S2, P1
cmp P2, P1
mov S1, P3
cmovle P1, P2
cmovl P2, S2
cmp P3, P0
cmovg P3, P0
cmovge P0, S1
cmp P0, P2
cmovle S0, P0
cmovl P0, P2
mov P0, P1
cmovle P2, S0
cmp P3, P1
