# n=5 model=out iset=I1 prefix14_class=12541
cmp P3, P2
mov S2, P3
cmovle P3, P2
cmovl P2, S2
cmp P0, P1
cmovg S2, P0
cmovge P0, P1
cmovg P1, S2
cmp P0, P2
mov S1, P2
cmovge S1, P0
cmovge P0, P2
cmp P3, P1
mov P0, P3
