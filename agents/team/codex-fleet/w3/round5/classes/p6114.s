# n=5 model=out iset=I1 prefix14_class=6114
mov S1, P3
cmp P3, P2
cmovle S1, P2
cmovl P2, P3
cmp P0, P1
mov P3, P1
cmovge P3, P0
cmovg P0, P1
cmovg P1, P3
cmp P3, S1
cmovg P1, S1
cmovg S1, P3
cmp P0, P2
cmovle P3, P0
