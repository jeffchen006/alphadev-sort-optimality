# n=5 model=out iset=I1 prefix14_class=5872
mov S1, P2
mov S2, P3
cmp P1, S1
cmovge P2, P1
cmovg P1, S1
cmp P0, P3
cmovl S2, P0
mov S1, P2
cmovl P0, P3
cmp P0, S1
cmovg S1, P0
cmovle P2, P0
mov P0, P1
mov S1, P2
