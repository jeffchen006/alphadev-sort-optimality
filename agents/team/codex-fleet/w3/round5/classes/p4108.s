# n=5 model=out iset=I1 prefix14_class=4108
mov S1, P1
mov S2, P2
cmp P0, S1
cmovg S1, P0
cmovl P1, P0
cmp P3, S2
cmovg P2, P3
cmovge P3, S2
cmovle S2, P3
cmp P1, S2
cmovg P3, P1
cmovg P1, S2
cmp P2, S1
cmovg P0, S1
