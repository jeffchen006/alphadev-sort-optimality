# n=5 model=out iset=I1 prefix14_class=5039
mov S2, P0
cmp P2, P0
mov S1, P1
cmovg S2, P2
cmovle P0, P2
cmp P3, S1
cmovl S1, P3
cmovg P1, P3
mov P3, S1
cmp P0, S1
cmovge S1, P0
cmovle P3, P0
cmp P1, S2
cmovl P2, S2
