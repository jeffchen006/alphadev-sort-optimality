# n=5 model=out iset=I1 prefix14_class=14342
cmp P1, P2
mov S2, P1
cmovle P1, P2
cmovl P2, S2
cmp P3, P0
cmovle S1, P3
cmovle P3, P0
cmovl P0, S1
cmp P0, P2
mov S2, P0
cmovg S2, P2
cmovg P2, P0
mov P0, P3
mov S2, P2
