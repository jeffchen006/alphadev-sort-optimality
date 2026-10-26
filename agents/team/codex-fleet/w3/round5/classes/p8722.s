# n=5 model=out iset=I1 prefix14_class=8722
cmp P2, P3
cmovg S2, P2
cmovg P2, P3
cmovg P3, S2
mov S1, P0
cmp S1, P1
cmovle P0, P1
cmovl P1, S1
mov S1, P0
cmp P3, S1
cmovle S1, P3
cmovge P0, P3
cmp P1, P2
mov P3, P1
