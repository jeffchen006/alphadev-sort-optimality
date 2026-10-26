# n=5 model=out iset=I1 prefix14_class=92
cmp P2, P0
mov S1, P1
cmovle S2, P0
cmovg S2, P2
cmovge P2, P0
cmp P3, S1
cmovle S1, P3
cmovg P1, P3
mov P3, P1
cmp P2, S1
cmovle P0, S1
cmovl S1, P2
cmovg P0, P2
cmp P3, S2
