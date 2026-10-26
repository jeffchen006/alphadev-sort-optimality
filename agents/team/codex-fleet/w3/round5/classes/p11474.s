# n=5 model=out iset=I1 prefix14_class=11474
cmp P2, P0
cmovle S2, P0
cmovl P0, P2
cmovg S2, P2
cmp P1, P3
cmovg S1, P1
cmovge P1, P3
cmovg P3, S1
cmp P0, P1
mov P2, P0
cmovle P0, P1
cmovle P1, P2
cmovl P2, P0
cmp S2, P3
