# n=5 model=out iset=I1 prefix14_class=2603
cmp P3, P2
cmovg S1, P2
cmovg P2, P3
cmovg P3, S1
mov S1, P0
cmp P1, P0
cmovg S1, P1
cmovge P1, P0
cmp S1, P2
cmovl P0, S1
cmovle S1, P2
cmovge P0, P2
cmp P1, P3
cmovg S1, P3
