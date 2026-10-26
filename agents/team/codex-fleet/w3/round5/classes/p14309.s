# n=5 model=out iset=I1 prefix14_class=14309
cmp P0, P3
mov S1, P3
mov S2, P1
cmovl S1, P0
cmovl P0, P3
cmovg P3, P0
cmp S2, P2
cmovle S2, P2
cmovg P1, P2
cmp S1, P1
cmovge P2, S1
cmovg S1, P1
cmovg P1, P2
cmp S2, P0
