# n=5 model=out iset=I1 prefix14_class=9627
cmp P1, P0
mov S2, P0
cmovge P0, P1
cmovge P1, S2
cmp P3, P2
cmovle S2, P2
cmovg S2, P3
cmovg P3, P2
mov P2, P0
cmp P0, S2
cmovge P0, S2
cmovl P2, S2
cmp P1, P3
cmovge P2, P1
