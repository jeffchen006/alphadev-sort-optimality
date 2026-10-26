# n=5 model=out iset=I1 prefix14_class=13585
mov S1, P3
cmp P2, P0
cmovle S2, P0
cmovle P0, P2
cmovle P2, S2
cmp P1, S1
cmovl P3, P1
cmovg S1, P1
cmp P0, P3
cmovg S2, P0
mov P1, S1
cmovge P0, P3
cmovg P3, S2
cmp P1, P2
