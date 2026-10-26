# n=5 model=out iset=I1 prefix14_class=3519
mov S2, P3
cmp P3, P2
cmovg S2, P2
cmovge P2, P3
cmp P0, P1
cmovle S0, P0
mov P3, S2
cmovl P0, P1
cmovle P1, S0
cmp P1, S2
cmovg S2, P1
cmovg P1, P3
mov S1, P2
cmp P0, P2
