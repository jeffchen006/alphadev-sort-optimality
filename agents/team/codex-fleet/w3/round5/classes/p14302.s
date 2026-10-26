# n=5 model=out iset=I1 prefix14_class=14302
mov S1, P0
cmp P1, S1
cmovl P0, P1
cmovg S1, P1
mov S2, P2
cmp P2, P3
cmovle S2, P3
cmovge P2, P3
cmp P2, P0
cmovge P3, P2
cmovg P2, P0
cmovg P0, P3
mov P1, P0
cmp S1, S2
