# n=5 model=out iset=I1 prefix14_class=7626
cmp P3, P2
mov S2, P2
cmovg S2, P3
cmovl P2, P3
cmp P1, P0
mov P3, P1
cmovge P3, P0
cmovg P0, P1
cmp P2, P3
cmovl P1, P3
cmovl P3, P2
cmovl P2, P1
cmp P0, S2
mov P3, S2
