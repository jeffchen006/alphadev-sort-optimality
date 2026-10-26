# n=5 model=out iset=I1 prefix14_class=11167
cmp P1, P3
cmovg S2, P3
cmovge P3, P1
cmovle S2, P1
cmp P2, P0
cmovg S1, P0
cmovg P0, P2
mov P1, P3
cmovg P2, S1
cmp P0, P1
cmovl P3, P0
cmovl P0, P1
mov P0, P2
cmp S2, P0
