# n=5 model=out iset=I1 prefix14_class=13416
cmp P2, P0
cmovge S2, P2
cmovg P2, P0
mov S1, P1
cmovge P0, S2
cmp P3, P1
cmovg S1, P3
cmovle P1, P3
mov P3, P2
cmp P2, P1
cmovl P2, P1
cmovle P1, P3
cmp P0, S1
cmovg P3, P0
