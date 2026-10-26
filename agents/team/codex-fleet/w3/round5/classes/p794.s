# n=5 model=out iset=I1 prefix14_class=794
mov S1, P0
cmp S1, P2
cmovg P0, P2
mov S2, P1
cmovle S1, P2
cmp S2, P3
cmovg S2, P3
cmovl P1, P3
cmovge P3, P1
cmp P3, S1
cmovge P3, S1
cmovg S1, P1
cmovge P1, P3
cmp P0, S2
