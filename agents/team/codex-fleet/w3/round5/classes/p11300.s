# n=5 model=out iset=I1 prefix14_class=11300
mov S2, P1
cmp P0, P3
cmovle S1, P3
cmovg S1, P0
cmovl P3, P0
cmp S2, P2
cmovl S2, P2
cmovl P2, P1
cmp S1, S2
cmovge P1, S1
cmovge S1, S2
cmovg S2, P1
mov S2, P3
cmp P3, P2
