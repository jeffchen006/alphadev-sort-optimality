# n=5 model=out iset=I1 prefix14_class=908
mov S1, P3
cmp P3, P0
cmovl S1, P0
cmovle P0, P3
mov S2, P2
cmp P2, P1
mov P3, S1
cmovg P2, P1
cmovge P1, S2
cmp P1, P3
cmovl P3, P1
cmovg S1, P1
mov S1, P0
mov P1, P3
