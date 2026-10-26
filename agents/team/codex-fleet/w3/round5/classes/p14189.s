# n=5 model=out iset=I1 prefix14_class=14189
cmp P3, P1
cmovle S2, P3
cmovle P3, P1
cmovle P1, S2
mov S1, P0
cmp P0, P2
cmovl P0, P2
cmovg S1, P2
cmp P0, P3
cmovg P2, P3
cmovge P3, P0
cmovg P0, P2
mov P3, S1
cmp P1, P3
