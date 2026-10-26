# n=5 model=out iset=I1 prefix14_class=3412
mov S2, P2
cmp P1, P2
cmovg S2, P1
cmovl P2, P1
cmp P3, P0
cmovge P1, P3
cmovge P3, P0
cmovl P1, P0
cmovl P0, P3
mov S0, S2
cmp P2, P3
cmovle P0, P2
cmovg P3, P2
mov P0, P3
