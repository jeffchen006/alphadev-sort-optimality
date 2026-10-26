# n=5 model=out iset=I1 prefix14_class=12308
mov S1, P3
cmp P1, P2
mov S2, P2
cmovle S2, P1
cmovl P1, P2
cmp P0, P3
cmovg S1, P0
cmovle P3, P0
cmp P3, S2
cmovge P0, P3
cmovg P3, S2
cmovg S2, P0
mov S0, S2
cmp P1, S1
