# n=5 model=out iset=I1 prefix14_class=11233
cmp P1, P0
cmovg S1, P1
cmovge P1, P0
cmovg P0, S1
cmp P3, P2
cmovl S2, P2
cmovle P2, P3
cmovl P3, S2
mov S2, P0
cmp P3, S2
cmovge P0, P3
cmovg P3, S2
cmp P1, P2
mov P0, P1
