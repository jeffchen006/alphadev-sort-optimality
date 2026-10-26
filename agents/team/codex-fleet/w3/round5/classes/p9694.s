# n=5 model=out iset=I1 prefix14_class=9694
cmp P2, P1
cmovg S2, P2
mov S1, P0
cmovge P2, P1
cmovg P1, S2
cmp P3, S1
cmovle P0, P3
cmovg S1, P3
cmovl P3, S1
cmp S1, P1
cmovl S1, P1
cmovg P3, P1
cmp P2, P0
mov P1, P3
