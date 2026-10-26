# n=5 model=out iset=I1 prefix14_class=11870
cmp P0, P1
mov S2, P1
cmovl S2, P0
mov S1, P2
cmovge P1, P0
cmp S1, P3
cmovg S1, P3
cmovl P2, P3
cmp P2, P1
cmovle P0, P2
cmovle P2, P1
cmovle P1, P0
cmp S2, S1
cmovg P3, S2
