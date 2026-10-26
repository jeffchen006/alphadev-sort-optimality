# n=5 model=out iset=I1 prefix14_class=593
cmp P2, P1
cmovle S2, P2
mov S1, P0
cmovg S2, P1
cmovl P2, P1
cmovge P1, P2
cmp P0, P3
cmovge S1, P3
cmovge P3, P0
cmp P3, P1
cmovl P1, P3
cmovg P2, P3
cmp S2, S1
mov P0, S2
