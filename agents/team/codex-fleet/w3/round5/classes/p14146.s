# n=5 model=out iset=I1 prefix14_class=14146
cmp P0, P1
mov S2, P3
cmovle S1, P1
cmovl P1, P0
cmovl P0, S1
cmp P2, S2
cmovg S2, P2
cmovg P2, P3
cmovg P3, S2
cmp S2, P0
cmovg P3, P0
cmovge P0, S2
cmp P2, P1
cmovg P0, P1
