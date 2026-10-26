# n=5 model=out iset=I1 prefix14_class=2180
cmp P0, P1
mov S1, P0
cmovge P0, P1
cmovle S1, P1
cmp P2, P3
cmovl P1, P3
mov S2, S1
cmovle P3, P2
cmovl P2, P1
cmp P2, S2
cmovg S1, P2
cmovl S2, P2
cmp P0, P3
cmovge P2, P3
