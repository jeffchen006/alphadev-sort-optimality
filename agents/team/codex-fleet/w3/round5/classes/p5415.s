# n=5 model=out iset=I1 prefix14_class=5415
cmp P0, P2
cmovg S1, P2
cmovge P2, P0
cmovg P0, S1
cmp P3, P1
mov S2, P3
cmovl P3, P1
cmovle P1, S2
cmp P1, P0
cmovg S2, P1
cmovg P1, P0
cmovg P0, S2
cmp P3, P2
cmovle S2, P2
