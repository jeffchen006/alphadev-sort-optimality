# n=5 model=out iset=I1 prefix14_class=6113
mov S1, P3
cmp P3, P2
cmovle S1, P2
cmovl P2, P3
cmp P0, P1
cmovge P3, P0
cmovl P3, P1
cmovge P0, P1
cmovg P1, P3
cmp P3, S1
cmovge P1, S1
cmovg S1, P3
cmp P0, P2
cmovg P3, P0
