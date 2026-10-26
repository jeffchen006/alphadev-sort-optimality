# n=5 model=out iset=I1 prefix14_class=14379
cmp P1, P3
cmovle S0, P1
mov S1, P2
cmovl P1, P3
cmovl P3, S0
cmp P2, P0
cmovge P2, P0
cmovge P0, S1
mov S1, P2
cmp P3, S1
cmovle S1, P3
cmovg P2, P3
mov S1, P1
cmp P0, S1
