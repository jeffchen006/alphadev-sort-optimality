# n=5 model=out iset=I1 prefix14_class=6119
cmp P1, P0
cmovle S1, P0
cmovl P0, P1
cmovg S1, P1
cmp P3, P2
cmovge P1, P2
cmovge P2, P3
cmovg P3, P1
mov P1, S1
cmp P1, P2
cmovg P1, P2
cmovg P2, S1
cmp P3, P0
cmovg P2, P0
