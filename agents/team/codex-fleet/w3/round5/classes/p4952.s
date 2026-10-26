# n=5 model=out iset=I1 prefix14_class=4952
cmp P3, P2
cmovg S2, P3
cmovle S2, P2
mov S1, P0
cmovge P3, P2
cmp P0, P1
cmovle S1, P1
cmovl P1, P0
cmp P3, P1
cmovg P2, P3
cmovge P3, P1
cmovg P1, P2
cmp S1, S2
cmovge P2, S2
