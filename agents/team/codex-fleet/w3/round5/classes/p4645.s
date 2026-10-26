# n=5 model=out iset=I1 prefix14_class=4645
mov S2, P1
cmp P3, S2
cmovle P1, P3
cmovg S2, P3
cmp P0, P2
cmovl S1, P2
cmovl P2, P0
cmovl P0, S1
cmp P0, S2
mov P3, P0
cmovle P3, S2
cmovge P0, S2
mov S2, P0
mov P3, P1
