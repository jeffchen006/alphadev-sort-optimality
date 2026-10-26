# n=5 model=out iset=I1 prefix14_class=12307
cmp P1, P2
cmovle S1, P1
cmovg S1, P2
cmovl P1, P2
cmp P0, P3
mov S2, P3
cmovg S2, P0
cmovle P3, P0
cmp P3, S1
cmovge P0, P3
cmovg P3, S1
mov P2, P1
cmovg S1, P0
mov P3, S1
