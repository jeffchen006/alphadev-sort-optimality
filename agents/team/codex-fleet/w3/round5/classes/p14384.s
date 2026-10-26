# n=5 model=out iset=I1 prefix14_class=14384
cmp P2, P1
cmovle S2, P2
cmovg S2, P1
cmovl P2, P1
cmp P0, P3
cmovge P1, P0
mov S1, S2
cmovge P0, P3
cmovg P3, P1
cmp S1, P0
cmovle S2, P0
cmovg S1, P0
mov S1, P3
cmp S1, P2
