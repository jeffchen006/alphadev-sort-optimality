# n=5 model=out iset=I1 prefix14_class=3573
cmp P1, P2
cmovle S1, P1
cmovle P1, P2
cmovle P2, S1
mov S2, P3
cmp P0, S2
cmovg S2, P0
cmovle P3, P0
mov S1, P3
cmp P2, P3
cmovge P3, P2
cmovl S1, P2
cmp P1, S2
mov P2, P3
