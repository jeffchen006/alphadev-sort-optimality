# n=5 model=out iset=I1 prefix14_class=5413
cmp P0, P2
cmovg S1, P2
cmovg P2, P0
cmovg P0, S1
mov S2, P3
cmp P3, P1
cmovl P3, P1
cmovle P1, S2
mov S2, P1
cmp P1, P0
cmovg P1, P0
cmovg P0, S2
cmp P2, P3
cmovge S2, P2
