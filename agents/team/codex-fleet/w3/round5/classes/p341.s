# n=5 model=out iset=I1 prefix14_class=341
mov S1, P2
cmp P2, P3
cmovg S1, P3
cmovge P3, P2
mov P2, P0
cmp P2, P1
cmovge P0, P1
cmovg P1, P2
mov P2, P0
cmp S1, P0
cmovl P2, S1
cmovle S1, P0
cmp P1, P3
mov P0, S1
