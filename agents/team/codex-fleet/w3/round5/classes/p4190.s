# n=5 model=out iset=I1 prefix14_class=4190
cmp P0, P1
cmovle S2, P1
cmovg S2, P0
cmovl P1, P0
cmovg P0, P1
cmp P3, P2
cmovl S1, P3
cmovle P3, P2
cmovl P2, S1
cmp P2, P0
cmovge P1, P2
cmovle P0, P2
mov P0, P3
cmp P3, S2
