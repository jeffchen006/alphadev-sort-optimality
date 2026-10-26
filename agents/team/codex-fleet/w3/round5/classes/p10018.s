# n=5 model=out iset=I1 prefix14_class=10018
cmp P3, P1
mov S1, P3
cmovg S1, P1
cmovge P1, P3
cmp P2, P0
cmovg P3, P0
cmovge P0, P2
cmovg P2, P3
mov P3, S1
cmp P0, P1
cmovle S2, P0
cmovle P0, P1
cmovl P1, S2
cmp P3, P2
