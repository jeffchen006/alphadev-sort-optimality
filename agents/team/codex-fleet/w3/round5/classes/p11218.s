# n=5 model=out iset=I1 prefix14_class=11218
mov S2, P0
cmp P1, S2
cmovg S2, P1
cmovl P0, P1
cmp P3, P2
cmovge S1, P2
cmovge P2, P3
cmovg P3, S1
cmp P2, S2
mov P1, P2
cmovg P1, S2
cmovle P2, S2
cmp P3, P0
cmovge S2, P3
