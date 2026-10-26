# n=5 model=out iset=I1 prefix14_class=12575
cmp P3, P0
cmovg S1, P3
cmovle S1, P0
cmovge P3, P0
mov P0, P1
cmp P2, P1
cmovl P0, P2
cmovle P2, P1
cmp P0, P3
cmovle S2, P3
cmovle P3, P0
cmovle P0, S2
cmp P2, S1
cmovge P3, P2
