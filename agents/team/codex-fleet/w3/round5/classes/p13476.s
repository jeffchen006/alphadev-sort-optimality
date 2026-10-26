# n=5 model=out iset=I1 prefix14_class=13476
cmp P0, P2
cmovle S1, P2
cmovg S1, P0
cmovl P2, P0
cmp P3, P1
cmovle P0, P3
cmovl P3, P1
cmovge P0, P1
cmp P2, P0
cmovg P1, P0
cmovg P0, P2
cmovg P2, P1
cmp S1, P3
cmovg P1, P3
