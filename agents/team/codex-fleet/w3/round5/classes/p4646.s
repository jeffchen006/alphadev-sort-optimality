# n=5 model=out iset=I1 prefix14_class=4646
mov S2, P1
cmp P3, S2
cmovl P1, P3
cmovg S2, P3
cmp P0, P2
cmovl S1, P2
cmovl P2, P0
cmovl P0, S1
cmp P0, S2
mov P3, P0
cmovge P0, S2
cmovl P3, S2
cmovle S2, P0
mov P3, P2
