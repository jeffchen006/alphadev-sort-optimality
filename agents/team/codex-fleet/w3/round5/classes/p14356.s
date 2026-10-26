# n=5 model=out iset=I1 prefix14_class=14356
cmp P2, P1
cmovg S0, P2
cmovle S0, P1
cmovge P2, P1
cmp P0, P3
cmovle P1, P0
cmovl P0, P3
mov S2, P2
cmovle P3, P1
cmp P3, S2
cmovg P2, P3
mov S1, S0
cmovg P3, S2
cmp P0, S1
