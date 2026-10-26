# n=5 model=out iset=I1 prefix14_class=451
cmp P1, P2
mov S2, P2
cmovl P2, P1
cmovg S2, P1
mov P1, P3
cmp P3, P0
cmovge P3, P0
cmovg P0, P1
mov P1, P2
cmp P3, P2
cmovl P2, P3
cmovle P3, P1
mov P2, P0
cmp P2, S2
