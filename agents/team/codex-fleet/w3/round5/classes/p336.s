# n=5 model=out iset=I1 prefix14_class=336
mov S1, P2
cmp P2, P0
cmovge P2, P0
cmovge P0, S1
cmp P1, P3
mov S2, P3
cmovg P3, P1
cmovg P1, S2
mov S2, P1
cmp P2, P1
cmovle S2, P2
cmovl P2, P1
cmp P3, P0
cmovl P1, P2
